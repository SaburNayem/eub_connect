import 'package:eub_connect/core/constant/app_color/app_colors.dart';
import 'package:eub_connect/feature/common/assignment_quiz/model/assignment_quiz_data.dart';
import 'package:eub_connect/feature/student/quiz_practice/controller/quiz_practice_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizPracticeScreen extends StatelessWidget {
  const QuizPracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<QuizPracticeController>()
        ? Get.find<QuizPracticeController>()
        : Get.put(QuizPracticeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        surfaceTintColor: AppColors.white,
        title: const Text(
          'Quiz Practice',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final quizzes = controller.quizzes;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _QuizHeader(controller: controller),
                    const SizedBox(height: 16),
                    _SubjectFilter(
                      selectedCode: controller.selectedSubjectCode.value,
                      subjects: controller.subjects,
                      onSelected: controller.selectSubject,
                    ),
                    const SizedBox(height: 16),
                    if (quizzes.isEmpty)
                      const _EmptyPanel(message: 'No quiz found')
                    else
                      for (final quiz in quizzes) ...[
                        _QuizCard(
                          quiz: quiz,
                          attempt: controller.attemptFor(quiz.id),
                          onStart: () =>
                              _showQuizSheet(context, controller, quiz),
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

  Future<void> _showQuizSheet(
    BuildContext context,
    QuizPracticeController controller,
    CourseQuiz quiz,
  ) {
    final subject = subjectForCode(quiz.subjectCode);
    final attempt = controller.attemptFor(quiz.id);
    final canSubmit = quiz.status.toLowerCase() == 'open';

    return showModalBottomSheet<void>(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SubjectAvatar(subject: subject),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.title,
                            style: const TextStyle(
                              color: AppColors.textDark,
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${subject.code} | ${quiz.duration} | ${quiz.totalMarks} marks',
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
                const SizedBox(height: 16),
                Text(
                  quiz.description,
                  style: const TextStyle(color: Color(0xFF475467), height: 1.4),
                ),
                const SizedBox(height: 16),
                for (var index = 0; index < quiz.questions.length; index++) ...[
                  _QuestionPreview(
                    number: index + 1,
                    question: quiz.questions[index],
                  ),
                  const SizedBox(height: 10),
                ],
                if (attempt != null)
                  _AttemptPanel(attempt: attempt, totalMarks: quiz.totalMarks),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: canSubmit
                      ? () {
                          controller.submitQuiz(quiz);
                          Get.back<void>();
                          Get.snackbar(
                            'Quiz Practice',
                            '${quiz.title} submitted',
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.all(14),
                            backgroundColor: AppColors.primary,
                            colorText: AppColors.white,
                          );
                        }
                      : null,
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text(attempt == null ? 'Submit quiz' : 'Retake demo'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuizHeader extends StatelessWidget {
  const _QuizHeader({required this.controller});

  final QuizPracticeController controller;

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
            'Practice and submit quizzes',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Each subject has its own quiz schedule, question count, score, and status.',
            style: TextStyle(color: Color(0xFF667085), height: 1.4),
          ),
          const SizedBox(height: 16),
          _MetricGrid(
            metrics: [
              _MetricData(
                label: 'Open quizzes',
                value: '${controller.availableCount}',
                icon: Icons.quiz_outlined,
                color: AppColors.primary,
              ),
              _MetricData(
                label: 'Completed',
                value: '${controller.completedCount}',
                icon: Icons.task_alt_outlined,
                color: AppColors.secondary,
              ),
              _MetricData(
                label: 'Best score',
                value: '${controller.bestScore}',
                icon: Icons.workspace_premium_outlined,
                color: const Color(0xFFCA8A04),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  const _QuizCard({
    required this.quiz,
    required this.attempt,
    required this.onStart,
  });

  final CourseQuiz quiz;
  final QuizAttempt? attempt;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final subject = subjectForCode(quiz.subjectCode);
    final attempted = attempt != null;
    final statusColor = attempted
        ? AppColors.secondary
        : quiz.status.toLowerCase() == 'open'
        ? AppColors.primary
        : quiz.status.toLowerCase() == 'draft'
        ? const Color(0xFF667085)
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
                          label: attempted ? 'Completed' : quiz.status,
                          color: statusColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      quiz.title,
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
            quiz.description,
            style: const TextStyle(color: Color(0xFF475467), height: 1.45),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(icon: Icons.event_outlined, label: quiz.schedule),
              _InfoChip(icon: Icons.timer_outlined, label: quiz.duration),
              _InfoChip(
                icon: Icons.help_outline,
                label: '${quiz.questionCount} questions',
              ),
              _InfoChip(
                icon: Icons.grade_outlined,
                label: '${quiz.totalMarks} marks',
              ),
            ],
          ),
          if (attempt != null) ...[
            const SizedBox(height: 12),
            _AttemptPanel(attempt: attempt!, totalMarks: quiz.totalMarks),
          ],
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: onStart,
              icon: Icon(
                attempted ? Icons.visibility_outlined : Icons.play_arrow,
              ),
              label: Text(attempted ? 'Review result' : 'Open quiz'),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionPreview extends StatelessWidget {
  const _QuestionPreview({required this.number, required this.question});

  final int number;
  final QuizQuestion question;

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
          Text(
            '$number. ${question.question}',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: question.options
                .map((option) => _RequirementChip(label: option))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _AttemptPanel extends StatelessWidget {
  const _AttemptPanel({required this.attempt, required this.totalMarks});

  final QuizAttempt attempt;
  final int totalMarks;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          const Icon(Icons.task_alt_outlined, color: AppColors.secondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Score ${attempt.score}/$totalMarks | ${attempt.submittedAt}',
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w900,
              ),
            ),
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
            label: Text(subject.code),
            selected: selectedCode == subject.code,
            onSelected: (_) => onSelected(subject.code),
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

class _RequirementChip extends StatelessWidget {
  const _RequirementChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF475467),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
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
