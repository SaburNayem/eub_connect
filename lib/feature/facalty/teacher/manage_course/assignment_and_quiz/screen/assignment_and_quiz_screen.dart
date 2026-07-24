import 'package:eub_connect/core/constant/app_color/app_colors.dart';
import 'package:eub_connect/core/ui/state_panels.dart';
import 'package:eub_connect/feature/common/assignment_quiz/model/assignment_quiz_models.dart';
import 'package:eub_connect/feature/facalty/teacher/manage_course/assignment_and_quiz/controller/assignment_and_quiz_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AssignmentAndQuizScreen extends StatelessWidget {
  const AssignmentAndQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AssignmentAndQuizController>()
        ? Get.find<AssignmentAndQuizController>()
        : Get.put(AssignmentAndQuizController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        surfaceTintColor: AppColors.white,
        title: const Text(
          'Assignment & Quiz',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          Obx(() {
            final isAssignment =
                controller.selectedMode.value == TeacherWorkMode.assignments;
            return IconButton(
              tooltip: isAssignment ? 'Publish assignment' : 'Publish quiz',
              onPressed: () {
                if (isAssignment) {
                  _showAssignmentSheet(context, controller);
                } else {
                  _showQuizSheet(context, controller);
                }
              },
              icon: Icon(isAssignment ? Icons.add_task : Icons.add_circle),
            );
          }),
        ],
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

          final isAssignment =
              controller.selectedMode.value == TeacherWorkMode.assignments;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TeacherHeader(controller: controller),
                    const SizedBox(height: 16),
                    _ModeSwitch(
                      selectedMode: controller.selectedMode.value,
                      onSelected: controller.selectMode,
                    ),
                    const SizedBox(height: 12),
                    _SubjectFilter(
                      selectedCode: controller.selectedSubjectCode.value,
                      subjects: controller.subjects,
                      onSelected: controller.selectSubject,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        onPressed: () {
                          if (isAssignment) {
                            _showAssignmentSheet(context, controller);
                          } else {
                            _showQuizSheet(context, controller);
                          }
                        },
                        icon: Icon(
                          isAssignment
                              ? Icons.assignment_add
                              : Icons.quiz_outlined,
                        ),
                        label: Text(
                          isAssignment ? 'Publish assignment' : 'Publish quiz',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (isAssignment)
                      _TeacherAssignmentList(controller: controller)
                    else
                      _TeacherQuizList(controller: controller),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> _showAssignmentSheet(
    BuildContext context,
    AssignmentAndQuizController controller,
  ) async {
    if (controller.subjects.isEmpty) {
      Get.snackbar(
        'Assignment & Quiz',
        'No assigned course sections found.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(14),
      );
      return;
    }

    var selectedSubject = controller.selectedSubjectCode.value == 'all'
        ? controller.subjects.first.sectionId
        : controller.selectedSubjectCode.value;
    final titleController = TextEditingController(
      text: 'Class task ${controller.assignments.length + 1}',
    );
    final dueController = TextEditingController(text: 'Aug 8, 2026');
    final marksController = TextEditingController(text: '20');
    final descriptionController = TextEditingController(
      text: 'Solve the assigned problem and upload one PDF with source files.',
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                    const Text(
                      'Publish assignment',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: selectedSubject,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        for (final subject in controller.subjects)
                          DropdownMenuItem(
                            value: subject.sectionId,
                            child: Text(
                              '${subject.code}-${subject.section} | ${subject.name}',
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedSubject = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Assignment title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: dueController,
                      decoration: const InputDecoration(
                        labelText: 'Due date',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: marksController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Total marks',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Instructions',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () async {
                        await controller.publishAssignment(
                          subjectCode: selectedSubject,
                          title: titleController.text,
                          dueDate: dueController.text,
                          marks: int.tryParse(marksController.text) ?? 20,
                          description: descriptionController.text,
                        );
                        Get.back<void>();
                        Get.snackbar(
                          'Assignment & Quiz',
                          'Assignment published for $selectedSubject',
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(14),
                          backgroundColor: AppColors.primary,
                          colorText: AppColors.white,
                        );
                      },
                      icon: const Icon(Icons.publish_outlined),
                      label: const Text('Publish assignment'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    titleController.dispose();
    dueController.dispose();
    marksController.dispose();
    descriptionController.dispose();
  }

  Future<void> _showQuizSheet(
    BuildContext context,
    AssignmentAndQuizController controller,
  ) async {
    if (controller.subjects.isEmpty) {
      Get.snackbar(
        'Assignment & Quiz',
        'No assigned course sections found.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(14),
      );
      return;
    }

    var selectedSubject = controller.selectedSubjectCode.value == 'all'
        ? controller.subjects.first.sectionId
        : controller.selectedSubjectCode.value;
    final titleController = TextEditingController(
      text: 'Quiz ${controller.quizzes.length + 1}',
    );
    final scheduleController = TextEditingController(text: 'Aug 6, 2026 10 AM');
    final marksController = TextEditingController(text: '15');

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                    const Text(
                      'Publish quiz',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: selectedSubject,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        for (final subject in controller.subjects)
                          DropdownMenuItem(
                            value: subject.sectionId,
                            child: Text(
                              '${subject.code}-${subject.section} | ${subject.name}',
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedSubject = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Quiz title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: scheduleController,
                      decoration: const InputDecoration(
                        labelText: 'Schedule',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: marksController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Total marks',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () async {
                        await controller.publishQuiz(
                          subjectCode: selectedSubject,
                          title: titleController.text,
                          schedule: scheduleController.text,
                          marks: int.tryParse(marksController.text) ?? 15,
                        );
                        Get.back<void>();
                        Get.snackbar(
                          'Assignment & Quiz',
                          'Quiz published for $selectedSubject',
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(14),
                          backgroundColor: AppColors.primary,
                          colorText: AppColors.white,
                        );
                      },
                      icon: const Icon(Icons.publish_outlined),
                      label: const Text('Publish quiz'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    titleController.dispose();
    scheduleController.dispose();
    marksController.dispose();
  }
}

class _TeacherHeader extends StatelessWidget {
  const _TeacherHeader({required this.controller});

  final AssignmentAndQuizController controller;

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
            'Manage class work',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Publish subject-wise assignments and quizzes, review student posts, and track quiz attempts.',
            style: TextStyle(color: Color(0xFF667085), height: 1.4),
          ),
          const SizedBox(height: 16),
          _MetricGrid(
            metrics: [
              _MetricData(
                label: 'Assignments',
                value: '${controller.assignments.length}',
                icon: Icons.assignment_outlined,
                color: AppColors.primary,
              ),
              _MetricData(
                label: 'Need review',
                value: '${controller.pendingSubmissionCount}',
                icon: Icons.rate_review_outlined,
                color: const Color(0xFFB54708),
              ),
              _MetricData(
                label: 'Open quizzes',
                value: '${controller.openQuizCount}',
                icon: Icons.quiz_outlined,
                color: AppColors.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({required this.selectedMode, required this.onSelected});

  final TeacherWorkMode selectedMode;
  final ValueChanged<TeacherWorkMode> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ModeButton(
            label: 'Assignments',
            icon: Icons.assignment_outlined,
            selected: selectedMode == TeacherWorkMode.assignments,
            onTap: () => onSelected(TeacherWorkMode.assignments),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ModeButton(
            label: 'Quizzes',
            icon: Icons.quiz_outlined,
            selected: selectedMode == TeacherWorkMode.quizzes,
            onTap: () => onSelected(TeacherWorkMode.quizzes),
          ),
        ),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? AppColors.primary : const Color(0xFFE3E6EA),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? AppColors.white : AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? AppColors.white : AppColors.textDark,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeacherAssignmentList extends StatelessWidget {
  const _TeacherAssignmentList({required this.controller});

  final AssignmentAndQuizController controller;

  @override
  Widget build(BuildContext context) {
    final assignments = controller.filteredAssignments;
    if (assignments.isEmpty) {
      return const _EmptyPanel(message: 'No assignment found');
    }

    return Column(
      children: [
        for (final assignment in assignments) ...[
          _TeacherAssignmentCard(
            assignment: assignment,
            submissions: controller.submissionsFor(assignment.id),
            onSubmissions: () =>
                _showSubmissionsSheet(context, controller, assignment),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  void _showSubmissionsSheet(
    BuildContext context,
    AssignmentAndQuizController controller,
    CourseAssignment assignment,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (sheetContext) {
        return Obx(() {
          final submissions = controller.submissionsFor(assignment.id);

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
                  Text(
                    assignment.title,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${submissions.length} student submissions',
                    style: const TextStyle(color: Color(0xFF667085)),
                  ),
                  const SizedBox(height: 14),
                  if (submissions.isEmpty)
                    const _EmptyPanel(message: 'No student has posted yet')
                  else
                    for (final submission in submissions) ...[
                      _SubmissionReviewTile(
                        submission: submission,
                        totalMarks: assignment.totalMarks,
                        onReview: () async {
                          await controller.reviewSubmission(submission);
                          Get.snackbar(
                            'Assignment & Quiz',
                            '${submission.studentName} marked reviewed',
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.all(14),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

class _TeacherAssignmentCard extends StatelessWidget {
  const _TeacherAssignmentCard({
    required this.assignment,
    required this.submissions,
    required this.onSubmissions,
  });

  final CourseAssignment assignment;
  final List<AssignmentSubmission> submissions;
  final VoidCallback onSubmissions;

  @override
  Widget build(BuildContext context) {
    final subject = assignment.subject;
    final pending = submissions
        .where((submission) => submission.status.toLowerCase() == 'submitted')
        .length;

    return _WorkCard(
      subject: subject,
      title: assignment.title,
      description: assignment.instructions.isEmpty
          ? 'No additional instructions provided.'
          : assignment.instructions,
      badges: [
        _StatusBadge(label: subject.code, color: subject.color),
        _StatusBadge(label: assignment.status, color: AppColors.primary),
      ],
      chips: [
        _InfoChip(
          icon: Icons.event_outlined,
          label: _formatDateTime(assignment.dueAt),
        ),
        _InfoChip(
          icon: Icons.grade_outlined,
          label: '${assignment.totalMarks} marks',
        ),
        _InfoChip(
          icon: Icons.group_outlined,
          label: '${submissions.length} submitted',
        ),
        _InfoChip(icon: Icons.rate_review_outlined, label: '$pending pending'),
      ],
      action: FilledButton.icon(
        onPressed: onSubmissions,
        icon: const Icon(Icons.fact_check_outlined),
        label: const Text('View submissions'),
      ),
    );
  }
}

class _TeacherQuizList extends StatelessWidget {
  const _TeacherQuizList({required this.controller});

  final AssignmentAndQuizController controller;

  @override
  Widget build(BuildContext context) {
    final quizzes = controller.filteredQuizzes;
    if (quizzes.isEmpty) {
      return const _EmptyPanel(message: 'No quiz found');
    }

    return Column(
      children: [
        for (final quiz in quizzes) ...[
          _TeacherQuizCard(
            quiz: quiz,
            attempts: controller.attemptsFor(quiz.id),
            onAttempts: () => _showAttemptsSheet(context, controller, quiz),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  void _showAttemptsSheet(
    BuildContext context,
    AssignmentAndQuizController controller,
    CourseQuiz quiz,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (sheetContext) {
        final attempts = controller.attemptsFor(quiz.id);

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
                Text(
                  quiz.title,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${attempts.length} quiz attempts',
                  style: const TextStyle(color: Color(0xFF667085)),
                ),
                const SizedBox(height: 14),
                if (attempts.isEmpty)
                  const _EmptyPanel(message: 'No student attempt yet')
                else
                  for (final attempt in attempts) ...[
                    _AttemptTile(attempt: attempt, totalMarks: quiz.totalMarks),
                    const SizedBox(height: 10),
                  ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TeacherQuizCard extends StatelessWidget {
  const _TeacherQuizCard({
    required this.quiz,
    required this.attempts,
    required this.onAttempts,
  });

  final CourseQuiz quiz;
  final List<QuizAttempt> attempts;
  final VoidCallback onAttempts;

  @override
  Widget build(BuildContext context) {
    final subject = quiz.subject;
    final statusColor = quiz.status.toLowerCase() == 'published'
        ? AppColors.secondary
        : quiz.status.toLowerCase() == 'draft'
        ? const Color(0xFF667085)
        : const Color(0xFFB54708);

    return _WorkCard(
      subject: subject,
      title: quiz.title,
      description: quiz.instructions.isEmpty
          ? 'No additional quiz instructions provided.'
          : quiz.instructions,
      badges: [
        _StatusBadge(label: subject.code, color: subject.color),
        _StatusBadge(label: quiz.status, color: statusColor),
      ],
      chips: [
        _InfoChip(
          icon: Icons.event_outlined,
          label: _formatDateTime(quiz.opensAt),
        ),
        _InfoChip(
          icon: Icons.timer_outlined,
          label: '${quiz.durationMinutes} min',
        ),
        _InfoChip(
          icon: Icons.help_outline,
          label: '${quiz.questions.length} Qs',
        ),
        _InfoChip(
          icon: Icons.group_outlined,
          label: '${attempts.length} attempts',
        ),
      ],
      action: FilledButton.icon(
        onPressed: onAttempts,
        icon: const Icon(Icons.analytics_outlined),
        label: const Text('View attempts'),
      ),
    );
  }
}

class _WorkCard extends StatelessWidget {
  const _WorkCard({
    required this.subject,
    required this.title,
    required this.description,
    required this.badges,
    required this.chips,
    required this.action,
  });

  final CourseSubject subject;
  final String title;
  final String description;
  final List<Widget> badges;
  final List<Widget> chips;
  final Widget action;

  @override
  Widget build(BuildContext context) {
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
                    Wrap(spacing: 8, runSpacing: 8, children: badges),
                    const SizedBox(height: 8),
                    Text(
                      title,
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
            description,
            style: const TextStyle(color: Color(0xFF475467), height: 1.45),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: chips),
          const SizedBox(height: 14),
          Align(alignment: Alignment.centerRight, child: action),
        ],
      ),
    );
  }
}

class _SubmissionReviewTile extends StatelessWidget {
  const _SubmissionReviewTile({
    required this.submission,
    required this.totalMarks,
    required this.onReview,
  });

  final AssignmentSubmission submission;
  final num totalMarks;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    final reviewed = submission.status.toLowerCase() == 'graded';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      submission.studentName,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    Text(
                      submission.studentId,
                      style: const TextStyle(
                        color: Color(0xFF667085),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(
                label: submission.status,
                color: reviewed ? AppColors.secondary : const Color(0xFFB54708),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            submission.submittedAt == null
                ? 'No submitted timestamp'
                : 'Submitted ${_formatDateTime(submission.submittedAt!)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF475467)),
          ),
          const SizedBox(height: 4),
          Text(
            submission.note,
            style: const TextStyle(color: Color(0xFF475467), height: 1.35),
          ),
          if (reviewed) ...[
            const SizedBox(height: 8),
            Text(
              'Marks ${submission.marks ?? 0}/$totalMarks',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            if (submission.feedback != null)
              Text(
                submission.feedback!,
                style: const TextStyle(color: Color(0xFF475467), height: 1.35),
              ),
          ],
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: reviewed ? null : onReview,
              icon: const Icon(Icons.rate_review_outlined),
              label: Text(reviewed ? 'Reviewed' : 'Mark reviewed'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttemptTile extends StatelessWidget {
  const _AttemptTile({required this.attempt, required this.totalMarks});

  final QuizAttempt attempt;
  final num totalMarks;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.task_alt_outlined, color: AppColors.secondary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attempt.studentName,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  '${attempt.studentId}${attempt.submittedAt == null ? '' : ' | ${_formatDateTime(attempt.submittedAt!)}'}',
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _StatusBadge(
            label: '${attempt.score}/$totalMarks',
            color: AppColors.secondary,
          ),
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

String _formatDateTime(DateTime value) {
  return DateFormat('MMM d, yyyy h:mm a').format(value);
}
