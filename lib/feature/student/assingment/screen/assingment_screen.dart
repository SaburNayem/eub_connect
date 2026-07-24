import 'package:eub_connect/core/constant/app_color/app_colors.dart';
import 'package:eub_connect/core/ui/state_panels.dart';
import 'package:eub_connect/feature/common/assignment_quiz/model/assignment_quiz_models.dart';
import 'package:eub_connect/feature/student/assingment/controller/assingment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AssingmentScreen extends StatelessWidget {
  const AssingmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AssingmentController>()
        ? Get.find<AssingmentController>()
        : Get.put(AssingmentController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        surfaceTintColor: AppColors.white,
        title: const Text(
          'Assignments',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final state = controller.workspace.value;
          if (state.isLoading) {
            return const LoadingPanel();
          }
          if (state.error != null) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ErrorStatePanel(
                message: state.error!,
                onRetry: controller.load,
              ),
            );
          }

          final assignments = controller.assignments;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StudentAssignmentHeader(controller: controller),
                    const SizedBox(height: 16),
                    _SubjectFilter(
                      selectedCode: controller.selectedSubjectCode.value,
                      subjects: controller.subjects,
                      onSelected: controller.selectSubject,
                    ),
                    const SizedBox(height: 16),
                    if (assignments.isEmpty)
                      const _EmptyPanel(message: 'No assignment found')
                    else
                      for (final assignment in assignments) ...[
                        _StudentAssignmentCard(
                          assignment: assignment,
                          submission: controller.submissionFor(assignment.id),
                          onSubmit: () => _showSubmitSheet(
                            context,
                            controller,
                            assignment,
                            controller.submissionFor(assignment.id),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> _showSubmitSheet(
    BuildContext context,
    AssingmentController controller,
    CourseAssignment assignment,
    AssignmentSubmission? submission,
  ) async {
    final subject = assignment.subject;
    final fileController = TextEditingController();
    final noteController = TextEditingController(text: submission?.note ?? '');

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 18,
            right: 18,
            top: 18,
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom + 18,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _SubjectAvatar(subject: subject),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${subject.code} | Due ${_formatDate(assignment.dueAt)}',
                            style: const TextStyle(
                              color: Color(0xFF667085),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: fileController,
                  decoration: const InputDecoration(
                    labelText: 'Assignment file name',
                    prefixIcon: Icon(Icons.attach_file),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Submission note',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.notes_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () async {
                    await controller.submitAssignment(
                      assignment: assignment,
                      fileName: fileController.text,
                      note: noteController.text,
                    );
                    Get.back<void>();
                    Get.snackbar(
                      'Assignments',
                      '${assignment.title} posted successfully',
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(14),
                      backgroundColor: AppColors.primary,
                      colorText: AppColors.white,
                    );
                  },
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: Text(
                    submission == null ? 'Post assignment' : 'Update',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    fileController.dispose();
    noteController.dispose();
  }
}

class _StudentAssignmentHeader extends StatelessWidget {
  const _StudentAssignmentHeader({required this.controller});

  final AssingmentController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Submit assignments by subject',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Different courses have different tasks, resources, marks, and due dates.',
            style: TextStyle(color: Color(0xFF667085), height: 1.4),
          ),
          const SizedBox(height: 16),
          _MetricGrid(
            metrics: [
              _MetricData(
                label: 'Need submit',
                value: '${controller.openCount}',
                icon: Icons.assignment_late_outlined,
                color: const Color(0xFFB42318),
              ),
              _MetricData(
                label: 'Posted',
                value: '${controller.submittedCount}',
                icon: Icons.cloud_done_outlined,
                color: AppColors.primary,
              ),
              _MetricData(
                label: 'Reviewed',
                value: '${controller.reviewedCount}',
                icon: Icons.rate_review_outlined,
                color: AppColors.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StudentAssignmentCard extends StatelessWidget {
  const _StudentAssignmentCard({
    required this.assignment,
    required this.submission,
    required this.onSubmit,
  });

  final CourseAssignment assignment;
  final AssignmentSubmission? submission;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final subject = assignment.subject;
    final submitted = submission != null;
    final statusColor = submitted
        ? submission!.status.toLowerCase() == 'reviewed'
              ? AppColors.secondary
              : AppColors.primary
        : assignment.status.toLowerCase() == 'closed'
        ? const Color(0xFFB42318)
        : const Color(0xFFB54708);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SubjectAvatar(subject: subject),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _StatusBadge(label: subject.code, color: subject.color),
                        _StatusBadge(
                          label: submitted
                              ? submission!.status
                              : assignment.status,
                          color: statusColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      assignment.title,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${subject.name} | ${subject.teacher}',
                      style: const TextStyle(
                        color: Color(0xFF667085),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            assignment.instructions.isEmpty
                ? 'No additional instructions provided.'
                : assignment.instructions,
            style: const TextStyle(color: Color(0xFF475467), height: 1.45),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.event_outlined,
                label: 'Due ${_formatDate(assignment.dueAt)}',
              ),
              _InfoChip(
                icon: Icons.grade_outlined,
                label: '${assignment.totalMarks} marks',
              ),
              _InfoChip(
                icon: Icons.description_outlined,
                label: assignment.allowResubmission
                    ? 'Resubmission allowed'
                    : 'Single submission',
              ),
            ],
          ),
          if (submission != null) ...[
            const SizedBox(height: 14),
            _SubmissionPanel(submission: submission!),
          ],
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  final fileName = assignment.attachments.isEmpty
                      ? '${assignment.subject.code.replaceAll(' ', '-')}-${assignment.title.replaceAll(' ', '-')}.pdf'
                      : assignment.attachments.first;
                  Get.snackbar(
                    'Assignments',
                    'Mock download ready: $fileName',
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(14),
                  );
                },
                icon: const Icon(Icons.file_download_outlined),
                label: const Text('Resource'),
              ),
              FilledButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.cloud_upload_outlined),
                label: Text(submitted ? 'Update post' : 'Post assignment'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubmissionPanel extends StatelessWidget {
  const _SubmissionPanel({required this.submission});

  final AssignmentSubmission submission;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.cloud_done_outlined,
                size: 19,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  submission.status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            submission.submittedAt == null
                ? 'Not submitted yet'
                : 'Posted ${_formatDateTime(submission.submittedAt!)}',
            style: const TextStyle(color: Color(0xFF667085), fontSize: 12),
          ),
          if (submission.note.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              submission.note,
              style: const TextStyle(color: Color(0xFF475467), height: 1.35),
            ),
          ],
          if (submission.marks != null || submission.feedback != null) ...[
            const SizedBox(height: 8),
            Text(
              'Marks: ${submission.marks ?? '-'}',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            if (submission.feedback != null)
              Text(
                submission.feedback!,
                style: const TextStyle(color: Color(0xFF475467), height: 1.35),
              ),
          ],
        ],
      ),
    );
  }
}

class _SubjectFilter extends StatelessWidget {
  const _SubjectFilter({
    required this.selectedCode,
    required this.subjects,
    required this.onSelected,
  });

  final String selectedCode;
  final List<CourseSubject> subjects;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('All subjects'),
          selected: selectedCode == 'all',
          onSelected: (_) => onSelected('all'),
        ),
        for (final subject in subjects)
          ChoiceChip(
            avatar: CircleAvatar(backgroundColor: subject.color, radius: 5),
            label: Text('${subject.code}-${subject.section}'),
            selected: selectedCode == subject.sectionId,
            onSelected: (_) => onSelected(subject.sectionId),
          ),
      ],
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<_MetricData> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 720 ? 3 : 1;

        return GridView.builder(
          itemCount: metrics.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 86,
          ),
          itemBuilder: (context, index) {
            final metric = metrics[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: metric.color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: metric.color.withValues(alpha: 0.16)),
              ),
              child: Row(
                children: [
                  Icon(metric.icon, color: metric.color),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          metric.value,
                          style: TextStyle(
                            color: metric.color,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          metric.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF667085),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _MetricData {
  const _MetricData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
}

class _SubjectAvatar extends StatelessWidget {
  const _SubjectAvatar({required this.subject});

  final CourseSubject subject;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: subject.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          subject.code.split(' ').first,
          style: TextStyle(color: subject.color, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF667085)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF475467),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Text(message, style: const TextStyle(color: Color(0xFF667085))),
    );
  }
}

String _formatDate(DateTime value) {
  return DateFormat('MMM d, yyyy').format(value);
}

String _formatDateTime(DateTime value) {
  return DateFormat('MMM d, yyyy h:mm a').format(value);
}
