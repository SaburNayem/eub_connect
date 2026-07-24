import 'package:eub_connect/feature/common/assignment_quiz/model/assignment_quiz_data.dart';
import 'package:eub_connect/feature/facalty/teacher/manage_course/assignment_and_quiz/model/assignment_and_quiz_model.dart';
import 'package:get/get.dart';

enum TeacherWorkMode { assignments, quizzes }

class AssignmentAndQuizController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const AssignmentAndQuizModel().obs;
  final selectedMode = TeacherWorkMode.assignments.obs;
  final selectedSubjectCode = 'all'.obs;
  final assignments = demoAssignments.toList().obs;
  final submissions = demoAssignmentSubmissions.toList().obs;
  final quizzes = demoQuizzes.toList().obs;
  final quizAttempts = demoQuizAttempts.toList().obs;

  List<CourseSubject> get subjects => demoSubjects;

  List<CourseAssignment> get filteredAssignments {
    final selectedCode = selectedSubjectCode.value;
    final filtered = selectedCode == 'all'
        ? assignments
        : assignments.where(
            (assignment) => assignment.subjectCode == selectedCode,
          );
    return filtered.toList();
  }

  List<CourseQuiz> get filteredQuizzes {
    final selectedCode = selectedSubjectCode.value;
    final filtered = selectedCode == 'all'
        ? quizzes
        : quizzes.where((quiz) => quiz.subjectCode == selectedCode);
    return filtered.toList();
  }

  int get pendingSubmissionCount {
    return submissions
        .where((submission) => submission.status.toLowerCase() == 'submitted')
        .length;
  }

  int get reviewedSubmissionCount {
    return submissions
        .where((submission) => submission.status.toLowerCase() == 'reviewed')
        .length;
  }

  int get openQuizCount {
    return quizzes.where((quiz) => quiz.status.toLowerCase() == 'open').length;
  }

  void selectMode(TeacherWorkMode mode) {
    selectedMode.value = mode;
  }

  void selectSubject(String code) {
    selectedSubjectCode.value = code;
  }

  List<AssignmentSubmission> submissionsFor(String assignmentId) {
    return submissions
        .where((submission) => submission.assignmentId == assignmentId)
        .toList();
  }

  List<QuizAttempt> attemptsFor(String quizId) {
    return quizAttempts.where((attempt) => attempt.quizId == quizId).toList();
  }

  void reviewSubmission(AssignmentSubmission submission) {
    final assignment = assignmentFor(submission.assignmentId);
    final marks = assignment == null
        ? 10
        : (assignment.totalMarks * 0.9).round();
    final index = submissions.indexWhere((item) {
      return item.assignmentId == submission.assignmentId &&
          item.studentId == submission.studentId;
    });
    if (index == -1) {
      return;
    }

    submissions[index] = submission.copyWith(
      status: 'Reviewed',
      marks: marks,
      feedback: 'Reviewed from teacher panel. Improve examples if resubmitted.',
    );
    moduleStatus.value = 'Submission reviewed';
  }

  void publishAssignment({
    required String subjectCode,
    required String title,
    required String dueDate,
    required int marks,
    required String description,
  }) {
    final id = 'as-new-${assignments.length + 1}';
    assignments.insert(
      0,
      CourseAssignment(
        id: id,
        subjectCode: subjectCode,
        title: title.trim().isEmpty ? 'New Assignment' : title.trim(),
        description: description.trim().isEmpty
            ? 'Complete the attached task and upload the answer file.'
            : description.trim(),
        dueDate: dueDate.trim().isEmpty ? 'Next class' : dueDate.trim(),
        publishDate: 'Today',
        totalMarks: marks,
        status: 'Open',
        requirements: const [
          'Answer file',
          'Short explanation',
          'Student ID on cover page',
        ],
        resourceLabel: 'Teacher attachment.pdf',
      ),
    );
    selectedMode.value = TeacherWorkMode.assignments;
    selectedSubjectCode.value = subjectCode;
    moduleStatus.value = 'Assignment published';
  }

  void publishQuiz({
    required String subjectCode,
    required String title,
    required String schedule,
    required int marks,
  }) {
    final id = 'q-new-${quizzes.length + 1}';
    quizzes.insert(
      0,
      CourseQuiz(
        id: id,
        subjectCode: subjectCode,
        title: title.trim().isEmpty ? 'New Quiz' : title.trim(),
        description: 'Teacher-created quiz with static demo questions.',
        schedule: schedule.trim().isEmpty ? 'Next class' : schedule.trim(),
        duration: '15 min',
        totalMarks: marks,
        questionCount: 5,
        status: 'Open',
        questions: const [
          QuizQuestion(
            question: 'Sample teacher question?',
            options: ['Option A', 'Option B', 'Option C', 'Option D'],
            answer: 'Option A',
          ),
        ],
      ),
    );
    selectedMode.value = TeacherWorkMode.quizzes;
    selectedSubjectCode.value = subjectCode;
    moduleStatus.value = 'Quiz published';
  }

  CourseAssignment? assignmentFor(String assignmentId) {
    for (final assignment in assignments) {
      if (assignment.id == assignmentId) {
        return assignment;
      }
    }
    return null;
  }
}
