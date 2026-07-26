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
  static const _stateKey = 'presentation_state_v4';
  static DemoStore? _instance;

  final GetStorage _storage;
  final revision = 0.obs;

  String? currentAccountId;
  List<DemoAccount> accounts = [];
  List<DemoOffice> offices = [];
  List<DemoDepartment> departments = [];
  List<DemoProgram> programs = [];
  List<DemoCourse> courses = [];
  List<DemoSection> sections = [];
  List<DemoAcademicSemester> academicSemesters = [];
  List<DemoCalendarEvent> calendarEvents = [];
  List<DemoEnrollment> enrollments = [];
  List<DemoScheduleEntry> schedules = [];
  List<DemoAttendanceRecord> attendance = [];
  List<DemoAssignment> assignments = [];
  List<DemoSubmission> submissions = [];
  List<DemoQuiz> quizzes = [];
  List<DemoQuizAttempt> quizAttempts = [];
  List<DemoExamSchedule> examSchedules = [];
  List<DemoStudentRequest> studentRequests = [];
  List<DemoAdmissionApplication> admissions = [];
  List<DemoNotice> notices = [];
  List<DemoEvent> events = [];
  List<DemoEventRegistration> eventRegistrations = [];
  List<DemoClub> clubs = [];
  List<DemoClubMembership> clubMemberships = [];
  List<DemoLostFoundItem> lostFoundItems = [];
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

  List<DemoAccount> get administrationAccounts {
    return accounts
        .where((account) => account.role == PortalRole.administration)
        .toList();
  }

  List<DemoAccount> get demoLoginAccounts {
    const ids = ['u-stu-001', 'u-tea-001', 'u-admstaff-001', 'u-adm-001'];
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

  DemoOffice? officeById(String? id) {
    return offices.firstWhereOrNull((office) => office.id == id);
  }

  DemoProgram? programById(String? id) {
    return programs.firstWhereOrNull((program) => program.id == id);
  }

  DemoCourse? courseById(String? id) {
    return courses.firstWhereOrNull((course) => course.id == id);
  }

  DemoProgram? programForCourse(DemoCourse? course) {
    if (course == null) {
      return null;
    }
    return programById(course.programId) ??
        programs.firstWhereOrNull(
          (program) => program.departmentId == course.departmentId,
        );
  }

  DemoSection? sectionById(String? id) {
    return sections.firstWhereOrNull((section) => section.id == id);
  }

  String departmentName(String? departmentId) {
    return departmentById(departmentId)?.name ??
        'Eastern University Bangladesh';
  }

  String officeName(String? officeId) {
    return officeById(officeId)?.name ?? 'University Administration';
  }

  String get currentSemesterName {
    return academicSemesters
            .firstWhereOrNull((semester) => semester.status == 'Current')
            ?.name ??
        'Spring 2026';
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
      case PortalRole.administration:
        final officeId = account?.officeId;
        if (officeId == 'office-program' || officeId == 'office-iqac') {
          return sections.where((section) {
            final course = courseById(section.courseId);
            return course?.departmentId == account?.departmentId;
          }).toList();
        }
        return [...sections];
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
    final officeId = _officeForSupportCategory(category);
    final ticket = DemoSupportTicket(
      id: _nextId('ticket'),
      requesterId: requester.id,
      subject: subject.trim(),
      category: category.trim(),
      priority: priority.trim(),
      status: 'open',
      createdAt: DateTime.now(),
      description: description.trim(),
      assignedOfficeId: officeId,
      userRole: requester.role.label,
      lastUpdated: DateTime.now(),
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
      userId: officeById(officeId)?.headId ?? 'u-admstaff-001',
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

  String _officeForSupportCategory(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('finance') || lower.contains('payment')) {
      return 'office-accounts';
    }
    if (lower.contains('it') || lower.contains('technical')) {
      return 'office-ict';
    }
    if (lower.contains('scholarship') || lower.contains('document')) {
      return 'office-registrar';
    }
    if (lower.contains('affairs') ||
        lower.contains('transport') ||
        lower.contains('id')) {
      return 'office-admission';
    }
    return 'office-program';
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
        authorId: actor?.id ?? 'u-admstaff-001',
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
      actorId: actor?.id ?? 'u-admstaff-001',
      title: 'Support reply sent',
      detail:
          '${actor?.fullName ?? 'Administration'} replied to ${ticket.subject}.',
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

  DemoAccount addStudentAccount({
    required String fullName,
    required String email,
    required String phone,
    String? departmentId,
  }) {
    final index = studentAccounts.length + 1;
    final id = _nextId('u-stu');
    final department = departmentId ?? 'dept-cse';
    final account = DemoAccount(
      id: id,
      universityId: '2026${index.toString().padLeft(6, '0')}',
      email: email.trim(),
      password: '123456',
      fullName: fullName.trim(),
      role: PortalRole.student,
      departmentId: department,
      program: _shortProgramTitle(
        programs
                .firstWhereOrNull(
                  (program) => program.departmentId == department,
                )
                ?.title ??
            'B.Sc. in CSE',
      ),
      semester: currentSemesterName,
      section: '1A',
      batch: '26',
      phone: phone.trim(),
      completedCredits: 0,
      currentCredits: 12,
    );
    accounts.add(account);
    final invoice = DemoInvoice(
      id: _nextId('inv'),
      studentId: account.id,
      semester: currentSemesterName,
      items: const {
        'Registration fee': 8000,
        'Tuition / credit fee': 39000,
        'Exam fee': 2200,
        'Library and other fees': 1500,
      },
      waiver: 0,
      paid: 0,
      dueDate: DateTime.now().add(const Duration(days: 20)),
    );
    invoices.add(invoice);
    addNotification(
      userId: account.id,
      title: 'EUB Connect account created',
      body: 'Your local demo student account is ready.',
    );
    addActivity(
      actorId: currentAccount?.id ?? 'u-adm-001',
      title: 'Student added',
      detail: '${account.fullName} was added to student management.',
    );
    _persist();
    return account;
  }

  DemoAccount addTeacherAccount({
    required String fullName,
    required String email,
    required String designation,
    String? departmentId,
  }) {
    final index = teacherAccounts.length + 1;
    final account = DemoAccount(
      id: _nextId('u-tea'),
      universityId: 'T${(2000 + index).toString()}',
      email: email.trim(),
      password: '123456',
      fullName: fullName.trim(),
      role: PortalRole.teacher,
      departmentId: departmentId ?? 'dept-cse',
      designation: designation.trim(),
      phone: '+880171120${index.toString().padLeft(4, '0')}',
    );
    accounts.add(account);
    addActivity(
      actorId: currentAccount?.id ?? 'u-adm-001',
      title: 'Teacher added',
      detail: '${account.fullName} was added to teacher management.',
    );
    _persist();
    return account;
  }

  DemoAccount addAdministrationStaff({
    required String fullName,
    required String email,
    required String designation,
    required String officeId,
  }) {
    final index = administrationAccounts.length + 1;
    final account = DemoAccount(
      id: _nextId('u-admstaff'),
      universityId: 'EUB-ADM-${(2000 + index).toString()}',
      email: email.trim(),
      password: '123456',
      fullName: fullName.trim(),
      role: PortalRole.administration,
      departmentId: 'dept-cse',
      officeId: officeId,
      designation: designation.trim(),
      phone: '+880171130${index.toString().padLeft(4, '0')}',
      responsibilities: officeById(officeId)?.responsibilities ?? const [],
    );
    accounts.add(account);
    addActivity(
      actorId: currentAccount?.id ?? 'u-adm-001',
      title: 'Administration staff added',
      detail: '${account.fullName} was assigned to ${officeName(officeId)}.',
    );
    _persist();
    return account;
  }

  void createEventRecord({
    required String title,
    required String description,
    required DateTime date,
    required String time,
    required String venue,
    required int capacity,
    required String organizer,
    required String audience,
  }) {
    final actor = currentAccount;
    final event = DemoEvent(
      id: _nextId('evt'),
      title: title.trim(),
      description: description.trim(),
      date: date,
      venue: venue.trim(),
      organizer: organizer.trim(),
      capacity: capacity,
      status: 'published',
      time: time.trim(),
      audience: audience.trim(),
    );
    events.insert(0, event);
    for (final account in accounts.where((account) {
      return audience == 'All' || account.role.label == audience;
    })) {
      addNotification(
        userId: account.id,
        title: 'New event published',
        body: event.title,
      );
    }
    addActivity(
      actorId: actor?.id ?? 'u-adm-001',
      title: 'Event created',
      detail: '${actor?.fullName ?? 'Admin'} published ${event.title}.',
    );
    _persist();
  }

  void createStudentRequest({
    required String type,
    required String notes,
    String priority = 'Normal',
  }) {
    final student = currentAccount;
    if (student == null || student.role != PortalRole.student) {
      throw StateError('Only a student account can create a student request.');
    }
    final officeId = _officeForRequestType(type);
    final request = DemoStudentRequest(
      id: _nextId('req'),
      studentId: student.id,
      type: type.trim(),
      submittedAt: DateTime.now(),
      assignedOfficeId: officeId,
      priority: priority,
      status: 'Submitted',
      notes: notes.trim(),
      timeline: ['Submitted by ${student.fullName}'],
      updatedAt: DateTime.now(),
    );
    studentRequests.insert(0, request);
    addNotification(
      userId: officeById(officeId)?.headId ?? 'u-admstaff-001',
      title: 'New student request',
      body: '${student.fullName} submitted ${request.type}.',
    );
    addActivity(
      actorId: student.id,
      title: 'Student request submitted',
      detail: '${student.fullName} submitted ${request.type}.',
    );
    _persist();
  }

  void processFirstStudentRequest() {
    final actor = currentAccount;
    final request = visibleStudentRequestsForCurrentOffice().firstWhereOrNull(
      (item) => !_isClosedStatus(item.status),
    );
    if (request == null) {
      throw StateError('No open student request is available.');
    }
    request.status = _nextRequestStatus(request.status);
    request.updatedAt = DateTime.now();
    request.timeline.add('${request.status} by ${actor?.fullName ?? 'office'}');
    addNotification(
      userId: request.studentId,
      title: 'Request updated',
      body: '${request.type} is now ${request.status}.',
    );
    addActivity(
      actorId: actor?.id ?? 'u-admstaff-001',
      title: 'Student request processed',
      detail: '${request.type} moved to ${request.status}.',
    );
    _persist();
  }

  void advanceFirstAdmission() {
    final actor = currentAccount;
    final application = admissions.firstWhereOrNull(
      (item) => item.stage != 'Registered' && item.stage != 'Rejected',
    );
    if (application == null) {
      throw StateError('No active admission application is available.');
    }
    application.stage = _nextAdmissionStage(application.stage);
    if (application.stage == 'Registered') {
      application.paymentStatus = 'Paid';
    }
    addActivity(
      actorId: actor?.id ?? 'u-adm-001',
      title: 'Admission application advanced',
      detail: '${application.applicantName} moved to ${application.stage}.',
    );
    _persist();
  }

  void publishFirstPendingResult() {
    final actor = currentAccount;
    final exam = examSchedules.firstWhereOrNull(
      (item) => item.resultPublicationStatus != 'Published',
    );
    if (exam == null) {
      throw StateError('No pending exam result workflow is available.');
    }
    exam.resultSubmissionStatus = 'Submitted';
    exam.resultApprovalStatus = 'Approved';
    exam.resultPublicationStatus = 'Published';
    for (final enrollment in enrollments.where(
      (item) => item.sectionId == exam.sectionId,
    )) {
      addNotification(
        userId: enrollment.studentId,
        title: 'Result published',
        body:
            '${courseById(exam.courseId)?.code ?? 'Course'} result is published.',
      );
    }
    addActivity(
      actorId: actor?.id ?? 'u-adm-001',
      title: 'Result published',
      detail:
          '${courseById(exam.courseId)?.code ?? exam.courseId} ${exam.examType} result published.',
    );
    _persist();
  }

  void recordPaymentForFirstDueInvoice() {
    final actor = currentAccount;
    final invoice = invoices.firstWhereOrNull((item) => item.due > 0);
    if (invoice == null) {
      throw StateError('No invoice with due amount is available.');
    }
    final amount = min<num>(10000, invoice.due);
    invoice.paid += amount;
    final payment = DemoPayment(
      id: _nextId('pay'),
      invoiceId: invoice.id,
      studentId: invoice.studentId,
      amount: amount,
      method: 'Admin counter entry',
      paidAt: DateTime.now(),
      receiptNo: 'EUB-ADMIN-${DateTime.now().millisecondsSinceEpoch}',
      status: 'Verified',
      reference: invoice.id,
    );
    payments.insert(0, payment);
    addNotification(
      userId: invoice.studentId,
      title: 'Payment recorded',
      body: '${_money(amount)} was recorded for ${invoice.semester}.',
    );
    addActivity(
      actorId: actor?.id ?? 'u-adm-001',
      title: 'Payment recorded',
      detail: '${_money(amount)} was recorded against ${invoice.id}.',
    );
    _persist();
  }

  void createCourseRecord({
    required String code,
    required String title,
    required String departmentId,
    required int credits,
    String? programId,
    String? prerequisite,
  }) {
    final actor = currentAccount;
    courses.add(
      DemoCourse(
        id: _nextId('course'),
        departmentId: departmentId,
        programId: programId,
        code: code.trim().toUpperCase(),
        title: title.trim(),
        credits: credits,
        prerequisite: prerequisite?.trim().isEmpty == true
            ? null
            : prerequisite?.trim(),
      ),
    );
    addActivity(
      actorId: actor?.id ?? 'u-adm-001',
      title: 'Course created',
      detail: '${code.trim().toUpperCase()} was added to the course catalog.',
    );
    _persist();
  }

  void createSectionRecord({
    required String courseId,
    required String teacherId,
    required String sectionCode,
    required String classroom,
    required String schedule,
    required int capacity,
  }) {
    final actor = currentAccount;
    final section = DemoSection(
      id: _nextId('sec'),
      courseId: courseId,
      teacherId: teacherId,
      sectionCode: sectionCode.trim().toUpperCase(),
      semester: currentSemesterName,
      capacity: capacity,
      classroom: classroom.trim(),
      schedule: schedule.trim(),
    );
    sections.add(section);
    addActivity(
      actorId: actor?.id ?? 'u-adm-001',
      title: 'Section created',
      detail:
          '${courseById(courseId)?.code ?? courseId} ${section.sectionCode} was created.',
    );
    _persist();
  }

  void reportLostFoundItem({
    required String type,
    required String title,
    required String description,
    required String location,
  }) {
    final reporter = currentAccount;
    if (reporter == null) {
      throw StateError('No account is signed in.');
    }
    lostFoundItems.insert(
      0,
      DemoLostFoundItem(
        id: _nextId('lf'),
        reporterId: reporter.id,
        type: type,
        title: title.trim(),
        description: description.trim(),
        location: location.trim(),
        reportedAt: DateTime.now(),
        contact: reporter.email,
        status: 'Open',
      ),
    );
    addActivity(
      actorId: reporter.id,
      title: '$type item reported',
      detail: '${reporter.fullName} reported "$title".',
    );
    _persist();
  }

  void markFirstLostFoundMatched({bool returned = false}) {
    final actor = currentAccount;
    final item = lostFoundItems.firstWhereOrNull(
      (candidate) =>
          candidate.status == 'Open' || candidate.status == 'Matched',
    );
    if (item == null) {
      throw StateError('No open lost and found item is available.');
    }
    item.status = returned ? 'Returned' : 'Matched';
    item.claimNote = returned
        ? 'Returned after local identity verification.'
        : 'Possible match found by administration.';
    addActivity(
      actorId: actor?.id ?? 'u-adm-001',
      title: returned ? 'Lost item returned' : 'Lost item matched',
      detail: '${item.title} marked ${item.status}.',
    );
    _persist();
  }

  String _officeForRequestType(String type) {
    final lower = type.toLowerCase();
    if (lower.contains('payment')) return 'office-accounts';
    if (lower.contains('result') ||
        lower.contains('transcript') ||
        lower.contains('supplementary')) {
      return 'office-exams';
    }
    if (lower.contains('id')) return 'office-admission';
    if (lower.contains('course')) return 'office-program';
    return 'office-registrar';
  }

  String _nextRequestStatus(String status) {
    const flow = [
      'Submitted',
      'Under Review',
      'Approved',
      'Processing',
      'Ready',
      'Completed',
    ];
    final index = flow.indexOf(status);
    if (index == -1 || index == flow.length - 1) {
      return 'Completed';
    }
    return flow[index + 1];
  }

  String _nextAdmissionStage(String stage) {
    const flow = [
      'New',
      'Documents Pending',
      'Under Review',
      'Eligible',
      'Approved',
      'Payment Pending',
      'Registered',
    ];
    final index = flow.indexOf(stage);
    if (index == -1 || index == flow.length - 1) {
      return 'Registered';
    }
    return flow[index + 1];
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
      case PortalRole.administration:
        return administrationDashboardMetrics();
      case PortalRole.admin:
        return adminKpiMetrics();
    }
  }

  List<StaticMetric> adminKpiMetrics() {
    return [
      StaticMetric(
        label: 'Total Students',
        value: '${studentAccounts.length}',
        note: 'Student records',
        icon: Icons.groups_outlined,
      ),
      StaticMetric(
        label: 'Active Students',
        value: '${studentAccounts.where((student) => student.active).length}',
        note: 'Account status',
        icon: Icons.person_search_outlined,
      ),
      StaticMetric(
        label: 'Teachers',
        value: '${teacherAccounts.length}',
        note: 'Teaching staff',
        icon: Icons.co_present_outlined,
      ),
      StaticMetric(
        label: 'Administration Staff',
        value: '${administrationAccounts.length}',
        note: 'Office staff',
        icon: Icons.badge_outlined,
      ),
      StaticMetric(
        label: 'Departments',
        value: '${departments.length}',
        note: 'Academic units',
        icon: Icons.account_tree_outlined,
      ),
      StaticMetric(
        label: 'Active Courses',
        value: '${courses.length}',
        note: 'Course catalog',
        icon: Icons.menu_book_outlined,
      ),
      StaticMetric(
        label: 'Active Sections',
        value: '${activeSectionsCount()}',
        note: currentSemesterName,
        icon: Icons.class_outlined,
      ),
      StaticMetric(
        label: 'Semester Enrollment',
        value: '${currentSemesterEnrollmentCount()}',
        note: currentSemesterName,
        icon: Icons.how_to_reg_outlined,
      ),
    ];
  }

  List<StaticMetric> administrationDashboardMetrics() {
    final account = currentAccount;
    final officeId = account?.officeId;
    final requests = visibleStudentRequestsForCurrentOffice();
    final tickets = visibleSupportTicketsForCurrentOffice();
    final examsForOffice = officeId == 'office-exams' ? examSchedules : [];
    final officeMetrics = _officeSpecificMetrics(officeId);
    return [
      StaticMetric(
        label: 'Pending Requests',
        value:
            '${requests.where((request) => !_isClosedStatus(request.status)).length}',
        note: officeName(officeId),
        icon: Icons.request_page_outlined,
      ),
      StaticMetric(
        label: 'Tasks Today',
        value:
            '${requests.where((request) => _sameDay(request.updatedAt ?? request.submittedAt, DateTime.now())).length + tickets.where((ticket) => _sameDay(ticket.lastUpdated ?? ticket.createdAt, DateTime.now())).length}',
        note: 'Updated records',
        icon: Icons.today_outlined,
      ),
      StaticMetric(
        label: 'Pending Approvals',
        value: '${pendingApprovals()}',
        note: 'Local workflow',
        icon: Icons.fact_check_outlined,
      ),
      StaticMetric(
        label: 'Student Requests',
        value: '${requests.length}',
        note: 'Assigned to office',
        icon: Icons.school_outlined,
      ),
      StaticMetric(
        label: 'Open Support',
        value: '${tickets.where((ticket) => ticket.status != 'closed').length}',
        note: 'Office tickets',
        icon: Icons.support_agent_outlined,
      ),
      StaticMetric(
        label: 'Documents Review',
        value:
            '${requests.where((request) => request.type.toLowerCase().contains('certificate') || request.type.toLowerCase().contains('transcript')).length}',
        note: 'Academic documents',
        icon: Icons.description_outlined,
      ),
      if (examsForOffice.isNotEmpty)
        StaticMetric(
          label: 'Result Workflow',
          value:
              '${examsForOffice.where((exam) => exam.resultPublicationStatus != 'Published').length}',
          note: 'Awaiting publication',
          icon: Icons.grade_outlined,
        ),
      ...officeMetrics,
    ];
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
      case 'Process first student request':
        processFirstStudentRequest();
        return 'First open student request moved to the next workflow status.';
      case 'Advance first admission':
        advanceFirstAdmission();
        return 'First active admission application advanced to the next stage.';
      case 'Publish first pending result':
        publishFirstPendingResult();
        return 'First pending exam result workflow has been published.';
      case 'Record payment':
        recordPaymentForFirstDueInvoice();
        return 'Payment recorded against the first invoice with a due balance.';
      case 'Review requests':
        return 'Open Student Requests to review request records.';
      case 'Review reports':
        resolveFirstForumReport();
        return 'First pending forum report resolved.';
      case 'Create course':
        createCourseRecord(
          code: 'CSE ${400 + courses.length}',
          title: 'Special Topics in Computing',
          departmentId: 'dept-cse',
          credits: 3,
          programId: 'program-cse-bsc',
        );
        return 'A new demo course was added to the catalog.';
      case 'Create section':
        createSectionRecord(
          courseId: courses.first.id,
          teacherId: teacherAccounts.first.id,
          sectionCode: '1A',
          classroom: 'Room 601',
          schedule: 'Sunday 10:00 AM',
          capacity: 40,
        );
        return 'A new demo section was created.';
      case 'Mark lost item matched':
        markFirstLostFoundMatched();
        return 'First open lost and found item marked matched.';
      case 'Mark lost item returned':
        markFirstLostFoundMatched(returned: true);
        return 'First matched/open lost and found item marked returned.';
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

  List<DemoStudentRequest> visibleStudentRequestsForCurrentOffice() {
    final account = currentAccount;
    if (account?.role == PortalRole.admin) {
      return [...studentRequests];
    }
    final officeId = account?.officeId;
    if (officeId == null) {
      return [];
    }
    return studentRequests
        .where((request) => request.assignedOfficeId == officeId)
        .toList();
  }

  List<DemoSupportTicket> visibleSupportTicketsForCurrentOffice() {
    final account = currentAccount;
    if (account?.role == PortalRole.admin) {
      return [...supportTickets];
    }
    final officeId = account?.officeId;
    if (officeId == null) {
      return [];
    }
    return supportTickets
        .where((ticket) => ticket.assignedOfficeId == officeId)
        .toList();
  }

  int activeSectionsCount() {
    return sections
        .where((section) => section.semester == currentSemesterName)
        .length;
  }

  int currentSemesterEnrollmentCount() {
    final currentSectionIds = sections
        .where((section) => section.semester == currentSemesterName)
        .map((section) => section.id)
        .toSet();
    return enrollments
        .where((enrollment) => currentSectionIds.contains(enrollment.sectionId))
        .length;
  }

  double averageAttendancePercent() {
    if (attendance.isEmpty) {
      return 0;
    }
    final attended = attendance.where((record) {
      return record.status != DemoAttendanceStatus.absent;
    }).length;
    return attended / attendance.length * 100;
  }

  num totalBilled() {
    return invoices.fold<num>(0, (total, invoice) => total + invoice.total);
  }

  num totalCollected() {
    return payments
        .where((payment) => payment.status != 'Rejected')
        .fold<num>(0, (total, payment) => total + payment.amount);
  }

  num totalOutstanding() {
    return invoices.fold<num>(0, (total, invoice) => total + invoice.due);
  }

  int overdueInvoiceCount() {
    final now = DateTime.now();
    return invoices.where((invoice) {
      return invoice.due > 0 && invoice.dueDate.isBefore(now);
    }).length;
  }

  bool _sameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  bool _isClosedStatus(String status) {
    final lower = status.toLowerCase();
    return lower == 'completed' ||
        lower == 'closed' ||
        lower == 'resolved' ||
        lower == 'rejected';
  }

  List<StaticMetric> _officeSpecificMetrics(String? officeId) {
    switch (officeId) {
      case 'office-registrar':
        return [
          StaticMetric(
            label: 'Active Students',
            value:
                '${studentAccounts.where((student) => student.active).length}',
            note: 'Student records',
            icon: Icons.groups_outlined,
          ),
          StaticMetric(
            label: 'Registration Requests',
            value:
                '${studentRequests.where((request) => request.type.toLowerCase().contains('registration')).length}',
            note: 'Registrar queue',
            icon: Icons.edit_note_outlined,
          ),
          StaticMetric(
            label: 'Certificates',
            value:
                '${studentRequests.where((request) => request.type.toLowerCase().contains('certificate')).length}',
            note: 'Documents',
            icon: Icons.workspace_premium_outlined,
          ),
        ];
      case 'office-exams':
        return [
          StaticMetric(
            label: 'Active Exams',
            value: '${examSchedules.length}',
            note: 'Exam schedules',
            icon: Icons.assignment_outlined,
          ),
          StaticMetric(
            label: 'Pending Results',
            value:
                '${examSchedules.where((exam) => exam.resultSubmissionStatus != 'Submitted').length}',
            note: 'Awaiting teacher submission',
            icon: Icons.rate_review_outlined,
          ),
          StaticMetric(
            label: 'Transcript Requests',
            value:
                '${studentRequests.where((request) => request.type == 'Transcript').length}',
            note: 'Student documents',
            icon: Icons.description_outlined,
          ),
        ];
      case 'office-accounts':
        return [
          StaticMetric(
            label: 'Fees Collected',
            value: _money(totalCollected()),
            note: 'Payment rows',
            icon: Icons.payments_outlined,
          ),
          StaticMetric(
            label: 'Outstanding',
            value: _money(totalOutstanding()),
            note: 'Invoice due',
            icon: Icons.account_balance_wallet_outlined,
          ),
          StaticMetric(
            label: 'Pending Verification',
            value:
                '${payments.where((payment) => payment.status == 'Pending Verification').length}',
            note: 'Payment review',
            icon: Icons.verified_outlined,
          ),
        ];
      case 'office-admission':
        return [
          StaticMetric(
            label: 'Applications',
            value: '${admissions.length}',
            note: 'Admission records',
            icon: Icons.how_to_reg_outlined,
          ),
          StaticMetric(
            label: 'Under Review',
            value:
                '${admissions.where((item) => item.stage == 'Under Review').length}',
            note: 'Document review',
            icon: Icons.fact_check_outlined,
          ),
          StaticMetric(
            label: 'Registered',
            value:
                '${admissions.where((item) => item.stage == 'Registered').length}',
            note: 'Converted applicants',
            icon: Icons.verified_user_outlined,
          ),
        ];
      case 'office-iqac':
        return [
          StaticMetric(
            label: 'Quality Reviews',
            value:
                '${approvals.where((approval) => approval.type.toLowerCase().contains('quality')).length + departments.length}',
            note: 'Review items',
            icon: Icons.fact_check_outlined,
          ),
          StaticMetric(
            label: 'Avg Attendance',
            value: '${averageAttendancePercent().round()}%',
            note: 'All sections',
            icon: Icons.query_stats_outlined,
          ),
          StaticMetric(
            label: 'Departments',
            value: '${departments.length}',
            note: 'Performance scope',
            icon: Icons.account_tree_outlined,
          ),
        ];
      case 'office-proctor':
        return [
          StaticMetric(
            label: 'Complaints',
            value:
                '${supportTickets.where((ticket) => ticket.assignedOfficeId == 'office-proctor' || ticket.category.toLowerCase().contains('complaint')).length}',
            note: 'Case management',
            icon: Icons.gavel_outlined,
          ),
          StaticMetric(
            label: 'Forum Reports',
            value: '${pendingForumReports()}',
            note: 'Moderation queue',
            icon: Icons.report_outlined,
          ),
        ];
      case 'office-ict':
        return [
          StaticMetric(
            label: 'Open Tickets',
            value:
                '${supportTickets.where((ticket) => ticket.assignedOfficeId == 'office-ict' && ticket.status != 'closed').length}',
            note: 'Technical support',
            icon: Icons.support_agent_outlined,
          ),
          StaticMetric(
            label: 'Labs',
            value:
                '${schedules.map((schedule) => schedule.room).where((room) => room.toLowerCase().contains('lab')).toSet().length}',
            note: 'Lab rooms in routine',
            icon: Icons.computer_outlined,
          ),
        ];
      default:
        return [
          StaticMetric(
            label: 'Office Staff',
            value: '${administrationAccounts.length}',
            note: 'Administration roster',
            icon: Icons.badge_outlined,
          ),
        ];
    }
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
      case 'Administration Portal':
        return _administrationPortalDetails();
      case 'Admin Dashboard':
        return _adminDashboardDetails();
      case 'Semester Courses':
      case 'Courses':
        return _courseDetails();
      case 'Programs':
        return _programDetails();
      case 'Sections':
        return _sectionDetails();
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
      case 'Invoices':
        return _invoiceDetails();
      case 'Payments':
        return _paymentTransactionDetails();
      case 'Scholarships':
      case 'Scholarships/Waivers':
        return _scholarshipDetails();
      case 'Admissions':
        return _admissionDetails();
      case 'Examinations':
        return _examDetails();
      case 'Student Requests':
        return _studentRequestDetails(role);
      case 'Events':
      case 'Event Management':
        return _eventDetails(role);
      case 'Clubs':
        return _clubDetails();
      case 'Community Forum':
      case 'Discussion Board':
        return _forumDetails(role);
      case 'Community Moderation':
        return _moderationDetails();
      case 'Student Support':
      case 'Support Tickets':
        return _supportDetails(role);
      case 'Complaints/Cases':
        return _complaintDetails();
      case 'Teacher Management':
        return _teacherManagementDetails();
      case 'Student Management':
        return _studentManagementDetails();
      case 'Administration Staff':
        return _administrationStaffDetails();
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
      case 'Activity Log':
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

  _ModuleDetails _administrationPortalDetails() {
    final account = currentAccount;
    final office = officeById(account?.officeId);
    final requests = visibleStudentRequestsForCurrentOffice();
    final tickets = visibleSupportTicketsForCurrentOffice();
    return _ModuleDetails(
      description:
          'Office workflow for ${office?.name ?? 'Administration'} with requests, support, documents, notices, and activity calculated from local records.',
      metrics: administrationDashboardMetrics(),
      records: [
        StaticRecord(
          title: account?.fullName ?? 'Administration user',
          subtitle:
              '${account?.designation ?? 'Administrative staff'} - ${office?.name ?? 'University office'}',
          meta: account?.universityId ?? 'Employee ID',
          status: account?.active == false ? 'Inactive' : 'Active',
          icon: Icons.badge_outlined,
          details: {
            'Office': office?.name ?? 'University Administration',
            'Designation': account?.designation ?? 'Administrative staff',
            'Employee ID': account?.universityId ?? '',
            'Responsibilities': (account?.responsibilities ?? const []).join(
              ', ',
            ),
          },
        ),
        ...requests.take(8).map(_studentRequestRecord),
        ...tickets.take(8).map(_supportTicketRecord),
      ],
      actions: const [
        'Process first student request',
        'Reply to open ticket',
        'Create notice',
      ],
    );
  }

  _ModuleDetails _adminDashboardDetails() {
    return _ModuleDetails(
      description:
          'European University of Bangladesh administration and system overview for this local demo. KPIs, finance, admissions, exams, requests, offices, and attention items are all calculated from DemoStore records.',
      metrics: [
        ...adminKpiMetrics(),
        StaticMetric(
          label: 'Total Billed',
          value: _money(totalBilled()),
          note: 'Invoice records',
          icon: Icons.receipt_long_outlined,
        ),
        StaticMetric(
          label: 'Collected',
          value: _money(totalCollected()),
          note: 'Payment records',
          icon: Icons.payments_outlined,
        ),
        StaticMetric(
          label: 'Outstanding',
          value: _money(totalOutstanding()),
          note: 'Invoice due',
          icon: Icons.account_balance_wallet_outlined,
        ),
        StaticMetric(
          label: 'Admissions',
          value: '${admissions.length}',
          note: 'Applicant records',
          icon: Icons.how_to_reg_outlined,
        ),
      ],
      records: [
        ...needsAttentionRecords().take(10),
        ...administrationOfficeRecords().take(12),
        ...activities.take(8).map(_activityRecord),
      ],
      actions: const [
        'Add Student',
        'Add Teacher',
        'Add Administration Staff',
        'Create notice',
        'Create event',
        'Record payment',
        'Review requests',
        'Review reports',
      ],
    );
  }

  _ModuleDetails _courseDetails() {
    final sectionRows = visibleSectionsForRole();
    final isManagementScope =
        currentRole == PortalRole.admin ||
        currentRole == PortalRole.administration;
    final courseRows = isManagementScope
        ? courses
        : sectionRows
              .map((section) => courseById(section.courseId))
              .whereType<DemoCourse>()
              .toSet()
              .toList();
    return _ModuleDetails(
      description:
          'Courses are resolved from departments, programs, sections, teachers, schedules, and enrollment records.',
      metrics: [
        StaticMetric(
          label: 'Courses',
          value: '${courseRows.length}',
          note: isManagementScope
              ? 'Course catalog'
              : 'Visible to this account',
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
      records: courseRows.map((course) {
        final program = programForCourse(course);
        final courseSections = sections
            .where((section) => section.courseId == course.id)
            .toList();
        final enrolled = enrollments
            .where(
              (enrollment) => courseSections.any(
                (section) => section.id == enrollment.sectionId,
              ),
            )
            .map((enrollment) => enrollment.studentId)
            .toSet()
            .length;
        final teachers = courseSections
            .map((section) => accountById(section.teacherId)?.fullName)
            .whereType<String>()
            .toSet()
            .join(', ');
        return StaticRecord(
          title: '${course.code} ${course.title}',
          subtitle:
              '${departmentName(course.departmentId)} - ${program?.title ?? 'Program mapping pending'}',
          meta: '${course.credits} credits, $enrolled enrolled',
          status: '${courseSections.length} sections',
          icon: Icons.menu_book_outlined,
          details: {
            'Department': departmentName(course.departmentId),
            'Program': program?.title ?? 'Derived from department',
            'Prerequisite': course.prerequisite ?? 'None',
            'Teachers': teachers.isEmpty ? 'Unassigned' : teachers,
            'Relationship': 'Department -> Program -> Course -> Section',
          },
        );
      }).toList(),
      actions: currentRole == PortalRole.admin
          ? const ['Create course']
          : const [],
    );
  }

  _ModuleDetails _programDetails() {
    return _ModuleDetails(
      description:
          'Programs are separate from departments, courses, and sections. Active student counts are calculated from student profiles.',
      metrics: [
        StaticMetric(
          label: 'Programs',
          value: '${programs.length}',
          note: 'Academic offerings',
          icon: Icons.school_outlined,
        ),
        StaticMetric(
          label: 'Undergraduate',
          value:
              '${programs.where((program) => program.degreeType == 'Undergraduate').length}',
          note: 'Degree type',
          icon: Icons.workspace_premium_outlined,
        ),
      ],
      records: programs.map((program) {
        final activeStudents = studentAccounts.where((student) {
          return student.program == program.title ||
              student.program == _shortProgramTitle(program.title);
        }).length;
        final courseCount = courses.where((course) {
          return course.programId == program.id ||
              (course.programId == null &&
                  course.departmentId == program.departmentId);
        }).length;
        return StaticRecord(
          title: program.title,
          subtitle: departmentName(program.departmentId),
          meta: '${program.code} - ${program.totalCredits} credits',
          status: '$activeStudents students, $courseCount courses',
          icon: Icons.school_outlined,
          details: {
            'Program code': program.code,
            'Degree type': program.degreeType,
            'Duration': program.duration,
            'Total credits': '${program.totalCredits}',
            'Department': departmentName(program.departmentId),
            'Status': program.status,
          },
        );
      }).toList(),
    );
  }

  _ModuleDetails _sectionDetails() {
    final rows =
        currentRole == PortalRole.admin ||
            currentRole == PortalRole.administration
        ? sections
        : visibleSectionsForRole();
    return _ModuleDetails(
      description:
          'Sections connect courses, teachers, rooms, schedules, capacity, and enrolled students.',
      metrics: [
        StaticMetric(
          label: 'Sections',
          value: '${rows.length}',
          note: 'Current scope',
          icon: Icons.class_outlined,
        ),
        StaticMetric(
          label: 'Near Capacity',
          value:
              '${rows.where((section) => _sectionEnrollment(section.id) >= section.capacity * 0.9).length}',
          note: 'Capacity warning',
          icon: Icons.warning_amber_outlined,
        ),
      ],
      records: rows.map((section) {
        final course = courseById(section.courseId);
        final teacher = accountById(section.teacherId);
        final schedule = schedules.firstWhereOrNull(
          (item) => item.sectionId == section.id,
        );
        final enrolled = _sectionEnrollment(section.id);
        return StaticRecord(
          title:
              '${course?.code ?? 'Course'} ${section.sectionCode} - ${section.semester}',
          subtitle:
              '${course?.title ?? 'Course'} - ${teacher?.fullName ?? 'Teacher not assigned'}',
          meta: schedule == null
              ? 'Schedule pending'
              : '${schedule.day} ${schedule.start}',
          status: '$enrolled/${section.capacity}',
          icon: Icons.class_outlined,
          details: {
            'Course': '${course?.code ?? ''} ${course?.title ?? ''}',
            'Teacher': teacher?.fullName ?? 'Unassigned',
            'Classroom': section.classroom ?? schedule?.room ?? 'Room pending',
            'Schedule':
                section.schedule ??
                '${schedule?.day ?? 'TBA'} ${schedule?.start ?? ''}',
            'Capacity': '${section.capacity}',
            'Enrolled': '$enrolled',
          },
        );
      }).toList(),
      actions: currentRole == PortalRole.admin
          ? const ['Create section']
          : const [],
    );
  }

  _ModuleDetails _routineDetails(PortalRole role) {
    final rows = role == PortalRole.admin || role == PortalRole.administration
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

  _ModuleDetails _invoiceDetails() {
    return _ModuleDetails(
      description:
          'Semester invoices form coherent student ledgers with tuition, registration, exam, other fees, waivers, payments, and due.',
      metrics: [
        StaticMetric(
          label: 'Invoices',
          value: '${invoices.length}',
          note: 'One per seeded student',
          icon: Icons.receipt_long_outlined,
        ),
        StaticMetric(
          label: 'Total Billed',
          value: _money(totalBilled()),
          note: 'Invoice totals',
          icon: Icons.account_balance_wallet_outlined,
        ),
        StaticMetric(
          label: 'Outstanding',
          value: _money(totalOutstanding()),
          note: 'Remaining due',
          icon: Icons.warning_amber_outlined,
        ),
        StaticMetric(
          label: 'Overdue',
          value: '${overdueInvoiceCount()}',
          note: 'Past due invoices',
          icon: Icons.schedule_outlined,
        ),
      ],
      records: invoices.map(_invoiceRecord).toList(),
      actions: const ['Record payment'],
    );
  }

  _ModuleDetails _paymentTransactionDetails() {
    return _ModuleDetails(
      description:
          'Payments are generated from invoice paid amounts and include method, status, reference, and receipt metadata.',
      metrics: [
        StaticMetric(
          label: 'Payments',
          value: '${payments.length}',
          note: 'Transaction rows',
          icon: Icons.payments_outlined,
        ),
        StaticMetric(
          label: 'Collected',
          value: _money(totalCollected()),
          note: 'Payment total',
          icon: Icons.account_balance_wallet_outlined,
        ),
        StaticMetric(
          label: 'Today',
          value:
              '${payments.where((payment) => _sameDay(payment.paidAt, DateTime.now())).length}',
          note: 'Payments today',
          icon: Icons.today_outlined,
        ),
        StaticMetric(
          label: 'Verification',
          value:
              '${payments.where((payment) => payment.status == 'Pending Verification').length}',
          note: 'Pending review',
          icon: Icons.verified_outlined,
        ),
      ],
      records: payments.take(80).map(_paymentRecord).toList(),
      actions: const ['Record payment'],
    );
  }

  _ModuleDetails _admissionDetails() {
    final stages = [
      'New',
      'Documents Pending',
      'Under Review',
      'Eligible',
      'Approved',
      'Payment Pending',
      'Registered',
    ];
    return _ModuleDetails(
      description:
          'Admission pipeline tracks application, document review, eligibility, approval, payment, and registration stages.',
      metrics: [
        StaticMetric(
          label: 'Applications',
          value: '${admissions.length}',
          note: 'Total applicants',
          icon: Icons.how_to_reg_outlined,
        ),
        StaticMetric(
          label: 'New',
          value: '${admissions.where((item) => item.stage == 'New').length}',
          note: 'Fresh applications',
          icon: Icons.fiber_new_outlined,
        ),
        StaticMetric(
          label: 'Under Review',
          value:
              '${admissions.where((item) => item.stage == 'Under Review').length}',
          note: 'Office review',
          icon: Icons.fact_check_outlined,
        ),
        StaticMetric(
          label: 'Enrolled',
          value:
              '${admissions.where((item) => item.stage == 'Registered').length}',
          note: 'Registered applicants',
          icon: Icons.verified_user_outlined,
        ),
      ],
      records: [
        StaticRecord(
          title: 'Admission funnel',
          subtitle: stages
              .map((stage) {
                final count = admissions
                    .where((item) => item.stage == stage)
                    .length;
                return '$stage: $count';
              })
              .join(' -> '),
          meta:
              'Application -> Document Review -> Eligible -> Approved -> Payment -> Registered',
          status: '${admissions.length} applications',
          icon: Icons.filter_alt_outlined,
        ),
        ...admissions.map((application) {
          final program = programById(application.programId);
          final missing = application.documents.entries
              .where((entry) => !entry.value)
              .map((entry) => entry.key)
              .join(', ');
          return StaticRecord(
            title: '${application.id} - ${application.applicantName}',
            subtitle: program?.title ?? application.programId,
            meta:
                '${_date(application.applicationDate)} - ${application.contact}',
            status: application.stage,
            icon: Icons.how_to_reg_outlined,
            details: {
              'Application ID': application.id,
              'Program': program?.title ?? application.programId,
              'Contact': application.contact,
              'Previous education': application.previousEducation,
              'Application date': _date(application.applicationDate),
              'Documents': application.documents.entries
                  .map(
                    (entry) =>
                        '${entry.key}: ${entry.value ? 'OK' : 'Missing'}',
                  )
                  .join(', '),
              'Missing documents': missing.isEmpty ? 'None' : missing,
              'Admission status': application.stage,
              'Payment status': application.paymentStatus,
            },
          );
        }),
      ],
      actions: const ['Advance first admission'],
    );
  }

  _ModuleDetails _examDetails() {
    return _ModuleDetails(
      description:
          'Exam management includes schedules, exam rooms, invigilators, admit-card status, result submission, approval, publication, and supplementary cases.',
      metrics: [
        StaticMetric(
          label: 'Upcoming Exams',
          value:
              '${examSchedules.where((exam) => exam.date.isAfter(DateTime.now())).length}',
          note: 'Schedule records',
          icon: Icons.assignment_outlined,
        ),
        StaticMetric(
          label: 'Results Submission',
          value:
              '${examSchedules.where((exam) => exam.resultSubmissionStatus != 'Submitted').length}',
          note: 'Awaiting teachers',
          icon: Icons.rate_review_outlined,
        ),
        StaticMetric(
          label: 'Approval',
          value:
              '${examSchedules.where((exam) => exam.resultApprovalStatus != 'Approved').length}',
          note: 'Exam office review',
          icon: Icons.verified_outlined,
        ),
        StaticMetric(
          label: 'Published',
          value:
              '${examSchedules.where((exam) => exam.resultPublicationStatus == 'Published').length}',
          note: 'Student-visible results',
          icon: Icons.publish_outlined,
        ),
      ],
      records: examSchedules.map(_examRecord).toList(),
      actions: const ['Publish first pending result'],
    );
  }

  _ModuleDetails _studentRequestDetails(PortalRole role) {
    final account = currentAccount;
    final rows = role == PortalRole.student
        ? studentRequests
              .where((request) => request.studentId == account?.id)
              .toList()
        : role == PortalRole.administration
        ? visibleStudentRequestsForCurrentOffice()
        : studentRequests;
    return _ModuleDetails(
      description:
          'Student requests cover transcripts, certificates, verification, ID replacement, registration, payment, result correction, and supplementary exam workflows.',
      metrics: [
        StaticMetric(
          label: 'Requests',
          value: '${rows.length}',
          note: 'Current scope',
          icon: Icons.request_page_outlined,
        ),
        StaticMetric(
          label: 'Open',
          value:
              '${rows.where((request) => !_isClosedStatus(request.status)).length}',
          note: 'Needs processing',
          icon: Icons.pending_actions_outlined,
        ),
      ],
      records: rows.map(_studentRequestRecord).toList(),
      actions: role == PortalRole.student
          ? const ['Create student request']
          : const ['Process first student request'],
    );
  }

  _ModuleDetails _clubDetails() {
    return _ModuleDetails(
      description:
          'Clubs include advisor, president, active members, events, and membership status.',
      metrics: [
        StaticMetric(
          label: 'Clubs',
          value: '${clubs.length}',
          note: 'Campus organizations',
          icon: Icons.groups_2_outlined,
        ),
        StaticMetric(
          label: 'Memberships',
          value:
              '${clubMemberships.where((item) => item.status == 'active').length}',
          note: 'Active members',
          icon: Icons.how_to_reg_outlined,
        ),
      ],
      records: clubs.map((club) {
        final advisor = accountById(club.advisorId);
        final president = accountById(club.presidentId);
        final members = clubMemberships
            .where((membership) => membership.clubId == club.id)
            .length;
        final eventCount = events
            .where(
              (event) => event.organizer.toLowerCase().contains(
                club.name.split(' ').first.toLowerCase(),
              ),
            )
            .length;
        return StaticRecord(
          title: club.name,
          subtitle: club.description,
          meta: 'Advisor: ${advisor?.fullName ?? 'Pending'}',
          status: '$members members, $eventCount events',
          icon: Icons.groups_2_outlined,
          details: {
            'Advisor': advisor?.fullName ?? 'Pending',
            'President': president?.fullName ?? 'Pending',
            'Members': '$members',
            'Events': '$eventCount',
            'Membership status': 'Open for local demo registration',
          },
        );
      }).toList(),
    );
  }

  _ModuleDetails _moderationDetails() {
    return _ModuleDetails(
      description:
          'Forum moderation shows reports with author, reporter, reason, content, status, and local actions.',
      metrics: [
        StaticMetric(
          label: 'Reports',
          value: '${forumReports.length}',
          note: 'All reports',
          icon: Icons.report_outlined,
        ),
        StaticMetric(
          label: 'Pending',
          value: '${pendingForumReports()}',
          note: 'Need review',
          icon: Icons.pending_actions_outlined,
        ),
      ],
      records: forumReports.map(_forumReportRecord).toList(),
      actions: const ['Resolve forum report', 'Hide reported content'],
    );
  }

  _ModuleDetails _complaintDetails() {
    final rows = {
      ...supportTickets.where((ticket) {
        return ticket.category.toLowerCase().contains('complaint') ||
            ticket.assignedOfficeId == 'office-proctor';
      }),
      ...supportTickets.where((ticket) => ticket.priority == 'High').take(4),
    }.toList();
    return _ModuleDetails(
      description:
          'Complaints and cases combine proctor-office cases, escalated support, and high-priority student issues.',
      metrics: [
        StaticMetric(
          label: 'Cases',
          value: '${rows.length}',
          note: 'Complaint scope',
          icon: Icons.gavel_outlined,
        ),
        StaticMetric(
          label: 'Escalated',
          value: '${rows.where((ticket) => ticket.priority == 'High').length}',
          note: 'High priority',
          icon: Icons.warning_amber_outlined,
        ),
      ],
      records: rows.map(_supportTicketRecord).toList(),
      actions: const ['Reply to open ticket'],
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
          meta: '${_date(event.date)} ${event.time} - ${event.venue}',
          status: '$count/${event.capacity}',
          icon: Icons.event_outlined,
          details: {
            'Organizer': event.organizer,
            'Date': _date(event.date),
            'Time': event.time,
            'Venue': event.venue,
            'Capacity': '${event.capacity}',
            'Registered': '$count',
            'Audience': event.audience,
            'Status': event.status,
          },
        );
      }).toList(),
      actions: role == PortalRole.student
          ? const ['Register next event']
          : const ['Create event', 'Approve first request'],
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
      actions: role == PortalRole.admin || role == PortalRole.administration
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
        : role == PortalRole.administration
        ? visibleSupportTicketsForCurrentOffice()
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
      records: rows.map(_supportTicketRecord).toList(),
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
        final assignedSections = sections
            .where((section) => section.teacherId == teacher.id)
            .toList();
        final assigned = assignedSections.length;
        final studentCount = enrollments
            .where(
              (enrollment) => assignedSections.any(
                (section) => section.id == enrollment.sectionId,
              ),
            )
            .map((enrollment) => enrollment.studentId)
            .toSet()
            .length;
        final pendingGrades = submissions.where((submission) {
          final assignment = assignments.firstWhereOrNull(
            (item) => item.id == submission.assignmentId,
          );
          return assignment != null &&
              assignedSections.any(
                (section) => section.id == assignment.sectionId,
              ) &&
              submission.status != 'graded';
        }).length;
        return StaticRecord(
          title: teacher.fullName,
          subtitle:
              '${teacher.universityId} - ${departmentName(teacher.departmentId)}',
          meta: teacher.designation ?? 'Teacher',
          status: '$assigned sections, $studentCount students',
          icon: Icons.co_present_outlined,
          details: {
            'Employee ID': teacher.universityId,
            'Department': departmentName(teacher.departmentId),
            'Designation': teacher.designation ?? 'Teacher',
            'Assigned courses': assignedSections
                .map((section) => subjectForSection(section.id).code)
                .toSet()
                .join(', '),
            'Sections': assignedSections
                .map((section) => section.sectionCode)
                .toSet()
                .join(', '),
            'Student count': '$studentCount',
            'Office hours': 'Sun/Tue 02:00 PM - 04:00 PM',
            'Pending grading': '$pendingGrades',
            'Status': teacher.active ? 'Active' : 'Inactive',
          },
        );
      }).toList(),
      actions: currentRole == PortalRole.admin
          ? const ['Add Teacher']
          : const [],
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
        final invoiceRows = invoices
            .where((invoice) => invoice.studentId == student.id)
            .toList();
        final paid = invoiceRows.fold<num>(
          0,
          (total, invoice) => total + invoice.paid,
        );
        final due = invoiceRows.fold<num>(
          0,
          (total, invoice) => total + invoice.due,
        );
        final resultRows = results
            .where((result) => result.studentId == student.id)
            .toList();
        final requestCount = studentRequests
            .where((request) => request.studentId == student.id)
            .length;
        return StaticRecord(
          title: student.fullName,
          subtitle:
              '${student.universityId} - ${departmentName(student.departmentId)}',
          meta: '${student.semester ?? ''} ${student.section ?? ''}',
          status: due <= 0 ? 'Clear' : '${_money(due)} due',
          icon: Icons.person_outline,
          details: {
            'Student ID': student.universityId,
            'Department': departmentName(student.departmentId),
            'Program': student.program ?? '',
            'Intake/Batch': student.batch ?? '',
            'Semester': student.semester ?? '',
            'Section': student.section ?? '',
            'Credits completed': '${student.completedCredits}',
            'Current credits': '${student.currentCredits}',
            'CGPA':
                student.cgpa?.toStringAsFixed(2) ??
                _cgpa(resultRows).toStringAsFixed(2),
            'Account status': student.active ? 'Active' : 'Inactive',
            'Payment status': due <= 0 ? 'Clear' : 'Outstanding',
            'Advisor': _advisorName(student.departmentId),
            'Attendance': '${studentAttendancePercent(student.id).round()}%',
            'Paid': _money(paid),
            'Outstanding': _money(due),
            'Requests': '$requestCount',
          },
        );
      }).toList(),
      actions: currentRole == PortalRole.admin
          ? const ['Add Student', 'Toggle first student status']
          : const [],
    );
  }

  _ModuleDetails _administrationStaffDetails() {
    return _ModuleDetails(
      description:
          'Administration staff are separate from Admin users and are assigned to EUB-style offices with responsibilities.',
      metrics: [
        StaticMetric(
          label: 'Staff',
          value: '${administrationAccounts.length}',
          note: 'Administration role',
          icon: Icons.badge_outlined,
        ),
        StaticMetric(
          label: 'Offices',
          value: '${offices.length}',
          note: 'Operational units',
          icon: Icons.account_balance_outlined,
        ),
      ],
      records: administrationAccounts.map((staff) {
        final office = officeById(staff.officeId);
        final taskCount =
            studentRequests
                .where((request) => request.assignedOfficeId == staff.officeId)
                .length +
            supportTickets
                .where((ticket) => ticket.assignedOfficeId == staff.officeId)
                .length;
        return StaticRecord(
          title: staff.fullName,
          subtitle:
              '${staff.universityId} - ${office?.name ?? 'Administration'}',
          meta: staff.designation ?? 'Administrative staff',
          status: '$taskCount current tasks',
          icon: Icons.badge_outlined,
          details: {
            'Employee ID': staff.universityId,
            'Office': office?.name ?? 'Administration',
            'Designation': staff.designation ?? '',
            'Email': staff.email,
            'Phone': staff.phone ?? '',
            'Responsibilities': staff.responsibilities.join(', '),
            'Current tasks': '$taskCount',
            'Status': staff.active ? 'Active' : 'Inactive',
          },
        );
      }).toList(),
      actions: const ['Add Administration Staff'],
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
        final deptSections = sections.where((section) {
          final course = courseById(section.courseId);
          return course?.departmentId == department.id;
        }).toList();
        final avgAttendance = _departmentAttendancePercent(department.id);
        final avgCgpa = _departmentCgpa(department.id);
        return StaticRecord(
          title: department.name,
          subtitle: department.faculty,
          meta: '$studentCount students, $teacherCount teachers',
          status: '$courseCount courses',
          icon: Icons.account_tree_outlined,
          details: {
            'Department code': department.shortName,
            'Head/Chairman': _advisorName(department.id),
            'Teachers': '$teacherCount',
            'Students': '$studentCount',
            'Courses': '$courseCount',
            'Active sections': '${deptSections.length}',
            'Average attendance': '${avgAttendance.round()}%',
            'Average CGPA': avgCgpa.toStringAsFixed(2),
          },
        );
      }).toList(),
    );
  }

  _ModuleDetails _calendarDetails() {
    final rows = [
      ...academicSemesters.map((semester) {
        return StaticRecord(
          title: semester.name,
          subtitle:
              'Registration ${_date(semester.registrationStart)}-${_date(semester.registrationEnd)}, classes from ${_date(semester.classStart)}',
          meta:
              'Final ${_date(semester.finalStart)}-${_date(semester.finalEnd)}',
          status: semester.status,
          icon: Icons.calendar_month_outlined,
          details: {
            'Registration start': _date(semester.registrationStart),
            'Registration end': _date(semester.registrationEnd),
            'Class start': _date(semester.classStart),
            'Midterm period':
                '${_date(semester.midtermStart)} - ${_date(semester.midtermEnd)}',
            'Final exam period':
                '${_date(semester.finalStart)} - ${_date(semester.finalEnd)}',
            'Result publication': _date(semester.resultPublication),
            'Semester status': semester.status,
          },
        );
      }),
      ...calendarEvents.map((event) {
        return StaticRecord(
          title: event.title,
          subtitle: '${event.type} - ${event.audience}',
          meta: _dateRange(event.startDate, event.endDate),
          status: event.status,
          icon: Icons.event_available_outlined,
          details: {
            'Type': event.type,
            'Audience': event.audience,
            'Start': _date(event.startDate),
            'End': _date(event.endDate),
            'Semester':
                academicSemesters
                    .firstWhereOrNull(
                      (semester) => semester.id == event.semesterId,
                    )
                    ?.name ??
                event.semesterId,
          },
        );
      }),
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
          details: {
            'Category': notice.category,
            'Audience': notice.audience ?? notice.target,
            'Publish date': _date(notice.publishedAt),
            'Expiry date': notice.expiryDate == null
                ? 'None'
                : _date(notice.expiryDate!),
            'Priority': notice.priority,
            'Attachment': notice.attachmentName ?? 'None',
            'Status': notice.status,
          },
        );
      }).toList(),
      actions: role == PortalRole.teacher
          ? const ['Publish course notice']
          : role == PortalRole.admin || role == PortalRole.administration
          ? const ['Create notice']
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
    return _ModuleDetails(
      description:
          'Lost and found cases support browse, search/filter, details, claim notes, match/return/close status, and local admin case review.',
      metrics: [
        StaticMetric(
          label: 'Records',
          value: '${lostFoundItems.length}',
          note: 'Campus items',
          icon: Icons.search_outlined,
        ),
        StaticMetric(
          label: 'Open',
          value:
              '${lostFoundItems.where((item) => item.status == 'Open').length}',
          note: 'Need follow-up',
          icon: Icons.pending_actions_outlined,
        ),
      ],
      records: lostFoundItems.map((item) {
        final reporter = accountById(item.reporterId);
        return StaticRecord(
          title: item.title,
          subtitle: item.description,
          meta: '${item.type} at ${item.location}',
          status: item.status,
          icon: item.type == 'Found'
              ? Icons.inventory_2_outlined
              : Icons.search_outlined,
          details: {
            'Reporter': reporter?.fullName ?? item.reporterId,
            'Role': reporter?.role.label ?? 'Unknown',
            'Type': item.type,
            'Location': item.location,
            'Reported': _date(item.reportedAt),
            'Contact': item.contact,
            'Matched item': item.matchedItemId ?? 'None',
            'Claim note': item.claimNote ?? 'No claim note yet',
            'Status': item.status,
          },
        );
      }).toList(),
      actions: currentRole == PortalRole.admin
          ? const ['Mark lost item matched', 'Mark lost item returned']
          : const ['Report lost item', 'Report found item'],
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

  List<StaticRecord> needsAttentionRecords() {
    final attention = <StaticRecord>[
      if (overdueInvoiceCount() > 0)
        StaticRecord(
          title: 'Overdue student invoices',
          subtitle:
              '${overdueInvoiceCount()} invoices have due dates before today.',
          meta: _money(
            invoices
                .where(
                  (invoice) =>
                      invoice.due > 0 &&
                      invoice.dueDate.isBefore(DateTime.now()),
                )
                .fold<num>(0, (total, invoice) => total + invoice.due),
          ),
          status: 'Finance',
          icon: Icons.warning_amber_outlined,
        ),
      StaticRecord(
        title: 'Attendance below threshold',
        subtitle:
            '${studentAccounts.where((student) => studentAttendancePercent(student.id) < 75).length} students are below 75% attendance.',
        meta: '${averageAttendancePercent().round()}% average',
        status: 'Academic',
        icon: Icons.how_to_reg_outlined,
      ),
      StaticRecord(
        title: 'Ungraded submissions',
        subtitle:
            '${submissions.where((submission) => submission.status != 'graded').length} submissions are waiting for grading.',
        meta: 'Teacher workflow',
        status: 'Academic',
        icon: Icons.rate_review_outlined,
      ),
      StaticRecord(
        title: 'Unresolved support tickets',
        subtitle: '${openSupportTickets()} tickets remain open or pending.',
        meta: 'Student service desk',
        status: 'Support',
        icon: Icons.support_agent_outlined,
      ),
      StaticRecord(
        title: 'Forum reports pending',
        subtitle: '${pendingForumReports()} moderation reports need review.',
        meta: 'Community',
        status: 'Moderation',
        icon: Icons.report_outlined,
      ),
      StaticRecord(
        title: 'Results awaiting publication',
        subtitle:
            '${examSchedules.where((exam) => exam.resultPublicationStatus != 'Published').length} exam result workflows are not published.',
        meta: 'Examination office',
        status: 'Exam',
        icon: Icons.publish_outlined,
      ),
      StaticRecord(
        title: 'Sections near capacity',
        subtitle:
            '${sections.where((section) => _sectionEnrollment(section.id) >= section.capacity * 0.9).length} sections are above 90% capacity.',
        meta: currentSemesterName,
        status: 'Academic',
        icon: Icons.class_outlined,
      ),
    ];
    return attention;
  }

  List<StaticRecord> administrationOfficeRecords() {
    return offices.map((office) {
      final head = accountById(office.headId);
      final staffCount = administrationAccounts
          .where((staff) => staff.officeId == office.id)
          .length;
      final requestCount = studentRequests
          .where((request) => request.assignedOfficeId == office.id)
          .length;
      final ticketCount = supportTickets
          .where((ticket) => ticket.assignedOfficeId == office.id)
          .length;
      final openTasks =
          studentRequests.where((request) {
            return request.assignedOfficeId == office.id &&
                !_isClosedStatus(request.status);
          }).length +
          supportTickets.where((ticket) {
            return ticket.assignedOfficeId == office.id &&
                ticket.status != 'closed';
          }).length;
      return StaticRecord(
        title: office.name,
        subtitle: head?.fullName ?? 'Responsible person pending',
        meta: '$staffCount staff, $requestCount requests, $ticketCount tickets',
        status: '$openTasks open tasks',
        icon: Icons.account_balance_outlined,
        details: {
          'Head / responsible person': head?.fullName ?? 'Pending',
          'Staff count': '$staffCount',
          'Open tasks': '$openTasks',
          'Pending requests': '$requestCount',
          'Status': office.status,
          'Responsibilities': office.responsibilities.join(', '),
        },
      );
    }).toList();
  }

  StaticRecord _studentRequestRecord(DemoStudentRequest request) {
    final student = accountById(request.studentId);
    return StaticRecord(
      title: '${request.id} - ${request.type}',
      subtitle: student?.fullName ?? request.studentId,
      meta: '${officeName(request.assignedOfficeId)} - ${request.priority}',
      status: request.status,
      icon: Icons.request_page_outlined,
      details: {
        'Request ID': request.id,
        'Student': student?.fullName ?? request.studentId,
        'Student ID': student?.universityId ?? request.studentId,
        'Type': request.type,
        'Submitted': _date(request.submittedAt),
        'Assigned office': officeName(request.assignedOfficeId),
        'Priority': request.priority,
        'Status': request.status,
        'Notes': request.notes,
        'Timeline': request.timeline.join(' | '),
      },
    );
  }

  StaticRecord _supportTicketRecord(DemoSupportTicket ticket) {
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
      details: {
        'Ticket ID': ticket.id,
        'Created by': requester?.fullName ?? ticket.requesterId,
        'User role': ticket.userRole ?? requester?.role.label ?? '',
        'Assigned office': officeName(ticket.assignedOfficeId),
        'Category': ticket.category,
        'Priority': ticket.priority,
        'Created': _dateTime(ticket.createdAt),
        'Last updated': ticket.lastUpdated == null
            ? 'Not updated'
            : _dateTime(ticket.lastUpdated!),
        'Description': ticket.description,
        'Resolution': ticket.resolution ?? 'Pending',
      },
    );
  }

  StaticRecord _invoiceRecord(DemoInvoice invoice) {
    final student = accountById(invoice.studentId);
    return StaticRecord(
      title: '${invoice.id} - ${student?.fullName ?? invoice.studentId}',
      subtitle: invoice.items.entries
          .map((entry) => '${entry.key}: ${_money(entry.value)}')
          .join(', '),
      meta: '${invoice.semester} - due ${_date(invoice.dueDate)}',
      status: invoice.due <= 0 ? 'Paid' : _money(invoice.due),
      icon: Icons.receipt_long_outlined,
      details: {
        'Invoice': invoice.id,
        'Student': student?.fullName ?? invoice.studentId,
        'Student ID': student?.universityId ?? invoice.studentId,
        'Semester': invoice.semester,
        'Subtotal': _money(invoice.subtotal),
        'Scholarship/Waiver': _money(invoice.waiver),
        'Paid': _money(invoice.paid),
        'Outstanding balance': _money(invoice.due),
        'Due date': _date(invoice.dueDate),
        'Payment status': invoice.due <= 0 ? 'Clear' : 'Outstanding',
      },
    );
  }

  StaticRecord _paymentRecord(DemoPayment payment) {
    final student = accountById(payment.studentId);
    return StaticRecord(
      title: payment.receiptNo,
      subtitle: '${student?.fullName ?? payment.studentId} - ${payment.method}',
      meta: '${_date(payment.paidAt)} - ${payment.invoiceId}',
      status: _money(payment.amount),
      icon: Icons.payments_outlined,
      details: {
        'Transaction ID': payment.id,
        'Student': student?.fullName ?? payment.studentId,
        'Invoice': payment.invoiceId,
        'Date': _dateTime(payment.paidAt),
        'Amount': _money(payment.amount),
        'Method': payment.method,
        'Status': payment.status,
        'Reference': payment.reference ?? payment.receiptNo,
      },
    );
  }

  StaticRecord _examRecord(DemoExamSchedule exam) {
    final course = courseById(exam.courseId);
    final section = sectionById(exam.sectionId);
    final invigilator = accountById(exam.invigilatorId);
    return StaticRecord(
      title: '${exam.examType} - ${course?.code ?? exam.courseId}',
      subtitle:
          '${course?.title ?? 'Course'} ${section?.sectionCode ?? ''} - ${exam.room}',
      meta: '${_date(exam.date)} ${exam.start}-${exam.end}',
      status: exam.resultPublicationStatus,
      icon: Icons.assignment_turned_in_outlined,
      details: {
        'Exam type': exam.examType,
        'Course': '${course?.code ?? ''} ${course?.title ?? ''}',
        'Section': section?.sectionCode ?? exam.sectionId,
        'Room': exam.room,
        'Date': _date(exam.date),
        'Time': '${exam.start} - ${exam.end}',
        'Invigilator': invigilator?.fullName ?? exam.invigilatorId,
        'Admit card status': exam.admitCardStatus,
        'Result submission': exam.resultSubmissionStatus,
        'Result approval': exam.resultApprovalStatus,
        'Result publication': exam.resultPublicationStatus,
        'Supplementary cases': '${exam.supplementaryCases}',
      },
    );
  }

  StaticRecord _forumReportRecord(DemoForumReport report) {
    final post = forumPosts.firstWhereOrNull(
      (item) => item.id == report.postId,
    );
    final author = accountById(post?.authorId);
    final reporter = accountById(report.reporterId);
    final previous = forumReports
        .where((item) => item.postId == report.postId && item.id != report.id)
        .length;
    return StaticRecord(
      title: report.reason,
      subtitle: post?.title ?? report.postId,
      meta:
          '${reporter?.fullName ?? report.reporterId} - ${_date(report.createdAt)}',
      status: report.status,
      icon: Icons.report_outlined,
      details: {
        'Reported content': post?.body ?? 'Post not found',
        'Author': author?.fullName ?? 'Unknown',
        'Reporter': reporter?.fullName ?? report.reporterId,
        'Reason': report.reason,
        'Date': _dateTime(report.createdAt),
        'Previous reports': '$previous',
        'Status': report.status,
        'Available actions':
            'Dismiss Report, Warn User, Hide Content, Remove Content, Resolve',
      },
    );
  }

  StaticRecord _activityRecord(DemoActivity activity) {
    final actor = accountById(activity.actorId);
    return StaticRecord(
      title: activity.title,
      subtitle: activity.detail,
      meta: actor?.fullName ?? 'System',
      status: _dateTime(activity.createdAt),
      icon: Icons.history_outlined,
      details: {
        'Actor': actor?.fullName ?? activity.actorId,
        'Action': activity.title,
        'Target': activity.target ?? 'Local demo record',
        'Timestamp': _dateTime(activity.createdAt),
        'Category': activity.category,
      },
    );
  }

  int _sectionEnrollment(String sectionId) {
    return enrollments
        .where((enrollment) => enrollment.sectionId == sectionId)
        .length;
  }

  String _shortProgramTitle(String title) {
    if (title.contains('Computer Science')) return 'B.Sc. in CSE';
    if (title.contains('Electrical')) return 'B.Sc. in EEE';
    if (title.contains('Civil')) return 'B.Sc. in Civil Engineering';
    if (title.contains('Business Administration') &&
        title.startsWith('Bachelor')) {
      return 'BBA';
    }
    if (title.contains('English')) return 'B.A. in English';
    return title;
  }

  String _advisorName(String departmentId) {
    final teacher = teacherAccounts.firstWhereOrNull(
      (account) => account.departmentId == departmentId,
    );
    return teacher?.fullName ?? 'Department chair pending';
  }

  double _departmentAttendancePercent(String departmentId) {
    final studentIds = studentAccounts
        .where((student) => student.departmentId == departmentId)
        .map((student) => student.id)
        .toSet();
    final rows = attendance
        .where((record) => studentIds.contains(record.studentId))
        .toList();
    if (rows.isEmpty) {
      return 0;
    }
    final attended = rows.where((record) {
      return record.status != DemoAttendanceStatus.absent;
    }).length;
    return attended / rows.length * 100;
  }

  double _departmentCgpa(String departmentId) {
    final studentIds = studentAccounts
        .where((student) => student.departmentId == departmentId)
        .map((student) => student.id)
        .toSet();
    final rows = results
        .where((result) => studentIds.contains(result.studentId))
        .toList();
    return _cgpa(rows);
  }

  String _dateRange(DateTime start, DateTime end) {
    if (_sameDay(start, end)) {
      return _date(start);
    }
    return '${_date(start)} - ${_date(end)}';
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
    offices = _list(snapshot, 'offices', DemoOffice.fromJson);
    departments = _list(snapshot, 'departments', DemoDepartment.fromJson);
    programs = _list(snapshot, 'programs', DemoProgram.fromJson);
    courses = _list(snapshot, 'courses', DemoCourse.fromJson);
    sections = _list(snapshot, 'sections', DemoSection.fromJson);
    academicSemesters = _list(
      snapshot,
      'academicSemesters',
      DemoAcademicSemester.fromJson,
    );
    calendarEvents = _list(
      snapshot,
      'calendarEvents',
      DemoCalendarEvent.fromJson,
    );
    enrollments = _list(snapshot, 'enrollments', DemoEnrollment.fromJson);
    schedules = _list(snapshot, 'schedules', DemoScheduleEntry.fromJson);
    attendance = _list(snapshot, 'attendance', DemoAttendanceRecord.fromJson);
    assignments = _list(snapshot, 'assignments', DemoAssignment.fromJson);
    submissions = _list(snapshot, 'submissions', DemoSubmission.fromJson);
    quizzes = _list(snapshot, 'quizzes', DemoQuiz.fromJson);
    quizAttempts = _list(snapshot, 'quizAttempts', DemoQuizAttempt.fromJson);
    examSchedules = _list(snapshot, 'examSchedules', DemoExamSchedule.fromJson);
    studentRequests = _list(
      snapshot,
      'studentRequests',
      DemoStudentRequest.fromJson,
    );
    admissions = _list(
      snapshot,
      'admissions',
      DemoAdmissionApplication.fromJson,
    );
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
    lostFoundItems = _list(
      snapshot,
      'lostFoundItems',
      DemoLostFoundItem.fromJson,
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
      'offices': offices.map((item) => item.toJson()).toList(),
      'departments': departments.map((item) => item.toJson()).toList(),
      'programs': programs.map((item) => item.toJson()).toList(),
      'courses': courses.map((item) => item.toJson()).toList(),
      'sections': sections.map((item) => item.toJson()).toList(),
      'academicSemesters': academicSemesters
          .map((item) => item.toJson())
          .toList(),
      'calendarEvents': calendarEvents.map((item) => item.toJson()).toList(),
      'enrollments': enrollments.map((item) => item.toJson()).toList(),
      'schedules': schedules.map((item) => item.toJson()).toList(),
      'attendance': attendance.map((item) => item.toJson()).toList(),
      'assignments': assignments.map((item) => item.toJson()).toList(),
      'submissions': submissions.map((item) => item.toJson()).toList(),
      'quizzes': quizzes.map((item) => item.toJson()).toList(),
      'quizAttempts': quizAttempts.map((item) => item.toJson()).toList(),
      'examSchedules': examSchedules.map((item) => item.toJson()).toList(),
      'studentRequests': studentRequests.map((item) => item.toJson()).toList(),
      'admissions': admissions.map((item) => item.toJson()).toList(),
      'notices': notices.map((item) => item.toJson()).toList(),
      'events': events.map((item) => item.toJson()).toList(),
      'eventRegistrations': eventRegistrations
          .map((item) => item.toJson())
          .toList(),
      'clubs': clubs.map((item) => item.toJson()).toList(),
      'clubMemberships': clubMemberships.map((item) => item.toJson()).toList(),
      'lostFoundItems': lostFoundItems.map((item) => item.toJson()).toList(),
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
