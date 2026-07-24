import 'package:eub_connect/core/backend/app_failure.dart';
import 'package:eub_connect/core/backend/supabase_backend.dart';
import 'package:eub_connect/feature/common/assignment_quiz/model/assignment_quiz_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AssignmentQuizRepository {
  SupabaseClient? get _client => SupabaseBackend.client;

  Future<AppResult<AssignmentQuizWorkspace>> loadWorkspace() async {
    final client = _client;
    if (client == null) {
      return AppResult.failure(SupabaseBackend.notConfiguredFailure());
    }

    try {
      final assignmentsRows = await client
          .from('assignments')
          .select(
            'id, section_id, title, instructions, total_marks, due_at, status, allow_resubmission, '
            'course_sections(id, section_code, courses(code, title), teacher_course_assignments(teachers(profiles(full_name))))',
          )
          .order('due_at');
      final submissionsRows = await client
          .from('assignment_submissions')
          .select(
            'id, assignment_id, student_id, note, status, submitted_at, '
            'students(student_no, profiles(full_name)), assignment_grades(marks, feedback)',
          )
          .order('created_at', ascending: false);
      final quizRows = await client
          .from('quizzes')
          .select(
            'id, section_id, title, instructions, duration_minutes, total_marks, opens_at, closes_at, attempt_limit, show_result_immediately, status, '
            'course_sections(id, section_code, courses(code, title), teacher_course_assignments(teachers(profiles(full_name)))), '
            'quiz_questions(id, question_text, marks, sort_order, quiz_options(id, option_text, sort_order))',
          )
          .order('opens_at');
      final attemptRows = await client
          .from('quiz_attempts')
          .select(
            'id, quiz_id, student_id, score, status, submitted_at, students(student_no, profiles(full_name))',
          )
          .order('started_at', ascending: false);

      final assignments = assignmentsRows
          .whereType<Map<String, dynamic>>()
          .map(_assignmentFromRow)
          .toList();
      final submissions = submissionsRows
          .whereType<Map<String, dynamic>>()
          .map(_submissionFromRow)
          .toList();
      final quizzes = quizRows
          .whereType<Map<String, dynamic>>()
          .map(_quizFromRow)
          .toList();
      final attempts = attemptRows
          .whereType<Map<String, dynamic>>()
          .map(_attemptFromRow)
          .toList();

      final subjects = <String, CourseSubject>{};
      for (final assignment in assignments) {
        subjects[assignment.subject.sectionId] = assignment.subject;
      }
      for (final quiz in quizzes) {
        subjects[quiz.subject.sectionId] = quiz.subject;
      }

      return AppResult.success(
        AssignmentQuizWorkspace(
          subjects: subjects.values.toList(),
          assignments: assignments,
          submissions: submissions,
          quizzes: quizzes,
          attempts: attempts,
        ),
      );
    } on PostgrestException catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.server,
          message: error.message,
          detail: error,
        ),
      );
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.unknown,
          message: 'Unable to load assignments and quizzes.',
          detail: error,
        ),
      );
    }
  }

  Future<AppResult<void>> submitAssignment({
    required String assignmentId,
    required String note,
  }) async {
    final client = _client;
    if (client == null) {
      return AppResult.failure(SupabaseBackend.notConfiguredFailure());
    }

    try {
      final student = await client
          .from('students')
          .select('id')
          .eq('profile_id', client.auth.currentUser!.id)
          .maybeSingle();
      if (student == null) {
        return const AppResult.failure(
          AppFailure(
            type: AppFailureType.forbidden,
            message: 'Only student accounts can submit assignments.',
          ),
        );
      }

      await client.from('assignment_submissions').upsert({
        'assignment_id': assignmentId,
        'student_id': student['id'],
        'note': note,
        'status': 'submitted',
        'submitted_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'assignment_id,student_id');

      return const AppResult.success(null);
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.server,
          message: 'Unable to submit assignment.',
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
    final client = _client;
    if (client == null) {
      return AppResult.failure(SupabaseBackend.notConfiguredFailure());
    }

    try {
      await client.from('assignment_grades').upsert({
        'submission_id': submissionId,
        'marks': marks,
        'feedback': feedback,
        'graded_by': client.auth.currentUser?.id,
        'graded_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'submission_id');
      await client
          .from('assignment_submissions')
          .update({'status': 'graded'})
          .eq('id', submissionId);
      return const AppResult.success(null);
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.server,
          message: 'Unable to grade submission.',
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
    final client = _client;
    if (client == null) {
      return AppResult.failure(SupabaseBackend.notConfiguredFailure());
    }

    try {
      await client.from('assignments').insert({
        'section_id': sectionId,
        'title': title,
        'instructions': instructions,
        'total_marks': totalMarks,
        'due_at': dueAt.toUtc().toIso8601String(),
        'opens_at': DateTime.now().toUtc().toIso8601String(),
        'status': 'published',
        'created_by': client.auth.currentUser?.id,
      });
      return const AppResult.success(null);
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.server,
          message: 'Unable to publish assignment.',
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
    final client = _client;
    if (client == null) {
      return AppResult.failure(SupabaseBackend.notConfiguredFailure());
    }

    try {
      await client.from('quizzes').insert({
        'section_id': sectionId,
        'title': title,
        'instructions': instructions,
        'total_marks': totalMarks,
        'duration_minutes': durationMinutes,
        'opens_at': opensAt.toUtc().toIso8601String(),
        'closes_at': closesAt.toUtc().toIso8601String(),
        'status': 'published',
        'created_by': client.auth.currentUser?.id,
      });
      return const AppResult.success(null);
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.server,
          message: 'Unable to publish quiz.',
          detail: error,
        ),
      );
    }
  }

  Future<AppResult<void>> submitQuizAttempt({required String quizId}) async {
    final client = _client;
    if (client == null) {
      return AppResult.failure(SupabaseBackend.notConfiguredFailure());
    }

    try {
      final student = await client
          .from('students')
          .select('id')
          .eq('profile_id', client.auth.currentUser!.id)
          .maybeSingle();
      if (student == null) {
        return const AppResult.failure(
          AppFailure(
            type: AppFailureType.forbidden,
            message: 'Only student accounts can submit quiz attempts.',
          ),
        );
      }

      await client.from('quiz_attempts').insert({
        'quiz_id': quizId,
        'student_id': student['id'],
        'attempt_no': 1,
        'status': 'submitted',
        'submitted_at': DateTime.now().toUtc().toIso8601String(),
      });
      return const AppResult.success(null);
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.server,
          message: 'Unable to submit quiz attempt.',
          detail: error,
        ),
      );
    }
  }

  CourseAssignment _assignmentFromRow(Map<String, dynamic> row) {
    return CourseAssignment(
      id: row['id'] as String,
      sectionId: row['section_id'] as String,
      subject: _subjectFromSection(row['course_sections']),
      title: row['title'] as String? ?? 'Untitled assignment',
      instructions: row['instructions'] as String? ?? '',
      dueAt: _dateTime(row['due_at']),
      totalMarks: row['total_marks'] as num? ?? 0,
      status: row['status'] as String? ?? 'draft',
      allowResubmission: row['allow_resubmission'] as bool? ?? true,
    );
  }

  AssignmentSubmission _submissionFromRow(Map<String, dynamic> row) {
    final student = row['students'];
    final profile = student is Map<String, dynamic>
        ? student['profiles'] as Map<String, dynamic>?
        : null;
    final grades = row['assignment_grades'];
    final grade = grades is List && grades.isNotEmpty
        ? grades.first as Map<String, dynamic>
        : grades is Map<String, dynamic>
        ? grades
        : null;

    return AssignmentSubmission(
      id: row['id'] as String,
      assignmentId: row['assignment_id'] as String,
      studentId: row['student_id'] as String,
      studentName: profile?['full_name'] as String? ?? 'Student',
      note: row['note'] as String? ?? '',
      status: row['status'] as String? ?? 'submitted',
      submittedAt: _nullableDateTime(row['submitted_at']),
      marks: grade?['marks'] as num?,
      feedback: grade?['feedback'] as String?,
    );
  }

  CourseQuiz _quizFromRow(Map<String, dynamic> row) {
    final questionsData = row['quiz_questions'];
    final questions = questionsData is List
        ? questionsData
              .whereType<Map<String, dynamic>>()
              .map(_questionFromRow)
              .toList()
        : <QuizQuestion>[];
    questions.sort((a, b) => a.question.compareTo(b.question));

    return CourseQuiz(
      id: row['id'] as String,
      sectionId: row['section_id'] as String,
      subject: _subjectFromSection(row['course_sections']),
      title: row['title'] as String? ?? 'Untitled quiz',
      instructions: row['instructions'] as String? ?? '',
      opensAt: _dateTime(row['opens_at']),
      closesAt: _dateTime(row['closes_at']),
      durationMinutes: row['duration_minutes'] as int? ?? 0,
      totalMarks: row['total_marks'] as num? ?? 0,
      attemptLimit: row['attempt_limit'] as int? ?? 1,
      showResultImmediately: row['show_result_immediately'] as bool? ?? false,
      status: row['status'] as String? ?? 'draft',
      questions: questions,
    );
  }

  QuizQuestion _questionFromRow(Map<String, dynamic> row) {
    final optionsData = row['quiz_options'];
    final options = optionsData is List
        ? optionsData
              .whereType<Map<String, dynamic>>()
              .map(
                (option) => QuizOption(
                  id: option['id'] as String,
                  text: option['option_text'] as String? ?? '',
                ),
              )
              .toList()
        : <QuizOption>[];

    return QuizQuestion(
      id: row['id'] as String,
      question: row['question_text'] as String? ?? '',
      marks: row['marks'] as num? ?? 0,
      options: options,
    );
  }

  QuizAttempt _attemptFromRow(Map<String, dynamic> row) {
    final student = row['students'];
    final profile = student is Map<String, dynamic>
        ? student['profiles'] as Map<String, dynamic>?
        : null;

    return QuizAttempt(
      id: row['id'] as String,
      quizId: row['quiz_id'] as String,
      studentId: row['student_id'] as String,
      studentName: profile?['full_name'] as String? ?? 'Student',
      status: row['status'] as String? ?? 'submitted',
      submittedAt: _nullableDateTime(row['submitted_at']),
      score: row['score'] as num?,
    );
  }

  CourseSubject _subjectFromSection(Object? data) {
    final section = data is Map<String, dynamic> ? data : <String, dynamic>{};
    final course = section['courses'] is Map<String, dynamic>
        ? section['courses'] as Map<String, dynamic>
        : <String, dynamic>{};
    final assignments = section['teacher_course_assignments'];
    String teacher = 'Assigned teacher';
    if (assignments is List && assignments.isNotEmpty) {
      final teacherRow = assignments.first['teachers'];
      if (teacherRow is Map<String, dynamic>) {
        final profile = teacherRow['profiles'];
        if (profile is Map<String, dynamic>) {
          teacher = profile['full_name'] as String? ?? teacher;
        }
      }
    }

    return CourseSubject(
      sectionId: section['id'] as String? ?? '',
      code: course['code'] as String? ?? 'COURSE',
      name: course['title'] as String? ?? 'Course',
      teacher: teacher,
      section: section['section_code'] as String? ?? '',
    );
  }

  DateTime _dateTime(Object? value) {
    return _nullableDateTime(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  DateTime? _nullableDateTime(Object? value) {
    if (value == null) {
      return null;
    }
    return DateTime.tryParse(value.toString())?.toLocal();
  }
}
