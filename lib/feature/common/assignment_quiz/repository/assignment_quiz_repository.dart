import 'package:eub_connect/core/backend/app_failure.dart';
import 'package:eub_connect/core/demo/demo_store.dart';
import 'package:eub_connect/feature/common/assignment_quiz/model/assignment_quiz_models.dart';

class AssignmentQuizRepository {
  AssignmentQuizRepository({DemoStore? store})
    : _store = store ?? DemoStore.instance;

  final DemoStore _store;

  Future<AppResult<AssignmentQuizWorkspace>> loadWorkspace() async {
    try {
      return AppResult.success(_store.assignmentQuizWorkspace());
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.unknown,
          message: 'Unable to load local demo assignments and quizzes.',
          detail: error,
        ),
      );
    }
  }

  Future<AppResult<void>> submitAssignment({
    required String assignmentId,
    required String note,
  }) async {
    try {
      _store.submitAssignment(assignmentId: assignmentId, note: note);
      return const AppResult.success(null);
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.validation,
          message: error.toString().replaceFirst('Bad state: ', ''),
          detail: error,
        ),
      );
    }
  }

  Future<AppResult<void>> gradeSubmission({
    required String submissionId,
    required num marks,
    required String feedback,
  }) async {
    try {
      _store.gradeSubmission(
        submissionId: submissionId,
        marks: marks,
        feedback: feedback,
      );
      return const AppResult.success(null);
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.validation,
          message: 'Unable to grade the local demo submission.',
          detail: error,
        ),
      );
    }
  }

  Future<AppResult<void>> publishAssignment({
    required String sectionId,
    required String title,
    required String instructions,
    required num totalMarks,
    required DateTime dueAt,
  }) async {
    try {
      _store.publishAssignment(
        sectionId: sectionId,
        title: title,
        instructions: instructions,
        totalMarks: totalMarks,
        dueAt: dueAt,
      );
      return const AppResult.success(null);
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.validation,
          message: 'Unable to publish the local demo assignment.',
          detail: error,
        ),
      );
    }
  }

  Future<AppResult<void>> publishQuiz({
    required String sectionId,
    required String title,
    required String instructions,
    required num totalMarks,
    required int durationMinutes,
    required DateTime opensAt,
    required DateTime closesAt,
  }) async {
    try {
      _store.publishQuiz(
        sectionId: sectionId,
        title: title,
        instructions: instructions,
        totalMarks: totalMarks,
        durationMinutes: durationMinutes,
        opensAt: opensAt,
        closesAt: closesAt,
      );
      return const AppResult.success(null);
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.validation,
          message: 'Unable to publish the local demo quiz.',
          detail: error,
        ),
      );
    }
  }

  Future<AppResult<void>> submitQuizAttempt({required String quizId}) async {
    try {
      _store.submitQuizAttempt(quizId);
      return const AppResult.success(null);
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.validation,
          message: 'Unable to submit the local demo quiz attempt.',
          detail: error,
        ),
      );
    }
  }
}
