import 'package:eub_connect/core/data/async_value.dart';
import 'package:eub_connect/core/demo/demo_store.dart';
import 'package:eub_connect/feature/common/assignment_quiz/model/assignment_quiz_models.dart';
import 'package:eub_connect/feature/common/assignment_quiz/repository/assignment_quiz_repository.dart';
import 'package:eub_connect/feature/facalty/teacher/manage_course/assignment_and_quiz/model/assignment_and_quiz_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum TeacherWorkMode { assignments, quizzes }

class AssignmentAndQuizController extends GetxController {
  AssignmentAndQuizController({AssignmentQuizRepository? repository})
    : _repository = repository ?? AssignmentQuizRepository();

  final AssignmentQuizRepository _repository;
  final moduleStatus = 'Ready'.obs;
  final model = const AssignmentAndQuizModel().obs;
  final selectedMode = TeacherWorkMode.assignments.obs;
  final selectedSubjectCode = 'all'.obs;
  final workspace = const AsyncValue<AssignmentQuizWorkspace>.loading().obs;
  Worker? _demoRevisionWorker;

  @override
  void onInit() {
    super.onInit();
    _demoRevisionWorker = ever(DemoStore.instance.revision, (_) => load());
    load();
  }

  List<CourseSubject> get subjects => workspace.value.data?.subjects ?? [];

  List<CourseAssignment> get assignments {
    return workspace.value.data?.assignments ?? [];
  }

  List<AssignmentSubmission> get submissions {
    return workspace.value.data?.submissions ?? [];
  }

  List<CourseQuiz> get quizzes => workspace.value.data?.quizzes ?? [];

  List<QuizAttempt> get quizAttempts => workspace.value.data?.attempts ?? [];

  List<CourseAssignment> get filteredAssignments {
    final selectedCode = selectedSubjectCode.value;
    final filtered = selectedCode == 'all'
        ? assignments
        : assignments.where(
            (assignment) => assignment.subject.sectionId == selectedCode,
          );
    return filtered.toList();
  }

  List<CourseQuiz> get filteredQuizzes {
    final selectedCode = selectedSubjectCode.value;
    final filtered = selectedCode == 'all'
        ? quizzes
        : quizzes.where((quiz) => quiz.subject.sectionId == selectedCode);
    return filtered.toList();
  }

  int get pendingSubmissionCount {
    return submissions
        .where((submission) => submission.status.toLowerCase() == 'submitted')
        .length;
  }

  int get reviewedSubmissionCount {
    return submissions
        .where((submission) => submission.status.toLowerCase() == 'graded')
        .length;
  }

  int get openQuizCount {
    return quizzes
        .where((quiz) => quiz.status.toLowerCase() == 'published')
        .length;
  }

  void selectMode(TeacherWorkMode mode) {
    selectedMode.value = mode;
  }

  void selectSubject(String code) {
    selectedSubjectCode.value = code;
  }

  Future<void> load() async {
    workspace.value = const AsyncValue.loading();
    final result = await _repository.loadWorkspace();
    if (result.isSuccess) {
      workspace.value = AsyncValue.data(result.requireData);
      return;
    }
    workspace.value = AsyncValue.error(
      result.failure?.message ?? 'Unable to load class work.',
    );
  }

  List<AssignmentSubmission> submissionsFor(String assignmentId) {
    return submissions
        .where((submission) => submission.assignmentId == assignmentId)
        .toList();
  }

  List<QuizAttempt> attemptsFor(String quizId) {
    return quizAttempts.where((attempt) => attempt.quizId == quizId).toList();
  }

  Future<void> reviewSubmission(AssignmentSubmission submission) async {
    final assignment = assignmentFor(submission.assignmentId);
    final marks = assignment == null
        ? 0
        : (assignment.totalMarks * 0.9).round();
    final result = await _repository.gradeSubmission(
      submissionId: submission.id,
      marks: marks,
      feedback: 'Reviewed and graded.',
    );
    if (result.isSuccess) {
      moduleStatus.value = 'Submission reviewed';
      await load();
      return;
    }
    moduleStatus.value = result.failure?.message ?? 'Review failed';
  }

  Future<void> publishAssignment({
    required String subjectCode,
    required String title,
    required String dueDate,
    required int marks,
    required String description,
  }) async {
    final sectionId = subjectCode;
    final result = await _repository.publishAssignment(
      sectionId: sectionId,
      title: title.trim().isEmpty ? 'New Assignment' : title.trim(),
      instructions: description.trim().isEmpty
          ? 'Complete the assignment and submit before the deadline.'
          : description.trim(),
      totalMarks: marks,
      dueAt: _parseDate(dueDate) ?? DateTime.now().add(const Duration(days: 7)),
    );
    if (result.isSuccess) {
      selectedMode.value = TeacherWorkMode.assignments;
      selectedSubjectCode.value = sectionId;
      moduleStatus.value = 'Assignment published';
      await load();
      return;
    }
    moduleStatus.value = result.failure?.message ?? 'Publish failed';
  }

  Future<void> publishQuiz({
    required String subjectCode,
    required String title,
    required String schedule,
    required int marks,
    required List<QuizDraftQuestion> questions,
  }) async {
    final sectionId = subjectCode;
    final opensAt =
        _parseDate(schedule) ?? DateTime.now().add(const Duration(days: 1));
    final result = await _repository.publishQuiz(
      sectionId: sectionId,
      title: title.trim().isEmpty ? 'New Quiz' : title.trim(),
      instructions: 'Answer all questions before the timer ends.',
      totalMarks: marks,
      durationMinutes: 15,
      opensAt: opensAt,
      closesAt: opensAt.add(const Duration(hours: 2)),
      questions: questions,
    );
    if (result.isSuccess) {
      selectedMode.value = TeacherWorkMode.quizzes;
      selectedSubjectCode.value = sectionId;
      moduleStatus.value = 'Quiz published';
      await load();
      return;
    }
    moduleStatus.value = result.failure?.message ?? 'Quiz publish failed';
  }

  CourseAssignment? assignmentFor(String assignmentId) {
    for (final assignment in assignments) {
      if (assignment.id == assignmentId) {
        return assignment;
      }
    }
    return null;
  }

  DateTime? _parseDate(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return DateTime.tryParse(trimmed) ??
        _tryFormat(trimmed, 'MMM d, yyyy h a') ??
        _tryFormat(trimmed, 'MMM d, yyyy') ??
        _tryFormat(trimmed, 'yyyy-MM-dd HH:mm') ??
        _tryFormat(trimmed, 'yyyy-MM-dd');
  }

  DateTime? _tryFormat(String value, String pattern) {
    try {
      return DateFormat(pattern).parseStrict(value);
    } catch (_) {
      return null;
    }
  }

  @override
  void onClose() {
    _demoRevisionWorker?.dispose();
    super.onClose();
  }
}
