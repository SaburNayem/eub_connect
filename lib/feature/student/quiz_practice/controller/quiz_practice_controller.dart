import 'package:eub_connect/feature/common/assignment_quiz/model/assignment_quiz_data.dart';
import 'package:eub_connect/feature/student/quiz_practice/model/quiz_practice_model.dart';
import 'package:get/get.dart';

class QuizPracticeController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const QuizPracticeModel().obs;
  final selectedSubjectCode = 'all'.obs;
  final attempts = demoQuizAttempts
      .where((attempt) => attempt.studentId == currentStudentId)
      .toList()
      .obs;

  List<CourseSubject> get subjects => demoSubjects;

  List<CourseQuiz> get quizzes {
    final selectedCode = selectedSubjectCode.value;
    final filtered = selectedCode == 'all'
        ? demoQuizzes
        : demoQuizzes.where((quiz) => quiz.subjectCode == selectedCode);
    return filtered.toList();
  }

  int get availableCount {
    return demoQuizzes
        .where((quiz) => quiz.status.toLowerCase() == 'open')
        .length;
  }

  int get completedCount => attempts.length;

  int get bestScore {
    if (attempts.isEmpty) {
      return 0;
    }
    return attempts
        .map((attempt) => attempt.score)
        .reduce((value, item) => value > item ? value : item);
  }

  void selectSubject(String code) {
    selectedSubjectCode.value = code;
  }

  QuizAttempt? attemptFor(String quizId) {
    for (final attempt in attempts) {
      if (attempt.quizId == quizId) {
        return attempt;
      }
    }
    return null;
  }

  void submitQuiz(CourseQuiz quiz) {
    final score = quiz.totalMarks > 18
        ? quiz.totalMarks - 3
        : quiz.totalMarks - 1;
    final attempt = QuizAttempt(
      quizId: quiz.id,
      studentId: currentStudentId,
      studentName: currentStudentName,
      submittedAt: 'Just now',
      score: score,
      status: 'Submitted',
    );
    final existingIndex = attempts.indexWhere((item) => item.quizId == quiz.id);
    if (existingIndex == -1) {
      attempts.add(attempt);
    } else {
      attempts[existingIndex] = attempt;
    }
    moduleStatus.value = 'Quiz submitted';
  }
}
