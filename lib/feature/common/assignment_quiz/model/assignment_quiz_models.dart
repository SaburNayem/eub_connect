import 'package:flutter/material.dart';

class CourseSubject {
  const CourseSubject({
    required this.sectionId,
    required this.code,
    required this.name,
    required this.teacher,
    required this.section,
  });

  final String sectionId;
  final String code;
  final String name;
  final String teacher;
  final String section;

  Color get color {
    final palette = [
      const Color(0xFF2A2D7E),
      const Color(0xFF007F3D),
      const Color(0xFFCA8A04),
      const Color(0xFF0D9488),
      const Color(0xFFB42318),
    ];
    final index = code.hashCode.abs() % palette.length;
    return palette[index];
  }
}

class CourseAssignment {
  const CourseAssignment({
    required this.id,
    required this.sectionId,
    required this.subject,
    required this.title,
    required this.instructions,
    required this.dueAt,
    required this.totalMarks,
    required this.status,
    required this.allowResubmission,
  });

  final String id;
  final String sectionId;
  final CourseSubject subject;
  final String title;
  final String instructions;
  final DateTime dueAt;
  final num totalMarks;
  final String status;
  final bool allowResubmission;
}

class AssignmentSubmission {
  const AssignmentSubmission({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.studentName,
    required this.note,
    required this.status,
    this.submittedAt,
    this.marks,
    this.feedback,
  });

  final String id;
  final String assignmentId;
  final String studentId;
  final String studentName;
  final String note;
  final String status;
  final DateTime? submittedAt;
  final num? marks;
  final String? feedback;
}

class CourseQuiz {
  const CourseQuiz({
    required this.id,
    required this.sectionId,
    required this.subject,
    required this.title,
    required this.instructions,
    required this.opensAt,
    required this.closesAt,
    required this.durationMinutes,
    required this.totalMarks,
    required this.attemptLimit,
    required this.showResultImmediately,
    required this.status,
    required this.questions,
  });

  final String id;
  final String sectionId;
  final CourseSubject subject;
  final String title;
  final String instructions;
  final DateTime opensAt;
  final DateTime closesAt;
  final int durationMinutes;
  final num totalMarks;
  final int attemptLimit;
  final bool showResultImmediately;
  final String status;
  final List<QuizQuestion> questions;
}

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.marks,
  });

  final String id;
  final String question;
  final List<QuizOption> options;
  final num marks;
}

class QuizOption {
  const QuizOption({required this.id, required this.text});

  final String id;
  final String text;
}

class QuizAttempt {
  const QuizAttempt({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.studentName,
    required this.status,
    this.submittedAt,
    this.score,
  });

  final String id;
  final String quizId;
  final String studentId;
  final String studentName;
  final String status;
  final DateTime? submittedAt;
  final num? score;
}

class AssignmentQuizWorkspace {
  const AssignmentQuizWorkspace({
    required this.subjects,
    required this.assignments,
    required this.submissions,
    required this.quizzes,
    required this.attempts,
  });

  final List<CourseSubject> subjects;
  final List<CourseAssignment> assignments;
  final List<AssignmentSubmission> submissions;
  final List<CourseQuiz> quizzes;
  final List<QuizAttempt> attempts;
}
