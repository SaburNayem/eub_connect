import 'dart:math';

import 'package:eub_connect/core/demo/demo_models.dart';
import 'package:eub_connect/core/demo/demo_seed.dart';
import 'package:eub_connect/feature/common/assignment_quiz/model/assignment_quiz_models.dart';
import 'package:eub_connect/feature/home/model/static_feature.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class DemoStore extends GetxController {
  DemoStore._(this._storage);

  static const _boxName = 'eub_connect_demo';
  static const _stateKey = 'presentation_state_v3';
  static DemoStore? _instance;

  final GetStorage _storage;
  final revision = 0.obs;

  String? currentAccountId;
  List<DemoAccount> accounts = [];
  List<DemoDepartment> departments = [];
  List<DemoCourse> courses = [];
  List<DemoSection> sections = [];
  List<DemoEnrollment> enrollments = [];
  List<DemoScheduleEntry> schedules = [];
  List<DemoAttendanceRecord> attendance = [];
  List<DemoAssignment> assignments = [];
  List<DemoSubmission> submissions = [];
  List<DemoQuiz> quizzes = [];
  List<DemoQuizAttempt> quizAttempts = [];
  List<DemoNotice> notices = [];
  List<DemoEvent> events = [];
  List<DemoEventRegistration> eventRegistrations = [];
  List<DemoClub> clubs = [];
  List<DemoClubMembership> clubMemberships = [];
  List<DemoForumCategory> forumCategories = [];
  List<DemoForumPost> forumPosts = [];
  List<DemoForumComment> forumComments = [];
  List<DemoForumReport> forumReports = [];
  List<DemoSupportTicket> supportTickets = [];
  List<DemoSupportMessage> supportMessages = [];
  List<DemoInvoice> invoices = [];
  List<DemoPayment> payments = [];
  List<DemoResult> results = [];
  List<DemoScholarship> scholarships = [];
  List<DemoNotification> notifications = [];
  List<DemoApproval> approvals = [];
  List<DemoActivity> activities = [];

  static DemoStore get instance {
    final active = _instance;
    if (active != null) {
      return active;
    }
    if (Get.isRegistered<DemoStore>()) {
      return Get.find<DemoStore>();
    }
    throw StateError('DemoStore.initialize must be called before use.');
  }

  static Future<DemoStore> initialize() async {
    await GetStorage.init(_boxName);
    final store = DemoStore._(GetStorage(_boxName));
    store._load();
    _instance = store;
    if (!Get.isRegistered<DemoStore>()) {
      Get.put(store, permanent: true);
    }
    return store;
  }

  DemoAccount? get currentAccount => accountById(currentAccountId);

  PortalRole get currentRole => currentAccount?.role ?? PortalRole.student;

  List<DemoAccount> get studentAccounts {
    return accounts
        .where((account) => account.role == PortalRole.student)
        .toList();
  }

  List<DemoAccount> get teacherAccounts {
    return accounts
        .where((account) => account.role == PortalRole.teacher)
        .toList();
  }

  List<DemoAccount> get demoLoginAccounts {
    const ids = ['u-stu-001', 'u-tea-001', 'u-fac-001', 'u-adm-001'];
    return ids.map(accountById).whereType<DemoAccount>().toList();
  }

  DemoAccount? restoreSession() {
    final id = currentAccountId;
    if (id == null) {
      return null;
    }
    final account = accountById(id);
    if (account == null || !account.active) {
      currentAccountId = null;
      _persist();
      return null;
    }
    return account;
  }

  DemoAccount? signIn({required String identifier, required String password}) {
    final cleanIdentifier = identifier.trim().toLowerCase();
    final account = accounts.firstWhereOrNull((candidate) {
      return candidate.active &&
          candidate.password == password &&
          (candidate.email.toLowerCase() == cleanIdentifier ||
              candidate.universityId.toLowerCase() == cleanIdentifier);
    });
    if (account == null) {
      return null;
    }
    currentAccountId = account.id;
    addActivity(
      actorId: account.id,
      title: '${account.role.label} signed in',
      detail:
          '${account.fullName} opened the ${account.role.label.toLowerCase()} workspace.',
    );
    _persist();
    return account;
  }

  DemoAccount registerStudent({
    required String universityId,
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) {
    final exists = accounts.any((account) {
      return account.email.toLowerCase() == email.toLowerCase() ||
          account.universityId.toLowerCase() == universityId.toLowerCase();
    });
    if (exists) {
      throw StateError('This ID or email already exists.');
    }
    final account = DemoAccount(
      id: _nextId('u-stu'),
      universityId: universityId,
      email: email,
      password: password,
      fullName: fullName,
      role: PortalRole.student,
      departmentId: 'dept-cse',
      program: 'B.Sc. in CSE',
      semester: 'Spring 2026',
      section: '6A',
      batch: '23',
      phone: phone,
      completedCredits: 0,
      currentCredits: 0,
    );
    accounts.add(account);
    currentAccountId = account.id;
    addNotification(
      userId: account.id,
      title: 'Account created',
      body: 'Your local student account is ready.',
    );
    addActivity(
      actorId: account.id,
      title: 'Student registered',
      detail: '$fullName created a local student account.',
    );
    _persist();
    return account;
  }

  Future<void> signOut() async {
    currentAccountId = null;
    _persist();
  }

  void resetDemoData() {
    _loadFromSnapshot(DemoSeed.snapshot());
    _persist();
  }

  DemoAccount? accountById(String? id) {
    if (id == null) {
      return null;
    }
    return accounts.firstWhereOrNull((account) => account.id == id);
  }

  DemoDepartment? departmentById(String? id) {
    return departments.firstWhereOrNull((department) => department.id == id);
  }

  DemoCourse? courseById(String? id) {
    return courses.firstWhereOrNull((course) => course.id == id);
  }

  DemoSection? sectionById(String? id) {
    return sections.firstWhereOrNull((section) => section.id == id);
  }

  String departmentName(String? departmentId) {
    return departmentById(departmentId)?.name ??
        'Eastern University Bangladesh';
  }

  CourseSubject subjectForSection(String sectionId) {
    final section = sectionById(sectionId);
    final course = courseById(section?.courseId);
    final teacher = accountById(section?.teacherId);
    return CourseSubject(
      sectionId: section?.id ?? sectionId,
      code: course?.code ?? 'Course',
      name: course?.title ?? 'Course',
      teacher: teacher?.fullName ?? 'Assigned teacher',
      section: section?.sectionCode ?? '',
    );
  }

  List<String> enrolledSectionIds(String studentId) {
    return enrollments
        .where((enrollment) => enrollment.studentId == studentId)
        .map((enrollment) => enrollment.sectionId)
        .toSet()
        .toList();
  }

  List<DemoSection> visibleSectionsForRole([PortalRole? role]) {
    final account = currentAccount;
    final activeRole = role ?? account?.role ?? PortalRole.student;
    switch (activeRole) {
      case PortalRole.student:
        final ids = enrolledSectionIds(account?.id ?? '');
        return sections.where((section) => ids.contains(section.id)).toList();
      case PortalRole.teacher:
        return sections
            .where((section) => section.teacherId == account?.id)
            .toList();
      case PortalRole.faculty:
        return sections.where((section) {
          final course = courseById(section.courseId);
          return course?.departmentId == account?.departmentId;
        }).toList();
      case PortalRole.admin:
        return [...sections];
    }
  }

  List<DemoScheduleEntry> schedulesForCurrentAccount() {
    final visibleIds = visibleSectionsForRole()
        .map((section) => section.id)
        .toSet();
    final result = schedules
        .where((schedule) => visibleIds.contains(schedule.sectionId))
        .toList();
    result.sort(
      (a, b) => '${a.day} ${a.start}'.compareTo('${b.day} ${b.start}'),
    );
    return result;
  }

  List<DemoAssignment> visibleAssignments() {
    final sectionIds = visibleSectionsForRole()
        .map((section) => section.id)
        .toSet();
    final result = assignments
        .where((assignment) => sectionIds.contains(assignment.sectionId))
        .toList();
    result.sort((a, b) => a.dueAt.compareTo(b.dueAt));
    return result;
  }

  List<DemoQuiz> visibleQuizzes() {
    final sectionIds = visibleSectionsForRole()
        .map((section) => section.id)
        .toSet();
    final result = quizzes
        .where((quiz) => sectionIds.contains(quiz.sectionId))
        .toList();
    result.sort((a, b) => a.opensAt.compareTo(b.opensAt));
    return result;
  }

  List<DemoSubmission> visibleSubmissions() {
    final account = currentAccount;
    if (account == null) {
      return [];
    }
    if (account.role == PortalRole.student) {
      return submissions
          .where((submission) => submission.studentId == account.id)
          .toList();
    }
    final assignmentIds = visibleAssignments().map((item) => item.id).toSet();
    return submissions
        .where((submission) => assignmentIds.contains(submission.assignmentId))
        .toList();
  }

  List<DemoQuizAttempt> visibleQuizAttempts() {
    final account = currentAccount;
    if (account == null) {
      return [];
    }
    if (account.role == PortalRole.student) {
      return quizAttempts
          .where((attempt) => attempt.studentId == account.id)
          .toList();
    }
    final quizIds = visibleQuizzes().map((item) => item.id).toSet();
    return quizAttempts
        .where((attempt) => quizIds.contains(attempt.quizId))
        .toList();
  }

  AssignmentQuizWorkspace assignmentQuizWorkspace() {
    final subjectMap = <String, CourseSubject>{};
    final visibleAssignmentRows = visibleAssignments();
    final visibleQuizRows = visibleQuizzes();
    for (final assignment in visibleAssignmentRows) {
      subjectMap[assignment.sectionId] = subjectForSection(
        assignment.sectionId,
      );
    }
    for (final quiz in visibleQuizRows) {
      subjectMap[quiz.sectionId] = subjectForSection(quiz.sectionId);
    }
    return AssignmentQuizWorkspace(
      subjects: subjectMap.values.toList(),
      assignments: visibleAssignmentRows.map((assignment) {
        return CourseAssignment(
          id: assignment.id,
          sectionId: assignment.sectionId,
          subject: subjectForSection(assignment.sectionId),
          title: assignment.title,
          instructions: assignment.instructions,
          dueAt: assignment.dueAt,
          totalMarks: assignment.totalMarks,
          status: assignment.status,
          allowResubmission: assignment.allowResubmission,
          attachments: assignment.attachments,
        );
      }).toList(),
      submissions: visibleSubmissions().map((submission) {
        return AssignmentSubmission(
          id: submission.id,
          assignmentId: submission.assignmentId,
          studentId: submission.studentId,
          studentName: accountById(submission.studentId)?.fullName ?? 'Student',
          note: submission.note,
          status: submission.status,
          submittedAt: submission.submittedAt,
          marks: submission.marks,
          feedback: submission.feedback,
        );
      }).toList(),
      quizzes: visibleQuizRows.map((quiz) {
        return CourseQuiz(
          id: quiz.id,
          sectionId: quiz.sectionId,
          subject: subjectForSection(quiz.sectionId),
          title: quiz.title,
          instructions: quiz.instructions,
          opensAt: quiz.opensAt,
          closesAt: quiz.closesAt,
          durationMinutes: quiz.durationMinutes,
          totalMarks: quiz.totalMarks,
          attemptLimit: quiz.attemptLimit,
          showResultImmediately: quiz.showResultImmediately,
          status: quiz.status,
          questions: quiz.questions.map((question) {
            return QuizQuestion(
              id: question.id,
              question: question.question,
              marks: question.marks,
              options: question.options
                  .map((option) => QuizOption(id: option.id, text: option.text))
                  .toList(),
            );
          }).toList(),
        );
      }).toList(),
      attempts: visibleQuizAttempts().map((attempt) {
        return QuizAttempt(
          id: attempt.id,
          quizId: attempt.quizId,
          studentId: attempt.studentId,
          studentName: accountById(attempt.studentId)?.fullName ?? 'Student',
          status: attempt.status,
          submittedAt: attempt.submittedAt,
          score: attempt.score,
        );
      }).toList(),
    );
  }

  void submitAssignment({
    required String assignmentId,
    required String note,
    String fileName = 'EUB-assignment-submission.pdf',
  }) {
    final student = currentAccount;
    if (student == null || student.role != PortalRole.student) {
      throw StateError('Only a student account can submit assignments.');
    }
    final assignment = assignments.firstWhere(
      (item) => item.id == assignmentId,
    );
    final existing = submissions.firstWhereOrNull((item) {
      return item.assignmentId == assignmentId && item.studentId == student.id;
    });
    if (existing == null) {
      submissions.add(
        DemoSubmission(
          id: _nextId('sub'),
          assignmentId: assignmentId,
          studentId: student.id,
          note: note,
          fileName: fileName.trim().isEmpty
              ? 'EUB-assignment-submission.pdf'
              : fileName,
          status: 'submitted',
          submittedAt: DateTime.now(),
        ),
      );
    } else {
      existing.note = note;
      existing.fileName = fileName.trim().isEmpty
          ? existing.fileName
          : fileName;
      existing.status = 'submitted';
      existing.submittedAt = DateTime.now();
      existing.marks = null;
      existing.feedback = null;
    }
    final teacher = sectionById(assignment.sectionId)?.teacherId;
    if (teacher != null) {
      addNotification(
        userId: teacher,
        title: 'New assignment submission',
        body: '${student.fullName} submitted ${assignment.title}.',
      );
    }
    addActivity(
      actorId: student.id,
      title: 'Student submitted assignment',
      detail: '${student.fullName} submitted ${assignment.title}.',
    );
    _persist();
  }

  void gradeSubmission({
    required String submissionId,
    required num marks,
    required String feedback,
  }) {
    final teacher = currentAccount;
    final submission = submissions.firstWhere(
      (item) => item.id == submissionId,
    );
    final assignment = assignments.firstWhere(
      (item) => item.id == submission.assignmentId,
    );
    submission.marks = marks;
    submission.feedback = feedback;
    submission.status = 'graded';
    addNotification(
      userId: submission.studentId,
      title: 'Assignment graded',
      body: 'Your ${assignment.title} submission has been graded.',
    );
    addActivity(
      actorId: teacher?.id ?? 'u-adm-001',
      title: 'Teacher graded assignment',
      detail:
          '${teacher?.fullName ?? 'Teacher'} graded ${assignment.title} for ${accountById(submission.studentId)?.fullName ?? 'a student'}.',
    );
    _persist();
  }

  void publishAssignment({
    required String sectionId,
    required String title,
    required String instructions,
    required num totalMarks,
    required DateTime dueAt,
  }) {
    final teacher = currentAccount;
    if (teacher == null) {
      throw StateError('No account is signed in.');
    }
    final assignment = DemoAssignment(
      id: _nextId('asg'),
      sectionId: sectionId,
      teacherId: teacher.id,
      title: title,
      instructions: instructions,
      totalMarks: totalMarks,
      publishedAt: DateTime.now(),
      dueAt: dueAt,
      status: 'published',
      attachments: [
        'teacher-brief-${DateTime.now().millisecondsSinceEpoch}.pdf',
      ],
    );
    assignments.add(assignment);
    for (final enrollment in enrollments.where(
      (item) => item.sectionId == sectionId,
    )) {
      addNotification(
        userId: enrollment.studentId,
        title: 'New assignment posted',
        body:
            '${assignment.title} is available for ${subjectForSection(sectionId).code}.',
      );
    }
    addActivity(
      actorId: teacher.id,
      title: 'Teacher created assignment',
      detail: '${teacher.fullName} published ${assignment.title}.',
    );
    _persist();
  }

  void publishQuiz({
    required String sectionId,
    required String title,
    required String instructions,
    required num totalMarks,
    required int durationMinutes,
    required DateTime opensAt,
    required DateTime closesAt,
    required List<QuizDraftQuestion> questions,
  }) {
    final teacher = currentAccount;
    if (teacher == null) {
      throw StateError('No account is signed in.');
    }
    final prefix = 'quiz-${DateTime.now().millisecondsSinceEpoch}';
    final quizQuestions = questions.asMap().entries.map((entry) {
      final questionIndex = entry.key + 1;
      final draft = entry.value;
      final questionId = '$prefix-q$questionIndex';
      return DemoQuizQuestion(
        id: questionId,
        question: draft.question.trim(),
        marks: draft.marks,
        correctOptionId: '$questionId-o${draft.correctIndex + 1}',
        options: draft.options.asMap().entries.map((optionEntry) {
          return DemoQuizOption(
            id: '$questionId-o${optionEntry.key + 1}',
            text: optionEntry.value.trim(),
          );
        }).toList(),
      );
    }).toList();
    final quiz = DemoQuiz(
      id: _nextId('quiz'),
      sectionId: sectionId,
      teacherId: teacher.id,
      title: title,
      instructions: instructions,
      totalMarks: totalMarks,
      durationMinutes: durationMinutes,
      opensAt: opensAt,
      closesAt: closesAt,
      status: 'published',
      questions: quizQuestions,
    );
    quizzes.add(quiz);
    for (final enrollment in enrollments.where(
      (item) => item.sectionId == sectionId,
    )) {
      addNotification(
        userId: enrollment.studentId,
        title: 'Upcoming quiz',
        body: '${quiz.title} is open for ${subjectForSection(sectionId).code}.',
      );
    }
    addActivity(
      actorId: teacher.id,
      title: 'Teacher created quiz',
      detail: '${teacher.fullName} published ${quiz.title}.',
    );
    _persist();
  }

  void submitQuizAttempt(String quizId) {
    final student = currentAccount;
    if (student == null || student.role != PortalRole.student) {
      throw StateError('Only a student account can submit quizzes.');
    }
    final quiz = quizzes.firstWhere((item) => item.id == quizId);
    final existingAttempts = quizAttempts
        .where(
          (attempt) =>
              attempt.quizId == quizId && attempt.studentId == student.id,
        )
        .toList();
    final score = _demoQuizScore(quiz, existingAttempts.length);
    quizAttempts.add(
      DemoQuizAttempt(
        id: _nextId('qat'),
        quizId: quizId,
        studentId: student.id,
        status: 'submitted',
        submittedAt: DateTime.now(),
        score: score,
        answers: {
          for (final question in quiz.questions)
            question.id: question.options.isEmpty
                ? ''
                : question
                      .options[min(
                        existingAttempts.length,
                        question.options.length - 1,
                      )]
                      .id,
        },
      ),
    );
    addNotification(
      userId: sectionById(quiz.sectionId)?.teacherId ?? 'u-tea-001',
      title: 'Quiz attempt submitted',
      body: '${student.fullName} submitted ${quiz.title}.',
    );
    addActivity(
      actorId: student.id,
      title: 'Student submitted quiz',
      detail:
          '${student.fullName} scored $score/${quiz.totalMarks} in ${quiz.title}.',
    );
    _persist();
  }

  void markTodayAttendanceForFirstTeacherSection() {
    final teacher = currentAccount;
    final section = visibleSectionsForRole(PortalRole.teacher).firstOrNull;
    if (teacher == null || section == null) {
      throw StateError('No assigned section is available.');
    }
    final students = enrollments.where((item) => item.sectionId == section.id);
    final date = DateTime.now();
    for (final enrollment in students) {
      final existing = attendance.firstWhereOrNull((record) {
        return record.sectionId == section.id &&
            record.studentId == enrollment.studentId &&
            record.date.year == date.year &&
            record.date.month == date.month &&
            record.date.day == date.day;
      });
      if (existing == null) {
        attendance.add(
          DemoAttendanceRecord(
            id: _nextId('att'),
            sectionId: section.id,
            studentId: enrollment.studentId,
            date: date,
            slot: '09:00 AM',
            status: DemoAttendanceStatus.present,
            note: 'Marked present by ${teacher.fullName}.',
          ),
        );
      } else {
        existing.status = DemoAttendanceStatus.present;
        existing.note = 'Updated to present by ${teacher.fullName}.';
      }
    }
    addActivity(
      actorId: teacher.id,
      title: 'Attendance saved',
      detail:
          '${teacher.fullName} marked all students present for ${subjectForSection(section.id).code}.',
    );
    _persist();
  }

  void simulateDemoPayment() {
    final student = currentAccount;
    if (student == null) {
      throw StateError('No account is signed in.');
    }
    final invoice = invoices.firstWhereOrNull((item) {
      return item.studentId == student.id && item.due > 0;
    });
    if (invoice == null) {
      throw StateError('No unpaid invoice is available for this account.');
    }
    final amount = min<num>(5000, invoice.due);
    invoice.paid += amount;
    payments.add(
      DemoPayment(
        id: _nextId('pay'),
        invoiceId: invoice.id,
        studentId: student.id,
        amount: amount,
        method: 'Portal payment simulation',
        paidAt: DateTime.now(),
        receiptNo: 'EUB-DEMO-${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
    addNotification(
      userId: student.id,
      title: 'Payment received',
      body:
          'Payment of ${_money(amount)} has been posted to ${invoice.semester}.',
    );
    addActivity(
      actorId: student.id,
      title: 'Payment received',
      detail: '${student.fullName} paid ${_money(amount)} through the portal.',
    );
    _persist();
  }

  void registerNextEvent() {
    final student = currentAccount;
    if (student == null) {
      throw StateError('No account is signed in.');
    }
    final event = events.firstWhereOrNull((candidate) {
      return candidate.status == 'published' &&
          !eventRegistrations.any((registration) {
            return registration.eventId == candidate.id &&
                registration.studentId == student.id &&
                registration.status == 'registered';
          });
    });
    if (event == null) {
      throw StateError('You are already registered for all available events.');
    }
    eventRegistrations.add(
      DemoEventRegistration(
        id: _nextId('ereg'),
        eventId: event.id,
        studentId: student.id,
        registeredAt: DateTime.now(),
        status: 'registered',
      ),
    );
    addNotification(
      userId: student.id,
      title: 'Event registration confirmed',
      body: 'You are registered for ${event.title}.',
    );
    addActivity(
      actorId: student.id,
      title: 'Event registration',
      detail: '${student.fullName} registered for ${event.title}.',
    );
    _persist();
  }

  void joinFirstOpenClub() {
    final student = currentAccount;
    if (student == null) {
      throw StateError('No account is signed in.');
    }
    final club = clubs.firstWhereOrNull((candidate) {
      return !clubMemberships.any((membership) {
        return membership.clubId == candidate.id &&
            membership.studentId == student.id &&
            membership.status == 'active';
      });
    });
    if (club == null) {
      throw StateError('You already belong to every club.');
    }
    clubMemberships.add(
      DemoClubMembership(
        id: _nextId('cm'),
        clubId: club.id,
        studentId: student.id,
        status: 'active',
        joinedAt: DateTime.now(),
      ),
    );
    addActivity(
      actorId: student.id,
      title: 'Student joined club',
      detail: '${student.fullName} joined ${club.name}.',
    );
    _persist();
  }

  void createForumPost({
    required String categoryId,
    required String title,
    required String body,
  }) {
    final account = currentAccount;
    if (account == null) {
      throw StateError('No account is signed in.');
    }
    final post = DemoForumPost(
      id: _nextId('post'),
      categoryId: categoryId,
      authorId: account.id,
      title: title.trim(),
      body: body.trim(),
      createdAt: DateTime.now(),
      reactions: 0,
    );
    forumPosts.insert(0, post);
    addActivity(
      actorId: account.id,
      title: 'Forum post created',
      detail: '${account.fullName} created a discussion post.',
    );
    _persist();
  }

  void reportLatestForumPost({String? reason}) {
    final account = currentAccount;
    if (account == null) {
      throw StateError('No account is signed in.');
    }
    final post = forumPosts.firstWhereOrNull(
      (item) => !item.hidden && item.authorId != account.id,
    );
    if (post == null) {
      throw StateError('No reportable post is available.');
    }
    forumReports.add(
      DemoForumReport(
        id: _nextId('report'),
        postId: post.id,
        reporterId: account.id,
        reason: reason?.trim().isNotEmpty == true
            ? reason!.trim()
            : 'Requested moderator review for this discussion.',
        status: 'pending',
        createdAt: DateTime.now(),
      ),
    );
    addNotification(
      userId: 'u-adm-001',
      title: 'New forum report',
      body: '${account.fullName} reported "${post.title}".',
    );
    addActivity(
      actorId: account.id,
      title: 'Forum report created',
      detail: '${account.fullName} reported a discussion post.',
    );
    _persist();
  }

  void resolveFirstForumReport({bool hideContent = false}) {
    final actor = currentAccount;
    final report = forumReports.firstWhereOrNull(
      (item) => item.status == 'pending',
    );
    if (report == null) {
      throw StateError('No pending forum reports are available.');
    }
    report.status = hideContent ? 'removed' : 'resolved';
    if (hideContent) {
      forumPosts.firstWhereOrNull((post) => post.id == report.postId)?.hidden =
          true;
      if (report.commentId != null) {
        forumComments
                .firstWhereOrNull((comment) => comment.id == report.commentId)
                ?.hidden =
            true;
      }
    }
    addActivity(
      actorId: actor?.id ?? 'u-adm-001',
      title: 'Forum moderation resolved',
      detail:
          '${actor?.fullName ?? 'Moderator'} resolved a reported discussion.',
    );
    _persist();
  }

  void createSupportTicket({
    required String category,
    required String subject,
    required String priority,
    required String description,
  }) {
    final requester = currentAccount;
    if (requester == null) {
      throw StateError('No account is signed in.');
    }
    final ticket = DemoSupportTicket(
      id: _nextId('ticket'),
      requesterId: requester.id,
      subject: subject.trim(),
      category: category.trim(),
      priority: priority.trim(),
      status: 'open',
      createdAt: DateTime.now(),
    );
    supportTickets.insert(0, ticket);
    supportMessages.add(
      DemoSupportMessage(
        id: _nextId('msg'),
        ticketId: ticket.id,
        authorId: requester.id,
        message: description.trim(),
        createdAt: DateTime.now(),
      ),
    );
    addNotification(
      userId: 'u-fac-001',
      title: 'New support ticket',
      body: '${requester.fullName} created "${ticket.subject}".',
    );
    addActivity(
      actorId: requester.id,
      title: 'Support ticket created',
      detail: '${requester.fullName} created a support ticket.',
    );
    _persist();
  }

  void replyFirstOpenSupportTicket({String? message}) {
    final actor = currentAccount;
    final ticket = supportTickets.firstWhereOrNull(
      (item) => item.status != 'closed',
    );
    if (ticket == null) {
      throw StateError('No open support ticket is available.');
    }
    ticket.status = 'pending';
    supportMessages.add(
      DemoSupportMessage(
        id: _nextId('msg'),
        ticketId: ticket.id,
        authorId: actor?.id ?? 'u-fac-001',
        message: message?.trim().isNotEmpty == true
            ? message!.trim()
            : 'Your request has been reviewed. Please check the updated portal record.',
        createdAt: DateTime.now(),
      ),
    );
    addNotification(
      userId: ticket.requesterId,
      title: 'Support replied',
      body: 'A reply was added to "${ticket.subject}".',
    );
    addActivity(
      actorId: actor?.id ?? 'u-fac-001',
      title: 'Support reply sent',
      detail: '${actor?.fullName ?? 'Faculty'} replied to ${ticket.subject}.',
    );
    _persist();
  }

  void approveFirstPendingRequest() {
    final actor = currentAccount;
    final approval = approvals.firstWhereOrNull(
      (item) => item.status == 'pending',
    );
    if (approval == null) {
      throw StateError('No pending approval is available.');
    }
    approval.status = 'approved';
    addNotification(
      userId: approval.requesterId,
      title: 'Approval completed',
      body: '${approval.title} has been approved.',
    );
    addActivity(
      actorId: actor?.id ?? 'u-adm-001',
      title: 'Admin approved request',
      detail: '${actor?.fullName ?? 'Admin'} approved ${approval.title}.',
    );
    _persist();
  }

  void addCourseNotice() {
    final teacher = currentAccount;
    final section = visibleSectionsForRole().firstOrNull;
    if (teacher == null || section == null) {
      throw StateError('No section is available for notice publishing.');
    }
    final subject = subjectForSection(section.id);
    notices.insert(
      0,
      DemoNotice(
        id: _nextId('notice'),
        title: '${subject.code} class update',
        body:
            'Please review the latest class instructions before the next session.',
        authorId: teacher.id,
        target: 'students',
        publishedAt: DateTime.now(),
        sectionId: section.id,
      ),
    );
    for (final enrollment in enrollments.where(
      (item) => item.sectionId == section.id,
    )) {
      addNotification(
        userId: enrollment.studentId,
        title: 'New course notice',
        body: '${subject.code} notice was posted by ${teacher.fullName}.',
      );
    }
    addActivity(
      actorId: teacher.id,
      title: 'Teacher posted notice',
      detail: '${teacher.fullName} posted a notice for ${subject.code}.',
    );
    _persist();
  }

  void publishNotice({
    required String title,
    required String body,
    required String target,
    String? sectionId,
  }) {
    final actor = currentAccount;
    if (actor == null) {
      throw StateError('No account is signed in.');
    }
    final notice = DemoNotice(
      id: _nextId('notice'),
      title: title.trim(),
      body: body.trim(),
      authorId: actor.id,
      target: target,
      publishedAt: DateTime.now(),
      sectionId: sectionId,
    );
    notices.insert(0, notice);

    final recipients = <String>{};
    if (sectionId != null && sectionId.isNotEmpty) {
      recipients.addAll(
        enrollments
            .where((enrollment) => enrollment.sectionId == sectionId)
            .map((enrollment) => enrollment.studentId),
      );
    } else {
      for (final account in accounts) {
        if (target == 'all' || account.role.code == target) {
          recipients.add(account.id);
        }
      }
    }
    for (final recipient in recipients) {
      addNotification(
        userId: recipient,
        title: 'New notice published',
        body: notice.title,
      );
    }
    addActivity(
      actorId: actor.id,
      title: 'Notice published',
      detail: '${actor.fullName} published ${notice.title}.',
    );
    _persist();
  }

  void toggleFirstUserActive() {
    final user = accounts.firstWhereOrNull((account) {
      return account.role == PortalRole.student &&
          account.id != currentAccountId;
    });
    if (user == null) {
      throw StateError('No student user is available.');
    }
    user.active = !user.active;
    addActivity(
      actorId: currentAccount?.id ?? 'u-adm-001',
      title: user.active ? 'User activated' : 'User deactivated',
      detail: '${user.fullName} account status changed.',
    );
    _persist();
  }

  void markAllNotificationsRead() {
    final account = currentAccount;
    if (account == null) {
      return;
    }
    for (final notification in notifications.where(
      (item) => item.userId == account.id,
    )) {
      notification.read = true;
    }
    _persist();
  }

  void addNotification({
    required String userId,
    required String title,
    required String body,
  }) {
    notifications.insert(
      0,
      DemoNotification(
        id: _nextId('noti'),
        userId: userId,
        title: title,
        body: body,
        createdAt: DateTime.now(),
      ),
    );
  }

  void addActivity({
    required String actorId,
    required String title,
    required String detail,
  }) {
    activities.insert(
      0,
      DemoActivity(
        id: _nextId('act'),
        actorId: actorId,
        title: title,
        detail: detail,
        createdAt: DateTime.now(),
      ),
    );
    if (activities.length > 80) {
      activities = activities.take(80).toList();
    }
  }

  List<StaticMetric> dashboardMetrics(PortalRole role) {
    final account = currentAccount;
    switch (role) {
      case PortalRole.student:
        final assignmentsDue = visibleAssignments()
            .where((assignment) => !_hasSubmission(account?.id, assignment.id))
            .length;
        return [
          StaticMetric(
            label: 'Courses',
            value: '${visibleSectionsForRole(role).length}',
            note: 'Current semester',
            icon: Icons.menu_book_outlined,
          ),
          StaticMetric(
            label: 'Attendance',
            value: '${studentAttendancePercent(account?.id).round()}%',
            note: 'Calculated from classes',
            icon: Icons.how_to_reg_outlined,
          ),
          StaticMetric(
            label: 'Assignments',
            value: '$assignmentsDue',
            note: 'Pending submissions',
            icon: Icons.assignment_outlined,
          ),
          StaticMetric(
            label: 'Quizzes',
            value: '${visibleQuizzes().length}',
            note: 'Published quizzes',
            icon: Icons.quiz_outlined,
          ),
          StaticMetric(
            label: 'Tuition due',
            value: _money(totalDueForStudent(account?.id)),
            note: 'Invoice balance',
            icon: Icons.payments_outlined,
          ),
          StaticMetric(
            label: 'Unread',
            value: '${unreadNotifications(account?.id)}',
            note: 'Notifications',
            icon: Icons.notifications_outlined,
          ),
        ];
      case PortalRole.teacher:
        final teacherSectionIds = visibleSectionsForRole(
          role,
        ).map((item) => item.id).toSet();
        final pending = submissions.where((submission) {
          final assignment = assignments.firstWhereOrNull(
            (item) => item.id == submission.assignmentId,
          );
          return assignment != null &&
              teacherSectionIds.contains(assignment.sectionId) &&
              submission.status != 'graded' &&
              submission.status != 'reviewed';
        }).length;
        final students = enrollments
            .where(
              (enrollment) => teacherSectionIds.contains(enrollment.sectionId),
            )
            .map((enrollment) => enrollment.studentId)
            .toSet()
            .length;
        return [
          StaticMetric(
            label: 'Courses',
            value: '${teacherSectionIds.length}',
            note: 'Assigned sections',
            icon: Icons.class_outlined,
          ),
          StaticMetric(
            label: 'Students',
            value: '$students',
            note: 'Across sections',
            icon: Icons.groups_outlined,
          ),
          StaticMetric(
            label: 'Pending grading',
            value: '$pending',
            note: 'Submissions',
            icon: Icons.rate_review_outlined,
          ),
          StaticMetric(
            label: 'Assignments',
            value: '${visibleAssignments().length}',
            note: 'Published',
            icon: Icons.assignment_outlined,
          ),
          StaticMetric(
            label: 'Quizzes',
            value: '${visibleQuizzes().length}',
            note: 'Published',
            icon: Icons.quiz_outlined,
          ),
          StaticMetric(
            label: 'Today classes',
            value: '${todayScheduleCount()}',
            note: 'Routine entries',
            icon: Icons.today_outlined,
          ),
        ];
      case PortalRole.faculty:
        return [
          StaticMetric(
            label: 'Students',
            value: '${studentAccounts.length}',
            note: 'Active records',
            icon: Icons.groups_outlined,
          ),
          StaticMetric(
            label: 'Teachers',
            value: '${teacherAccounts.length}',
            note: 'Faculty roster',
            icon: Icons.co_present_outlined,
          ),
          StaticMetric(
            label: 'Departments',
            value: '${departments.length}',
            note: 'Academic units',
            icon: Icons.account_tree_outlined,
          ),
          StaticMetric(
            label: 'Conflicts',
            value: '${scheduleConflicts()}',
            note: 'Calculated routine overlaps',
            icon: Icons.warning_amber_outlined,
          ),
          StaticMetric(
            label: 'Tickets',
            value: '${openSupportTickets()}',
            note: 'Open support',
            icon: Icons.support_agent_outlined,
          ),
          StaticMetric(
            label: 'Approvals',
            value: '${pendingApprovals()}',
            note: 'Pending requests',
            icon: Icons.verified_outlined,
          ),
        ];
      case PortalRole.admin:
        return [
          StaticMetric(
            label: 'Students',
            value: '${studentAccounts.length}',
            note: 'Active records',
            icon: Icons.groups_outlined,
          ),
          StaticMetric(
            label: 'Teachers',
            value: '${teacherAccounts.length}',
            note: 'Active records',
            icon: Icons.co_present_outlined,
          ),
          StaticMetric(
            label: 'Departments',
            value: '${departments.length}',
            note: 'Active departments',
            icon: Icons.account_tree_outlined,
          ),
          StaticMetric(
            label: 'Support',
            value: '${openSupportTickets()}',
            note: 'Open tickets',
            icon: Icons.support_agent_outlined,
          ),
          StaticMetric(
            label: 'Approvals',
            value: '${pendingApprovals()}',
            note: 'Pending requests',
            icon: Icons.fact_check_outlined,
          ),
          StaticMetric(
            label: 'Forum reports',
            value: '${pendingForumReports()}',
            note: 'Pending moderation',
            icon: Icons.report_outlined,
          ),
          StaticMetric(
            label: 'Events',
            value: '${events.length}',
            note: 'Published records',
            icon: Icons.event_outlined,
          ),
          StaticMetric(
            label: 'Courses',
            value: '${courses.length}',
            note: 'Active catalog',
            icon: Icons.menu_book_outlined,
          ),
        ];
    }
  }

  StaticFeature hydrateFeature(StaticFeature base, PortalRole role) {
    final details = _moduleDetails(base.title, role);
    return StaticFeature(
      title: base.title,
      category: base.category,
      description: details.description ?? base.description,
      icon: base.icon,
      accent: base.accent,
      access: base.access,
      metrics: details.metrics,
      actions: details.actions,
      records: details.records,
    );
  }

  String performFeatureAction(String featureTitle, String action) {
    switch (action) {
      case 'Reset Demo Data':
        resetDemoData();
        return 'Local data has been reset to the original seed.';
      case 'Mark all notifications read':
        markAllNotificationsRead();
        return 'All notifications for this account are now read.';
      case 'Simulate demo payment':
        simulateDemoPayment();
        return 'Payment posted and invoice balance updated.';
      case 'Register next event':
        registerNextEvent();
        return 'Registered for the next available event.';
      case 'Join next club':
        joinFirstOpenClub();
        return 'Club membership updated.';
      case 'Create support ticket':
        return 'Open the support form to create a ticket.';
      case 'Reply to open ticket':
        replyFirstOpenSupportTicket();
        return 'Support reply sent to the requester.';
      case 'Create forum post':
        return 'Open the discussion form to create a post.';
      case 'Report latest post':
        reportLatestForumPost();
        return 'Forum report created for admin moderation.';
      case 'Resolve forum report':
        resolveFirstForumReport();
        return 'First pending forum report resolved.';
      case 'Hide reported content':
        resolveFirstForumReport(hideContent: true);
        return 'Reported content hidden and report resolved.';
      case 'Approve first request':
        approveFirstPendingRequest();
        return 'First pending approval has been approved.';
      case 'Mark today attendance':
        markTodayAttendanceForFirstTeacherSection();
        return 'Today attendance was marked for the first assigned section.';
      case 'Publish course notice':
        return 'Open the notice form to publish an announcement.';
      case 'Toggle first student status':
        toggleFirstUserActive();
        return 'First student account status changed.';
      default:
        return '$featureTitle is populated from local data.';
    }
  }

  double studentAttendancePercent(String? studentId) {
    final rows = attendance
        .where((record) => record.studentId == studentId)
        .toList();
    if (rows.isEmpty) {
      return 0;
    }
    final attended = rows.where((record) {
      return record.status == DemoAttendanceStatus.present ||
          record.status == DemoAttendanceStatus.late ||
          record.status == DemoAttendanceStatus.excused;
    }).length;
    return attended / rows.length * 100;
  }

  num totalDueForStudent(String? studentId) {
    return invoices
        .where((invoice) => invoice.studentId == studentId)
        .fold<num>(0, (total, invoice) => total + invoice.due);
  }

  int unreadNotifications(String? userId) {
    return notifications
        .where((item) => item.userId == userId && !item.read)
        .length;
  }

  int openSupportTickets() {
    return supportTickets.where((ticket) => ticket.status != 'closed').length;
  }

  int pendingApprovals() {
    return approvals.where((approval) => approval.status == 'pending').length;
  }

  int pendingForumReports() {
    return forumReports.where((report) => report.status == 'pending').length;
  }

  int todayScheduleCount() {
    final today = DateFormat('EEEE').format(DateTime.now());
    return schedulesForCurrentAccount()
        .where((schedule) => schedule.day == today)
        .length;
  }

  int scheduleConflicts() {
    final keys = <String, int>{};
    for (final schedule in schedules) {
      final key = '${schedule.day}-${schedule.start}-${schedule.room}';
      keys[key] = (keys[key] ?? 0) + 1;
    }
    return keys.values
        .where((count) => count > 1)
        .fold(0, (total, count) => total + count - 1);
  }

  bool _hasSubmission(String? studentId, String assignmentId) {
    return submissions.any((submission) {
      return submission.studentId == studentId &&
          submission.assignmentId == assignmentId;
    });
  }

  num _demoQuizScore(DemoQuiz quiz, int attemptIndex) {
    if (quiz.questions.isEmpty) {
      return (quiz.totalMarks * 0.75).round();
    }
    final missed = attemptIndex % 2 == 0 ? 1 : 0;
    final perQuestion = quiz.totalMarks / quiz.questions.length;
    return max<num>(0, quiz.totalMarks - perQuestion * missed).round();
  }

  _ModuleDetails _moduleDetails(String title, PortalRole role) {
    switch (title) {
      case 'Profile':
      case 'Student Portal':
        return _profileDetails();
      case 'Teacher Portal':
      case 'Dashboard':
        return _teacherDetails();
      case 'Faculty Portal':
      case 'Administration Panel':
      case 'Admin Faculty':
        return _adminFacultyDetails(role);
      case 'Semester Courses':
        return _courseDetails();
      case 'Class Routine':
      case 'Routine Management':
        return _routineDetails(role);
      case 'Attendance':
        return role == PortalRole.student
            ? _studentAttendanceDetails()
            : _teacherAttendanceDetails();
      case 'Assignments':
        return _assignmentDetails(role);
      case 'Quiz System':
        return _quizDetails(role);
      case 'Results':
      case 'Marks Result':
      case 'Academic Report':
        return _resultDetails(role);
      case 'Tuition Fees':
      case 'Payment History':
      case 'Payment View':
        return _paymentDetails(role);
      case 'Scholarships':
        return _scholarshipDetails();
      case 'Events':
      case 'Event Management':
        return _eventDetails(role);
      case 'Community Forum':
      case 'Discussion Board':
        return _forumDetails(role);
      case 'Student Support':
        return _supportDetails(role);
      case 'Teacher Management':
        return _teacherManagementDetails();
      case 'Student Management':
        return _studentManagementDetails();
      case 'Departments':
      case 'Department Management':
        return _departmentDetails();
      case 'Academic Calendar':
        return _calendarDetails();
      case 'Lecture Materials':
        return _lectureMaterialDetails();
      case 'Student Notices':
      case 'Notice Board':
        return _noticeDetails(role);
      case 'User Roles':
        return _userRoleDetails();
      case 'System Activity':
        return _activityDetails();
      case 'Settings':
      case 'Notifications':
        return _settingsDetails();
      case 'Lost and Found':
        return _lostFoundDetails();
      default:
        return _generalDetails(title);
    }
  }

  _ModuleDetails _profileDetails() {
    final account = currentAccount;
    final resultsRows = results
        .where((result) => result.studentId == account?.id)
        .toList();
    final cgpa = _cgpa(resultsRows);
    return _ModuleDetails(
      description:
          'Complete local profile with editable contact-oriented data.',
      metrics: [
        StaticMetric(
          label: 'CGPA',
          value: cgpa == 0 ? '-' : cgpa.toStringAsFixed(2),
          note: 'Calculated from results',
          icon: Icons.school_outlined,
        ),
        StaticMetric(
          label: 'Credits',
          value: '${account?.completedCredits ?? 0}',
          note: 'Completed',
          icon: Icons.credit_score_outlined,
        ),
        StaticMetric(
          label: 'Current',
          value: '${account?.currentCredits ?? 0}',
          note: 'Credits this term',
          icon: Icons.menu_book_outlined,
        ),
        StaticMetric(
          label: 'Attendance',
          value: '${studentAttendancePercent(account?.id).round()}%',
          note: 'All enrolled courses',
          icon: Icons.how_to_reg_outlined,
        ),
      ],
      records: [
        StaticRecord(
          title: account?.fullName ?? 'EUB User',
          subtitle: account?.email ?? '',
          meta: account?.universityId ?? '',
          status: account?.role.label ?? 'Student',
          icon: Icons.person_outline,
        ),
        StaticRecord(
          title: departmentName(account?.departmentId),
          subtitle:
              account?.program ?? account?.designation ?? 'University profile',
          meta:
              '${account?.semester ?? 'Spring 2026'} ${account?.section ?? ''}',
          status: account?.phone ?? 'Phone not set',
          icon: Icons.badge_outlined,
        ),
        StaticRecord(
          title: 'Emergency contact',
          subtitle: account?.emergencyContact ?? 'Not configured',
          meta: account?.address ?? 'Address can be edited locally',
          status: 'Local profile',
          icon: Icons.contact_phone_outlined,
        ),
      ],
    );
  }

  _ModuleDetails _teacherDetails() {
    final sectionRows = visibleSectionsForRole(PortalRole.teacher);
    return _ModuleDetails(
      description:
          'Teacher workspace calculated from assigned sections, submissions, quizzes, and attendance.',
      metrics: dashboardMetrics(PortalRole.teacher),
      records: sectionRows.map((section) {
        final subject = subjectForSection(section.id);
        final count = enrollments
            .where((enrollment) => enrollment.sectionId == section.id)
            .length;
        return StaticRecord(
          title: '${subject.code} ${subject.name}',
          subtitle: 'Section ${section.sectionCode} - ${section.semester}',
          meta: '$count enrolled students',
          status: subject.teacher,
          icon: Icons.class_outlined,
        );
      }).toList(),
      actions: const ['Mark today attendance', 'Publish course notice'],
    );
  }

  _ModuleDetails _adminFacultyDetails(PortalRole role) {
    return _ModuleDetails(
      description: role == PortalRole.admin
          ? 'Admin overview with live counts for users, approvals, moderation, support, and activities.'
          : 'Faculty overview using the same students, teachers, routines, reports, and support tickets.',
      metrics: dashboardMetrics(role),
      records: [
        StaticRecord(
          title: 'Pending approvals',
          subtitle: '${pendingApprovals()} requests need decision',
          meta: 'Events, roles, scholarships, content',
          status: 'Action needed',
          icon: Icons.fact_check_outlined,
        ),
        StaticRecord(
          title: 'Forum moderation',
          subtitle: '${pendingForumReports()} pending reports',
          meta:
              '${forumPosts.where((post) => !post.hidden).length} visible posts',
          status: 'Live',
          icon: Icons.report_outlined,
        ),
        StaticRecord(
          title: 'Open support',
          subtitle: '${openSupportTickets()} tickets across student services',
          meta: 'Finance, academic, IT, transport',
          status: 'Live',
          icon: Icons.support_agent_outlined,
        ),
      ],
      actions: role == PortalRole.admin
          ? const [
              'Approve first request',
              'Resolve forum report',
              'Toggle first student status',
            ]
          : const ['Reply to open ticket', 'Resolve forum report'],
    );
  }

  _ModuleDetails _courseDetails() {
    final sectionRows = visibleSectionsForRole();
    return _ModuleDetails(
      description:
          'Courses are resolved from enrollments and teacher assignments.',
      metrics: [
        StaticMetric(
          label: 'Courses',
          value: '${sectionRows.length}',
          note: 'Visible to this account',
          icon: Icons.menu_book_outlined,
        ),
        StaticMetric(
          label: 'Credits',
          value:
              '${sectionRows.fold<int>(0, (total, section) => total + (courseById(section.courseId)?.credits ?? 0))}',
          note: 'Current load',
          icon: Icons.credit_score_outlined,
        ),
      ],
      records: sectionRows.map((section) {
        final subject = subjectForSection(section.id);
        final schedule = schedules.firstWhereOrNull(
          (item) => item.sectionId == section.id,
        );
        return StaticRecord(
          title: '${subject.code} ${subject.name}',
          subtitle: subject.teacher,
          meta: schedule == null
              ? 'Routine pending'
              : '${schedule.day} ${schedule.start} - ${schedule.room}',
          status: 'Section ${section.sectionCode}',
          icon: Icons.menu_book_outlined,
        );
      }).toList(),
    );
  }

  _ModuleDetails _routineDetails(PortalRole role) {
    final rows = role == PortalRole.admin || role == PortalRole.faculty
        ? schedules
        : schedulesForCurrentAccount();
    return _ModuleDetails(
      description:
          'Weekly routine entries with real course, teacher, room, and conflict data.',
      metrics: [
        StaticMetric(
          label: 'Routine entries',
          value: '${rows.length}',
          note: 'Visible schedule',
          icon: Icons.calendar_month_outlined,
        ),
        StaticMetric(
          label: 'Conflicts',
          value: '${scheduleConflicts()}',
          note: 'Room/time overlaps',
          icon: Icons.warning_amber_outlined,
        ),
      ],
      records: rows.map((schedule) {
        final subject = subjectForSection(schedule.sectionId);
        return StaticRecord(
          title: '${schedule.day} ${schedule.start}-${schedule.end}',
          subtitle: '${subject.code} ${subject.name}',
          meta: '${subject.teacher} - ${schedule.room}',
          status: schedule.type,
          icon: Icons.schedule_outlined,
        );
      }).toList(),
    );
  }

  _ModuleDetails _studentAttendanceDetails() {
    final account = currentAccount;
    final sectionRows = visibleSectionsForRole();
    return _ModuleDetails(
      description:
          'Attendance is calculated from per-class history and shows missed days.',
      metrics: [
        StaticMetric(
          label: 'Overall',
          value: '${studentAttendancePercent(account?.id).round()}%',
          note: 'Attended/total classes',
          icon: Icons.query_stats_outlined,
        ),
        StaticMetric(
          label: 'Missed',
          value:
              '${attendance.where((record) => record.studentId == account?.id && record.status == DemoAttendanceStatus.absent).length}',
          note: 'Absent classes',
          icon: Icons.cancel_outlined,
        ),
      ],
      records: sectionRows.map((section) {
        final rows = attendance
            .where(
              (record) =>
                  record.studentId == account?.id &&
                  record.sectionId == section.id,
            )
            .toList();
        final attended = rows
            .where((record) => record.status != DemoAttendanceStatus.absent)
            .length;
        final percent = rows.isEmpty ? 0 : attended / rows.length * 100;
        final subject = subjectForSection(section.id);
        return StaticRecord(
          title: '${subject.code} ${subject.name}',
          subtitle: '${rows.length} recorded classes',
          meta: '${percent.round()}% attendance',
          status:
              '${rows.where((item) => item.status == DemoAttendanceStatus.absent).length} missed',
          icon: Icons.how_to_reg_outlined,
        );
      }).toList(),
    );
  }

  _ModuleDetails _teacherAttendanceDetails() {
    return _ModuleDetails(
      description:
          'Teacher attendance actions update the same records students see.',
      metrics: [
        StaticMetric(
          label: 'Sections',
          value: '${visibleSectionsForRole().length}',
          note: 'Assigned for marking',
          icon: Icons.class_outlined,
        ),
        StaticMetric(
          label: 'Records',
          value: '${attendance.length}',
          note: 'Attendance rows',
          icon: Icons.how_to_reg_outlined,
        ),
      ],
      records: visibleSectionsForRole().map((section) {
        final subject = subjectForSection(section.id);
        final count = enrollments
            .where((item) => item.sectionId == section.id)
            .length;
        return StaticRecord(
          title: '${subject.code} ${subject.name}',
          subtitle: 'Section ${section.sectionCode}',
          meta: '$count students in roster',
          status: 'Ready',
          icon: Icons.fact_check_outlined,
        );
      }).toList(),
      actions: const ['Mark today attendance'],
    );
  }

  _ModuleDetails _assignmentDetails(PortalRole role) {
    final rows = visibleAssignments();
    final pending = rows
        .where(
          (assignment) => !_hasSubmission(currentAccount?.id, assignment.id),
        )
        .length;
    return _ModuleDetails(
      description:
          'Assignments, submissions, grading, and notifications are synchronized locally.',
      metrics: [
        StaticMetric(
          label: 'Assignments',
          value: '${rows.length}',
          note: 'Visible records',
          icon: Icons.assignment_outlined,
        ),
        StaticMetric(
          label: 'Submissions',
          value: '${visibleSubmissions().length}',
          note: 'Current scope',
          icon: Icons.upload_file_outlined,
        ),
        StaticMetric(
          label: 'Pending',
          value: '$pending',
          note: role == PortalRole.student ? 'Need submission' : 'Need grading',
          icon: Icons.pending_actions_outlined,
        ),
      ],
      records: rows.map((assignment) {
        final subject = subjectForSection(assignment.sectionId);
        final count = submissions
            .where((item) => item.assignmentId == assignment.id)
            .length;
        return StaticRecord(
          title: assignment.title,
          subtitle: '${subject.code} - ${assignment.instructions}',
          meta: 'Due ${_date(assignment.dueAt)}',
          status: role == PortalRole.student
              ? (_hasSubmission(currentAccount?.id, assignment.id)
                    ? 'Submitted'
                    : 'Open')
              : '$count submissions',
          icon: Icons.assignment_outlined,
        );
      }).toList(),
    );
  }

  _ModuleDetails _quizDetails(PortalRole role) {
    final rows = visibleQuizzes();
    return _ModuleDetails(
      description:
          'Published quizzes include meaningful questions and local attempt history.',
      metrics: [
        StaticMetric(
          label: 'Quizzes',
          value: '${rows.length}',
          note: 'Visible records',
          icon: Icons.quiz_outlined,
        ),
        StaticMetric(
          label: 'Attempts',
          value: '${visibleQuizAttempts().length}',
          note: 'Submitted locally',
          icon: Icons.check_circle_outline,
        ),
      ],
      records: rows.map((quiz) {
        final subject = subjectForSection(quiz.sectionId);
        final attemptCount = quizAttempts
            .where((item) => item.quizId == quiz.id)
            .length;
        return StaticRecord(
          title: quiz.title,
          subtitle: '${subject.code} - ${quiz.questions.length} questions',
          meta: '${quiz.durationMinutes} min, ${quiz.totalMarks} marks',
          status: role == PortalRole.student
              ? '${attemptCountForCurrentStudent(quiz.id)} attempts'
              : '$attemptCount attempts',
          icon: Icons.quiz_outlined,
        );
      }).toList(),
    );
  }

  int attemptCountForCurrentStudent(String quizId) {
    return quizAttempts
        .where(
          (item) =>
              item.quizId == quizId && item.studentId == currentAccount?.id,
        )
        .length;
  }

  _ModuleDetails _resultDetails(PortalRole role) {
    final account = currentAccount;
    final rows = role == PortalRole.student
        ? results.where((result) => result.studentId == account?.id).toList()
        : results;
    return _ModuleDetails(
      description:
          'GPA and CGPA are calculated from course results and credits.',
      metrics: [
        StaticMetric(
          label: 'Results',
          value: '${rows.length}',
          note: 'Course records',
          icon: Icons.analytics_outlined,
        ),
        StaticMetric(
          label: 'CGPA',
          value: _cgpa(rows).toStringAsFixed(2),
          note: 'Weighted by credits',
          icon: Icons.school_outlined,
        ),
      ],
      records: rows.take(20).map((result) {
        final course = courseById(result.courseId);
        final student = accountById(result.studentId);
        return StaticRecord(
          title: '${course?.code ?? ''} ${course?.title ?? 'Course'}',
          subtitle: role == PortalRole.student
              ? result.semester
              : '${student?.fullName ?? 'Student'} - ${result.semester}',
          meta: '${result.marks} marks',
          status: '${result.letterGrade} (${result.gradePoint})',
          icon: Icons.grade_outlined,
        );
      }).toList(),
    );
  }

  _ModuleDetails _paymentDetails(PortalRole role) {
    final account = currentAccount;
    final invoiceRows = role == PortalRole.student
        ? invoices.where((invoice) => invoice.studentId == account?.id).toList()
        : invoices;
    return _ModuleDetails(
      description:
          'Invoices calculate subtotal, waiver, payment, and remaining due without a real gateway.',
      metrics: [
        StaticMetric(
          label: 'Invoices',
          value: '${invoiceRows.length}',
          note: 'Visible invoices',
          icon: Icons.receipt_long_outlined,
        ),
        StaticMetric(
          label: 'Due',
          value: _money(
            invoiceRows.fold<num>(0, (total, invoice) => total + invoice.due),
          ),
          note: 'Remaining balance',
          icon: Icons.payments_outlined,
        ),
        StaticMetric(
          label: 'Payments',
          value:
              '${payments.where((payment) => role != PortalRole.student || payment.studentId == account?.id).length}',
          note: 'Receipts',
          icon: Icons.account_balance_wallet_outlined,
        ),
      ],
      records: invoiceRows.map((invoice) {
        final student = accountById(invoice.studentId);
        return StaticRecord(
          title: '${student?.fullName ?? 'Student'} - ${invoice.semester}',
          subtitle:
              'Subtotal ${_money(invoice.subtotal)}, waiver ${_money(invoice.waiver)}, paid ${_money(invoice.paid)}',
          meta: 'Due ${_date(invoice.dueDate)}',
          status: _money(invoice.due),
          icon: Icons.receipt_long_outlined,
        );
      }).toList(),
      actions: role == PortalRole.student
          ? const ['Simulate demo payment']
          : const [],
    );
  }

  _ModuleDetails _scholarshipDetails() {
    return _ModuleDetails(
      description:
          'Scholarship opportunities use realistic eligibility and deadlines.',
      metrics: [
        StaticMetric(
          label: 'Open scholarships',
          value:
              '${scholarships.where((item) => item.status == 'open').length}',
          note: 'Applications available',
          icon: Icons.workspace_premium_outlined,
        ),
      ],
      records: scholarships.map((scholarship) {
        return StaticRecord(
          title: scholarship.title,
          subtitle: scholarship.description,
          meta: 'Deadline ${_date(scholarship.deadline)}',
          status: scholarship.status,
          icon: Icons.workspace_premium_outlined,
        );
      }).toList(),
      actions: const ['Approve first request'],
    );
  }

  _ModuleDetails _eventDetails(PortalRole role) {
    return _ModuleDetails(
      description: 'Events include real registrations and capacity counts.',
      metrics: [
        StaticMetric(
          label: 'Events',
          value: '${events.length}',
          note: 'Published records',
          icon: Icons.event_outlined,
        ),
        StaticMetric(
          label: 'Registrations',
          value:
              '${eventRegistrations.where((item) => item.status == 'registered').length}',
          note: 'Calculated attendees',
          icon: Icons.how_to_reg_outlined,
        ),
      ],
      records: events.map((event) {
        final count = eventRegistrations
            .where(
              (item) => item.eventId == event.id && item.status == 'registered',
            )
            .length;
        return StaticRecord(
          title: event.title,
          subtitle: event.description,
          meta: '${_date(event.date)} - ${event.venue}',
          status: '$count/${event.capacity}',
          icon: Icons.event_outlined,
        );
      }).toList(),
      actions: role == PortalRole.student
          ? const ['Register next event']
          : const ['Approve first request'],
    );
  }

  _ModuleDetails _forumDetails(PortalRole role) {
    final visiblePosts = forumPosts.where((post) => !post.hidden).toList();
    final visibleComments = forumComments
        .where((comment) => !comment.hidden)
        .toList();
    return _ModuleDetails(
      description:
          'Discussion data uses real categories, posts, comments, reactions, and moderation reports.',
      metrics: [
        StaticMetric(
          label: 'Posts',
          value: '${visiblePosts.length}',
          note: 'Visible discussions',
          icon: Icons.forum_outlined,
        ),
        StaticMetric(
          label: 'Comments',
          value: '${visibleComments.length}',
          note: 'Visible replies',
          icon: Icons.mode_comment_outlined,
        ),
        StaticMetric(
          label: 'Reports',
          value: '${pendingForumReports()}',
          note: 'Pending moderation',
          icon: Icons.report_outlined,
        ),
      ],
      records: visiblePosts.take(12).map((post) {
        final author = accountById(post.authorId);
        final category = forumCategories.firstWhereOrNull(
          (item) => item.id == post.categoryId,
        );
        final count = visibleComments
            .where((comment) => comment.postId == post.id)
            .length;
        return StaticRecord(
          title: post.title,
          subtitle: post.body,
          meta:
              '${author?.fullName ?? 'Student'} - ${category?.name ?? 'Forum'}',
          status: '$count comments, ${post.reactions} reactions',
          icon: Icons.forum_outlined,
        );
      }).toList(),
      actions: role == PortalRole.admin || role == PortalRole.faculty
          ? const ['Resolve forum report', 'Hide reported content']
          : const ['Create forum post', 'Report latest post'],
    );
  }

  _ModuleDetails _supportDetails(PortalRole role) {
    final account = currentAccount;
    final rows = role == PortalRole.student
        ? supportTickets
              .where((ticket) => ticket.requesterId == account?.id)
              .toList()
        : supportTickets;
    return _ModuleDetails(
      description:
          'Support tickets contain conversation messages and synchronize between student and staff views.',
      metrics: [
        StaticMetric(
          label: 'Tickets',
          value: '${rows.length}',
          note: 'Visible tickets',
          icon: Icons.support_agent_outlined,
        ),
        StaticMetric(
          label: 'Open',
          value: '${rows.where((ticket) => ticket.status != 'closed').length}',
          note: 'Need attention',
          icon: Icons.mark_chat_unread_outlined,
        ),
      ],
      records: rows.map((ticket) {
        final count = supportMessages
            .where((message) => message.ticketId == ticket.id)
            .length;
        final requester = accountById(ticket.requesterId);
        return StaticRecord(
          title: ticket.subject,
          subtitle: '${ticket.category} - ${requester?.fullName ?? 'Student'}',
          meta: '$count messages, ${ticket.priority} priority',
          status: ticket.status,
          icon: Icons.support_agent_outlined,
        );
      }).toList(),
      actions: role == PortalRole.student
          ? const ['Create support ticket']
          : const ['Reply to open ticket'],
    );
  }

  _ModuleDetails _teacherManagementDetails() {
    return _ModuleDetails(
      description:
          'Teacher roster includes department, designation, workload, and assigned courses.',
      metrics: [
        StaticMetric(
          label: 'Teachers',
          value: '${teacherAccounts.length}',
          note: 'Active roster',
          icon: Icons.co_present_outlined,
        ),
      ],
      records: teacherAccounts.map((teacher) {
        final assigned = sections
            .where((section) => section.teacherId == teacher.id)
            .length;
        return StaticRecord(
          title: teacher.fullName,
          subtitle: departmentName(teacher.departmentId),
          meta: teacher.designation ?? 'Teacher',
          status: '$assigned sections',
          icon: Icons.co_present_outlined,
        );
      }).toList(),
    );
  }

  _ModuleDetails _studentManagementDetails() {
    return _ModuleDetails(
      description:
          'Student management is populated with realistic student IDs, departments, semester, status, results, and attendance.',
      metrics: [
        StaticMetric(
          label: 'Students',
          value: '${studentAccounts.length}',
          note: 'Student roster',
          icon: Icons.groups_outlined,
        ),
      ],
      records: studentAccounts.map((student) {
        return StaticRecord(
          title: student.fullName,
          subtitle:
              '${student.universityId} - ${departmentName(student.departmentId)}',
          meta: '${student.semester ?? ''} ${student.section ?? ''}',
          status: student.active
              ? '${studentAttendancePercent(student.id).round()}%'
              : 'Inactive',
          icon: Icons.person_outline,
        );
      }).toList(),
      actions: currentRole == PortalRole.admin
          ? const ['Toggle first student status']
          : const [],
    );
  }

  _ModuleDetails _departmentDetails() {
    return _ModuleDetails(
      description:
          'Department statistics are calculated from students, teachers, and courses.',
      metrics: [
        StaticMetric(
          label: 'Departments',
          value: '${departments.length}',
          note: 'Academic units',
          icon: Icons.account_tree_outlined,
        ),
        StaticMetric(
          label: 'Courses',
          value: '${courses.length}',
          note: 'Course catalog',
          icon: Icons.menu_book_outlined,
        ),
      ],
      records: departments.map((department) {
        final studentCount = accounts
            .where(
              (account) =>
                  account.role == PortalRole.student &&
                  account.departmentId == department.id,
            )
            .length;
        final teacherCount = accounts
            .where(
              (account) =>
                  account.role == PortalRole.teacher &&
                  account.departmentId == department.id,
            )
            .length;
        final courseCount = courses
            .where((course) => course.departmentId == department.id)
            .length;
        return StaticRecord(
          title: department.name,
          subtitle: department.faculty,
          meta: '$studentCount students, $teacherCount teachers',
          status: '$courseCount courses',
          icon: Icons.account_tree_outlined,
        );
      }).toList(),
    );
  }

  _ModuleDetails _calendarDetails() {
    final rows = [
      StaticRecord(
        title: 'Registration opens',
        subtitle: 'Spring 2026 advising and online registration',
        meta: 'Jan 05, 2026',
        status: 'Done',
        icon: Icons.event_available_outlined,
      ),
      StaticRecord(
        title: 'Class start',
        subtitle: 'Regular classes begin for all departments',
        meta: 'Jan 18, 2026',
        status: 'Done',
        icon: Icons.school_outlined,
      ),
      StaticRecord(
        title: 'Midterm exam window',
        subtitle: 'Department-wise routine published in notice board',
        meta: 'Mar 10-21, 2026',
        status: 'Done',
        icon: Icons.assignment_outlined,
      ),
      StaticRecord(
        title: 'Independence Day holiday',
        subtitle: 'University closed for national holiday',
        meta: 'Mar 26, 2026',
        status: 'Holiday',
        icon: Icons.flag_outlined,
      ),
      StaticRecord(
        title: 'Final exam form fill-up',
        subtitle: 'Students complete financial clearance and exam forms',
        meta: 'Apr 22-30, 2026',
        status: 'Upcoming',
        icon: Icons.fact_check_outlined,
      ),
      StaticRecord(
        title: 'Result publication',
        subtitle: 'Final grades released through the portal',
        meta: 'Jun 10, 2026',
        status: 'Upcoming',
        icon: Icons.grade_outlined,
      ),
    ];
    return _ModuleDetails(
      description:
          'Academic calendar contains semester events, holidays, exams, and publication dates.',
      metrics: [
        StaticMetric(
          label: 'Calendar items',
          value: '${rows.length}',
          note: 'Spring 2026',
          icon: Icons.calendar_month_outlined,
        ),
      ],
      records: rows,
    );
  }

  _ModuleDetails _lectureMaterialDetails() {
    final rows = [
      StaticRecord(
        title: 'DBMS Week 4 - Normalization.pdf',
        subtitle: 'CSE 315 Database Management Systems',
        meta: 'Dr. Farhan Rahman',
        status: 'PDF',
        icon: Icons.picture_as_pdf_outlined,
      ),
      StaticRecord(
        title: 'SQL Practice Sheet.pdf',
        subtitle: 'CSE 315 lab worksheet',
        meta: 'Dr. Farhan Rahman',
        status: 'PDF',
        icon: Icons.picture_as_pdf_outlined,
      ),
      StaticRecord(
        title: 'ER Diagram Lecture Slides.pdf',
        subtitle: 'CSE 315 data modeling slides',
        meta: 'Dr. Farhan Rahman',
        status: 'Slides',
        icon: Icons.slideshow_outlined,
      ),
      StaticRecord(
        title: 'Software Requirements Checklist.docx',
        subtitle: 'CSE 331 project checklist',
        meta: 'Dr. Farhan Rahman',
        status: 'DOCX',
        icon: Icons.description_outlined,
      ),
      StaticRecord(
        title: 'Operating System Scheduling Table.xlsx',
        subtitle: 'CSE 341 process scheduling exercise',
        meta: 'Mahmudul Karim',
        status: 'Sheet',
        icon: Icons.table_chart_outlined,
      ),
    ];
    return _ModuleDetails(
      description:
          'Lecture materials use meaningful metadata and are ready for upload/download simulations.',
      metrics: [
        StaticMetric(
          label: 'Materials',
          value: '${rows.length}',
          note: 'Visible files',
          icon: Icons.folder_copy_outlined,
        ),
      ],
      records: rows,
    );
  }

  _ModuleDetails _noticeDetails(PortalRole role) {
    return _ModuleDetails(
      description:
          'Notice records are targeted by role or section and can generate notifications.',
      metrics: [
        StaticMetric(
          label: 'Notices',
          value: '${notices.length}',
          note: 'Published records',
          icon: Icons.campaign_outlined,
        ),
      ],
      records: notices.take(20).map((notice) {
        final author = accountById(notice.authorId);
        final subject = notice.sectionId == null
            ? null
            : subjectForSection(notice.sectionId!);
        return StaticRecord(
          title: notice.title,
          subtitle: notice.body,
          meta:
              '${author?.fullName ?? 'Office'} - ${subject?.code ?? notice.target}',
          status: _date(notice.publishedAt),
          icon: Icons.campaign_outlined,
        );
      }).toList(),
      actions: role == PortalRole.teacher
          ? const ['Publish course notice']
          : const [],
    );
  }

  _ModuleDetails _userRoleDetails() {
    return _ModuleDetails(
      description:
          'User roles can be reviewed and account activation changes update local state.',
      metrics: [
        StaticMetric(
          label: 'Users',
          value: '${accounts.length}',
          note: 'All users',
          icon: Icons.manage_accounts_outlined,
        ),
        StaticMetric(
          label: 'Inactive',
          value: '${accounts.where((account) => !account.active).length}',
          note: 'Local state',
          icon: Icons.block_outlined,
        ),
      ],
      records: accounts.map((account) {
        return StaticRecord(
          title: account.fullName,
          subtitle: '${account.universityId} - ${account.email}',
          meta: departmentName(account.departmentId),
          status: account.active
              ? account.role.label
              : 'Inactive ${account.role.label}',
          icon: account.role.icon,
        );
      }).toList(),
      actions: const ['Toggle first student status'],
    );
  }

  _ModuleDetails _activityDetails() {
    return _ModuleDetails(
      description:
          'System activity contains seeded actions and grows when local workflows run.',
      metrics: [
        StaticMetric(
          label: 'Activity entries',
          value: '${activities.length}',
          note: 'Actual local records',
          icon: Icons.history_outlined,
        ),
      ],
      records: activities.take(50).map((activity) {
        final actor = accountById(activity.actorId);
        return StaticRecord(
          title: activity.title,
          subtitle: activity.detail,
          meta: actor?.fullName ?? 'System',
          status: _dateTime(activity.createdAt),
          icon: Icons.history_outlined,
        );
      }).toList(),
    );
  }

  _ModuleDetails _settingsDetails() {
    final account = currentAccount;
    return _ModuleDetails(
      description:
          'Settings includes credentials, notification state, and reset tools.',
      metrics: [
        StaticMetric(
          label: 'Unread',
          value: '${unreadNotifications(account?.id)}',
          note: 'This account',
          icon: Icons.notifications_outlined,
        ),
        StaticMetric(
          label: 'Demo accounts',
          value: '${demoLoginAccounts.length}',
          note: 'Quick login roles',
          icon: Icons.key_outlined,
        ),
      ],
      records: [
        ...demoLoginAccounts.map((demo) {
          return StaticRecord(
            title: '${demo.role.label}: ${demo.fullName}',
            subtitle: '${demo.universityId} or ${demo.email}',
            meta: 'Password 123456',
            status: demo.active ? 'Active' : 'Inactive',
            icon: demo.role.icon,
          );
        }),
        ...notifications
            .where((item) => item.userId == account?.id)
            .take(8)
            .map((notification) {
              return StaticRecord(
                title: notification.title,
                subtitle: notification.body,
                meta: _dateTime(notification.createdAt),
                status: notification.read ? 'Read' : 'Unread',
                icon: Icons.notifications_outlined,
              );
            }),
      ],
      actions: const ['Mark all notifications read', 'Reset Demo Data'],
    );
  }

  _ModuleDetails _lostFoundDetails() {
    final rows = [
      StaticRecord(
        title: 'Student ID card found near CSE Lab 2',
        subtitle:
            'Belongs to a Spring 2026 CSE student. Collected by department office.',
        meta: 'Jul 24, 2026',
        status: 'Found',
        icon: Icons.badge_outlined,
      ),
      StaticRecord(
        title: 'Black calculator lost after EEE lab',
        subtitle: 'Casio scientific calculator with name sticker on back.',
        meta: 'Jul 23, 2026',
        status: 'Lost',
        icon: Icons.calculate_outlined,
      ),
      StaticRecord(
        title: 'Blue notebook found in library',
        subtitle: 'Contains DBMS normalization notes and assignment checklist.',
        meta: 'Jul 22, 2026',
        status: 'Found',
        icon: Icons.menu_book_outlined,
      ),
    ];
    return _ModuleDetails(
      description:
          'Lost and found records are populated with realistic campus items.',
      metrics: [
        StaticMetric(
          label: 'Records',
          value: '${rows.length}',
          note: 'Campus items',
          icon: Icons.search_outlined,
        ),
      ],
      records: rows,
    );
  }

  _ModuleDetails _generalDetails(String title) {
    return _ModuleDetails(
      description: '$title uses the shared local university dataset.',
      metrics: dashboardMetrics(currentRole).take(4).toList(),
      records: [
        StaticRecord(
          title: 'Local data connected',
          subtitle:
              'This screen reads calculated records from the local store.',
          meta: 'Presentation mode',
          status: 'Ready',
          icon: Icons.dataset_outlined,
        ),
      ],
    );
  }

  double _cgpa(List<DemoResult> rows) {
    num points = 0;
    num credits = 0;
    for (final result in rows) {
      final credit = courseById(result.courseId)?.credits ?? 3;
      points += result.gradePoint * credit;
      credits += credit;
    }
    if (credits == 0) {
      return 0;
    }
    return points / credits;
  }

  String _money(num value) {
    return 'BDT ${NumberFormat.decimalPattern().format(value.round())}';
  }

  String _date(DateTime value) {
    return DateFormat('MMM dd, yyyy').format(value);
  }

  String _dateTime(DateTime value) {
    return DateFormat('MMM dd, h:mm a').format(value);
  }

  String _nextId(String prefix) {
    final millis = DateTime.now().microsecondsSinceEpoch;
    final nonce = Random().nextInt(9999).toString().padLeft(4, '0');
    return '$prefix-$millis-$nonce';
  }

  void _load() {
    final saved = _storage.read(_stateKey);
    if (saved is Map) {
      _loadFromSnapshot(Map<String, dynamic>.from(saved));
      return;
    }
    _loadFromSnapshot(DemoSeed.snapshot());
    _persist();
  }

  void _loadFromSnapshot(JsonMap snapshot) {
    currentAccountId = snapshot['currentAccountId'] as String?;
    accounts = _list(snapshot, 'accounts', DemoAccount.fromJson);
    departments = _list(snapshot, 'departments', DemoDepartment.fromJson);
    courses = _list(snapshot, 'courses', DemoCourse.fromJson);
    sections = _list(snapshot, 'sections', DemoSection.fromJson);
    enrollments = _list(snapshot, 'enrollments', DemoEnrollment.fromJson);
    schedules = _list(snapshot, 'schedules', DemoScheduleEntry.fromJson);
    attendance = _list(snapshot, 'attendance', DemoAttendanceRecord.fromJson);
    assignments = _list(snapshot, 'assignments', DemoAssignment.fromJson);
    submissions = _list(snapshot, 'submissions', DemoSubmission.fromJson);
    quizzes = _list(snapshot, 'quizzes', DemoQuiz.fromJson);
    quizAttempts = _list(snapshot, 'quizAttempts', DemoQuizAttempt.fromJson);
    notices = _list(snapshot, 'notices', DemoNotice.fromJson);
    events = _list(snapshot, 'events', DemoEvent.fromJson);
    eventRegistrations = _list(
      snapshot,
      'eventRegistrations',
      DemoEventRegistration.fromJson,
    );
    clubs = _list(snapshot, 'clubs', DemoClub.fromJson);
    clubMemberships = _list(
      snapshot,
      'clubMemberships',
      DemoClubMembership.fromJson,
    );
    forumCategories = _list(
      snapshot,
      'forumCategories',
      DemoForumCategory.fromJson,
    );
    forumPosts = _list(snapshot, 'forumPosts', DemoForumPost.fromJson);
    forumComments = _list(snapshot, 'forumComments', DemoForumComment.fromJson);
    forumReports = _list(snapshot, 'forumReports', DemoForumReport.fromJson);
    supportTickets = _list(
      snapshot,
      'supportTickets',
      DemoSupportTicket.fromJson,
    );
    supportMessages = _list(
      snapshot,
      'supportMessages',
      DemoSupportMessage.fromJson,
    );
    invoices = _list(snapshot, 'invoices', DemoInvoice.fromJson);
    payments = _list(snapshot, 'payments', DemoPayment.fromJson);
    results = _list(snapshot, 'results', DemoResult.fromJson);
    scholarships = _list(snapshot, 'scholarships', DemoScholarship.fromJson);
    notifications = _list(snapshot, 'notifications', DemoNotification.fromJson);
    approvals = _list(snapshot, 'approvals', DemoApproval.fromJson);
    activities = _list(snapshot, 'activities', DemoActivity.fromJson);
    revision.value++;
  }

  List<T> _list<T>(
    JsonMap snapshot,
    String key,
    T Function(JsonMap json) fromJson,
  ) {
    final raw = snapshot[key];
    if (raw is! List) {
      return [];
    }
    return raw.whereType<Map>().map((item) {
      return fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }

  JsonMap _snapshot() {
    return {
      'currentAccountId': currentAccountId,
      'accounts': accounts.map((item) => item.toJson()).toList(),
      'departments': departments.map((item) => item.toJson()).toList(),
      'courses': courses.map((item) => item.toJson()).toList(),
      'sections': sections.map((item) => item.toJson()).toList(),
      'enrollments': enrollments.map((item) => item.toJson()).toList(),
      'schedules': schedules.map((item) => item.toJson()).toList(),
      'attendance': attendance.map((item) => item.toJson()).toList(),
      'assignments': assignments.map((item) => item.toJson()).toList(),
      'submissions': submissions.map((item) => item.toJson()).toList(),
      'quizzes': quizzes.map((item) => item.toJson()).toList(),
      'quizAttempts': quizAttempts.map((item) => item.toJson()).toList(),
      'notices': notices.map((item) => item.toJson()).toList(),
      'events': events.map((item) => item.toJson()).toList(),
      'eventRegistrations': eventRegistrations
          .map((item) => item.toJson())
          .toList(),
      'clubs': clubs.map((item) => item.toJson()).toList(),
      'clubMemberships': clubMemberships.map((item) => item.toJson()).toList(),
      'forumCategories': forumCategories.map((item) => item.toJson()).toList(),
      'forumPosts': forumPosts.map((item) => item.toJson()).toList(),
      'forumComments': forumComments.map((item) => item.toJson()).toList(),
      'forumReports': forumReports.map((item) => item.toJson()).toList(),
      'supportTickets': supportTickets.map((item) => item.toJson()).toList(),
      'supportMessages': supportMessages.map((item) => item.toJson()).toList(),
      'invoices': invoices.map((item) => item.toJson()).toList(),
      'payments': payments.map((item) => item.toJson()).toList(),
      'results': results.map((item) => item.toJson()).toList(),
      'scholarships': scholarships.map((item) => item.toJson()).toList(),
      'notifications': notifications.map((item) => item.toJson()).toList(),
      'approvals': approvals.map((item) => item.toJson()).toList(),
      'activities': activities.map((item) => item.toJson()).toList(),
    };
  }

  void _persist() {
    _storage.write(_stateKey, _snapshot());
    revision.value++;
  }
}

class _ModuleDetails {
  const _ModuleDetails({
    required this.metrics,
    required this.records,
    this.description,
    this.actions = const [],
  });

  final String? description;
  final List<StaticMetric> metrics;
  final List<StaticRecord> records;
  final List<String> actions;
}

extension _IterableLookup<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return null;
    }
    return iterator.current;
  }
}
