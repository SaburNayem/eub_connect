import 'package:eub_connect/feature/common/assignment_quiz/model/assignment_quiz_data.dart';
import 'package:eub_connect/feature/student/assingment/model/assingment_model.dart';
import 'package:get/get.dart';

class AssingmentController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const AssingmentModel().obs;
  final selectedSubjectCode = 'all'.obs;
  final submissions = demoAssignmentSubmissions
      .where((submission) => submission.studentId == currentStudentId)
      .toList()
      .obs;

  List<CourseSubject> get subjects => demoSubjects;

  List<CourseAssignment> get assignments {
    final selectedCode = selectedSubjectCode.value;
    final filtered = selectedCode == 'all'
        ? demoAssignments
        : demoAssignments.where(
            (assignment) => assignment.subjectCode == selectedCode,
          );
    return filtered.toList();
  }

  int get openCount {
    return demoAssignments.where((assignment) {
      return assignment.status.toLowerCase() == 'open' &&
          submissionFor(assignment.id) == null;
    }).length;
  }

  int get submittedCount => submissions.length;

  int get reviewedCount {
    return submissions
        .where((submission) => submission.status.toLowerCase() == 'reviewed')
        .length;
  }

  void selectSubject(String code) {
    selectedSubjectCode.value = code;
  }

  AssignmentSubmission? submissionFor(String assignmentId) {
    for (final submission in submissions) {
      if (submission.assignmentId == assignmentId) {
        return submission;
      }
    }
    return null;
  }

  void submitAssignment({
    required CourseAssignment assignment,
    required String fileName,
    required String note,
  }) {
    final cleanFileName = fileName.trim().isEmpty
        ? '${assignment.subjectCode.replaceAll(' ', '_').toLowerCase()}_${assignment.id}.pdf'
        : fileName.trim();
    final cleanNote = note.trim().isEmpty
        ? 'Submitted from EUB Connect student portal.'
        : note.trim();
    final submission = AssignmentSubmission(
      assignmentId: assignment.id,
      studentId: currentStudentId,
      studentName: currentStudentName,
      section: subjectForCode(assignment.subjectCode).section,
      fileName: cleanFileName,
      note: cleanNote,
      submittedAt: 'Just now',
      status: 'Submitted',
      isLate: assignment.status.toLowerCase() == 'closed',
    );

    final existingIndex = submissions.indexWhere(
      (item) => item.assignmentId == assignment.id,
    );
    if (existingIndex == -1) {
      submissions.add(submission);
    } else {
      submissions[existingIndex] = submission;
    }

    moduleStatus.value = 'Submitted';
  }
}
