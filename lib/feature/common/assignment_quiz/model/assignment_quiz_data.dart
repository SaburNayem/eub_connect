import 'package:flutter/material.dart';

class CourseSubject {
  const CourseSubject({
    required this.code,
    required this.name,
    required this.teacher,
    required this.section,
    required this.color,
  });

  final String code;
  final String name;
  final String teacher;
  final String section;
  final Color color;
}

class CourseAssignment {
  const CourseAssignment({
    required this.id,
    required this.subjectCode,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.publishDate,
    required this.totalMarks,
    required this.status,
    required this.requirements,
    required this.resourceLabel,
  });

  final String id;
  final String subjectCode;
  final String title;
  final String description;
  final String dueDate;
  final String publishDate;
  final int totalMarks;
  final String status;
  final List<String> requirements;
  final String resourceLabel;
}

class AssignmentSubmission {
  const AssignmentSubmission({
    required this.assignmentId,
    required this.studentId,
    required this.studentName,
    required this.section,
    required this.fileName,
    required this.note,
    required this.submittedAt,
    required this.status,
    this.marks,
    this.feedback,
    this.isLate = false,
  });

  final String assignmentId;
  final String studentId;
  final String studentName;
  final String section;
  final String fileName;
  final String note;
  final String submittedAt;
  final String status;
  final int? marks;
  final String? feedback;
  final bool isLate;

  AssignmentSubmission copyWith({
    String? assignmentId,
    String? studentId,
    String? studentName,
    String? section,
    String? fileName,
    String? note,
    String? submittedAt,
    String? status,
    int? marks,
    String? feedback,
    bool? isLate,
  }) {
    return AssignmentSubmission(
      assignmentId: assignmentId ?? this.assignmentId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      section: section ?? this.section,
      fileName: fileName ?? this.fileName,
      note: note ?? this.note,
      submittedAt: submittedAt ?? this.submittedAt,
      status: status ?? this.status,
      marks: marks ?? this.marks,
      feedback: feedback ?? this.feedback,
      isLate: isLate ?? this.isLate,
    );
  }
}

class CourseQuiz {
  const CourseQuiz({
    required this.id,
    required this.subjectCode,
    required this.title,
    required this.description,
    required this.schedule,
    required this.duration,
    required this.totalMarks,
    required this.questionCount,
    required this.status,
    required this.questions,
  });

  final String id;
  final String subjectCode;
  final String title;
  final String description;
  final String schedule;
  final String duration;
  final int totalMarks;
  final int questionCount;
  final String status;
  final List<QuizQuestion> questions;
}

class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.answer,
  });

  final String question;
  final List<String> options;
  final String answer;
}

class QuizAttempt {
  const QuizAttempt({
    required this.quizId,
    required this.studentId,
    required this.studentName,
    required this.submittedAt,
    required this.score,
    required this.status,
  });

  final String quizId;
  final String studentId;
  final String studentName;
  final String submittedAt;
  final int score;
  final String status;
}

const currentStudentId = 'CSE-2026-014';
const currentStudentName = 'Sabik Ahmed';

const demoSubjects = [
  CourseSubject(
    code: 'CSE 410',
    name: 'Artificial Intelligence',
    teacher: 'Dr. Karim Rahman',
    section: 'Section A',
    color: Color(0xFF2A2D7E),
  ),
  CourseSubject(
    code: 'CSE 420',
    name: 'Software Engineering',
    teacher: 'Nusrat Jahan',
    section: 'Section A',
    color: Color(0xFF007F3D),
  ),
  CourseSubject(
    code: 'MAT 301',
    name: 'Numerical Methods',
    teacher: 'Dr. Alam Hossain',
    section: 'Section B',
    color: Color(0xFFCA8A04),
  ),
  CourseSubject(
    code: 'EEE 210',
    name: 'Digital Logic Design',
    teacher: 'Farhana Islam',
    section: 'Section C',
    color: Color(0xFF0D9488),
  ),
];

const demoAssignments = [
  CourseAssignment(
    id: 'as-ai-search',
    subjectCode: 'CSE 410',
    title: 'Search Algorithms Lab Report',
    description:
        'Compare BFS, DFS, UCS, and A* using one campus navigation problem.',
    dueDate: 'Jul 28, 2026',
    publishDate: 'Jul 18, 2026',
    totalMarks: 20,
    status: 'Open',
    requirements: ['PDF report', 'Source code zip', 'Runtime screenshot'],
    resourceLabel: 'AI lab brief.pdf',
  ),
  CourseAssignment(
    id: 'as-se-srs',
    subjectCode: 'CSE 420',
    title: 'SRS for University Connect App',
    description:
        'Prepare a requirement specification with actors, use cases, and risks.',
    dueDate: 'Jul 30, 2026',
    publishDate: 'Jul 20, 2026',
    totalMarks: 25,
    status: 'Open',
    requirements: [
      'SRS document',
      'Use case diagram',
      'Requirement traceability table',
    ],
    resourceLabel: 'SRS template.docx',
  ),
  CourseAssignment(
    id: 'as-mat-newton',
    subjectCode: 'MAT 301',
    title: 'Newton Raphson Problem Set',
    description:
        'Solve five nonlinear equations and show all iteration tables.',
    dueDate: 'Aug 2, 2026',
    publishDate: 'Jul 22, 2026',
    totalMarks: 15,
    status: 'Open',
    requirements: [
      'Handwritten solution scan',
      'Calculator output',
      'Final error analysis',
    ],
    resourceLabel: 'Problem set 3.pdf',
  ),
  CourseAssignment(
    id: 'as-dld-kmap',
    subjectCode: 'EEE 210',
    title: 'K-map Simplification Sheet',
    description:
        'Simplify eight Boolean expressions and draw the final circuit.',
    dueDate: 'Aug 4, 2026',
    publishDate: 'Jul 23, 2026',
    totalMarks: 15,
    status: 'Open',
    requirements: ['Truth table', 'K-map grouping', 'Logic circuit diagram'],
    resourceLabel: 'K-map practice.pdf',
  ),
  CourseAssignment(
    id: 'as-ai-ethics',
    subjectCode: 'CSE 410',
    title: 'AI Ethics Reflection',
    description:
        'Write a short reflection on bias, privacy, and accountability in AI.',
    dueDate: 'Jul 18, 2026',
    publishDate: 'Jul 10, 2026',
    totalMarks: 10,
    status: 'Closed',
    requirements: ['800 words', 'Two references', 'Personal recommendation'],
    resourceLabel: 'Ethics prompt.pdf',
  ),
];

const demoAssignmentSubmissions = [
  AssignmentSubmission(
    assignmentId: 'as-ai-search',
    studentId: currentStudentId,
    studentName: currentStudentName,
    section: 'CSE Section A',
    fileName: 'ai_search_lab_sabik.zip',
    note: 'Report and source code attached with the test screenshots.',
    submittedAt: 'Jul 24, 2026 09:20 AM',
    status: 'Submitted',
  ),
  AssignmentSubmission(
    assignmentId: 'as-ai-search',
    studentId: 'CSE-2026-017',
    studentName: 'Maliha Rahman',
    section: 'CSE Section A',
    fileName: 'search_algorithms_maliha.pdf',
    note: 'The source code is included in the appendix.',
    submittedAt: 'Jul 23, 2026 04:15 PM',
    status: 'Reviewed',
    marks: 18,
    feedback: 'Good comparison table. Add stronger complexity notes next time.',
  ),
  AssignmentSubmission(
    assignmentId: 'as-se-srs',
    studentId: 'CSE-2026-021',
    studentName: 'Rafi Hasan',
    section: 'CSE Section A',
    fileName: 'eub_connect_srs_rafi.docx',
    note: 'Added diagrams and assumptions.',
    submittedAt: 'Jul 24, 2026 11:05 AM',
    status: 'Submitted',
  ),
  AssignmentSubmission(
    assignmentId: 'as-mat-newton',
    studentId: currentStudentId,
    studentName: currentStudentName,
    section: 'CSE Section B',
    fileName: 'newton_raphson_problem_set.pdf',
    note: 'All iteration tables are included.',
    submittedAt: 'Jul 24, 2026 01:30 PM',
    status: 'Reviewed',
    marks: 14,
    feedback: 'Correct method and clean tables.',
  ),
  AssignmentSubmission(
    assignmentId: 'as-ai-ethics',
    studentId: currentStudentId,
    studentName: currentStudentName,
    section: 'CSE Section A',
    fileName: 'ai_ethics_reflection.pdf',
    note: 'Late submission after electricity issue.',
    submittedAt: 'Jul 19, 2026 08:40 PM',
    status: 'Reviewed',
    marks: 8,
    feedback: 'Good reflection. Late mark applied.',
    isLate: true,
  ),
];

const demoQuizzes = [
  CourseQuiz(
    id: 'q-ai-informed',
    subjectCode: 'CSE 410',
    title: 'Informed Search Quiz',
    description: 'A*, greedy search, admissible heuristics, and path cost.',
    schedule: 'Jul 26, 2026 10:00 AM',
    duration: '20 min',
    totalMarks: 20,
    questionCount: 10,
    status: 'Open',
    questions: [
      QuizQuestion(
        question: 'Which property makes a heuristic safe for A* optimality?',
        options: ['Admissible', 'Random', 'Expensive', 'Unbounded'],
        answer: 'Admissible',
      ),
      QuizQuestion(
        question: 'Greedy best-first search primarily expands nodes by what?',
        options: ['h(n)', 'g(n)', 'alphabetical order', 'roll number'],
        answer: 'h(n)',
      ),
    ],
  ),
  CourseQuiz(
    id: 'q-se-agile',
    subjectCode: 'CSE 420',
    title: 'Agile and SRS Check',
    description:
        'Backlog, sprint planning, acceptance criteria, and SRS scope.',
    schedule: 'Jul 29, 2026 12:00 PM',
    duration: '15 min',
    totalMarks: 15,
    questionCount: 8,
    status: 'Upcoming',
    questions: [
      QuizQuestion(
        question: 'What describes a user story best?',
        options: ['User goal', 'Database table', 'Compiler flag', 'IP address'],
        answer: 'User goal',
      ),
      QuizQuestion(
        question: 'Acceptance criteria help define what?',
        options: ['Done behavior', 'Font size', 'Cable type', 'Room number'],
        answer: 'Done behavior',
      ),
    ],
  ),
  CourseQuiz(
    id: 'q-mat-roots',
    subjectCode: 'MAT 301',
    title: 'Root Finding Quiz',
    description: 'Bisection method, Newton Raphson, and convergence checks.',
    schedule: 'Jul 22, 2026 09:00 AM',
    duration: '25 min',
    totalMarks: 20,
    questionCount: 12,
    status: 'Completed',
    questions: [
      QuizQuestion(
        question: 'Bisection method requires what initial condition?',
        options: [
          'Opposite signs',
          'Same derivative',
          'Matrix inverse',
          'Prime number',
        ],
        answer: 'Opposite signs',
      ),
      QuizQuestion(
        question: 'Newton Raphson uses which derivative information?',
        options: ['First derivative', 'No derivative', 'Graph color', 'CGPA'],
        answer: 'First derivative',
      ),
    ],
  ),
  CourseQuiz(
    id: 'q-dld-gates',
    subjectCode: 'EEE 210',
    title: 'Logic Gates Quick Test',
    description: 'Truth tables, universal gates, and simplification basics.',
    schedule: 'Aug 1, 2026 01:30 PM',
    duration: '15 min',
    totalMarks: 10,
    questionCount: 6,
    status: 'Draft',
    questions: [
      QuizQuestion(
        question: 'Which gate is universal?',
        options: ['NAND', 'XOR only', 'Buffer only', 'LED'],
        answer: 'NAND',
      ),
      QuizQuestion(
        question: 'A NOT gate has how many inputs?',
        options: ['One', 'Two', 'Three', 'Four'],
        answer: 'One',
      ),
    ],
  ),
];

const demoQuizAttempts = [
  QuizAttempt(
    quizId: 'q-mat-roots',
    studentId: currentStudentId,
    studentName: currentStudentName,
    submittedAt: 'Jul 22, 2026 09:24 AM',
    score: 17,
    status: 'Submitted',
  ),
  QuizAttempt(
    quizId: 'q-ai-informed',
    studentId: 'CSE-2026-017',
    studentName: 'Maliha Rahman',
    submittedAt: 'Jul 24, 2026 10:18 AM',
    score: 16,
    status: 'Submitted',
  ),
  QuizAttempt(
    quizId: 'q-ai-informed',
    studentId: 'CSE-2026-021',
    studentName: 'Rafi Hasan',
    submittedAt: 'Jul 24, 2026 10:22 AM',
    score: 14,
    status: 'Submitted',
  ),
];

CourseSubject subjectForCode(String code) {
  for (final subject in demoSubjects) {
    if (subject.code == code) {
      return subject;
    }
  }
  return demoSubjects.first;
}
