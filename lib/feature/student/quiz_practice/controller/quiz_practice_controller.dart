import 'package:eub_connect/core/data/async_value.dart';
import 'package:eub_connect/feature/common/assignment_quiz/model/assignment_quiz_models.dart';
import 'package:eub_connect/feature/common/assignment_quiz/repository/assignment_quiz_repository.dart';
import 'package:eub_connect/feature/student/quiz_practice/model/quiz_practice_model.dart';
import 'package:get/get.dart';

class QuizPracticeController extends GetxController {
  QuizPracticeController({AssignmentQuizRepository? repository})
    : _repository = repository ?? AssignmentQuizRepository();

  final AssignmentQuizRepository _repository;
  final moduleStatus = 'Ready'.obs;
  final model = const QuizPracticeModel().obs;
  final selectedSubjectCode = 'all'.obs;
  final workspace = const AsyncValue<AssignmentQuizWorkspace>.loading().obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  List<CourseSubject> get subjects => workspace.value.data?.subjects ?? [];

  List<QuizAttempt> get attempts => workspace.value.data?.attempts ?? [];

  List<CourseQuiz> get quizzes {
    final selectedCode = selectedSubjectCode.value;
    final allQuizzes = workspace.value.data?.quizzes ?? [];
    final filtered = selectedCode == 'all'
        ? allQuizzes
        : allQuizzes.where((quiz) => quiz.subject.sectionId == selectedCode);
    return filtered.toList();
  }

  int get availableCount {
    final allQuizzes = workspace.value.data?.quizzes ?? [];
    return allQuizzes
        .where((quiz) => quiz.status.toLowerCase() == 'published')
        .length;
  }

  int get completedCount => attempts.length;

  int get bestScore {
    if (attempts.isEmpty) {
      return 0;
    }
    return attempts
        .map((attempt) => attempt.score?.toInt() ?? 0)
        .reduce((value, item) => value > item ? value : item);
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
      result.failure?.message ?? 'Unable to load quizzes.',
    );
  }

  QuizAttempt? attemptFor(String quizId) {
    for (final attempt in attempts) {
      if (attempt.quizId == quizId) {
        return attempt;
      }
    }
    return null;
  }

  Future<void> submitQuiz(CourseQuiz quiz) async {
    final result = await _repository.submitQuizAttempt(quizId: quiz.id);
    if (result.isSuccess) {
      moduleStatus.value = 'Quiz submitted';
      await load();
      return;
    }
    moduleStatus.value = result.failure?.message ?? 'Quiz submission failed';
  }
}
