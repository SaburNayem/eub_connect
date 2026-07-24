import 'package:eub_connect/feature/home/model/static_feature.dart';

typedef JsonMap = Map<String, dynamic>;

DateTime demoDate(Object? value) {
  if (value is DateTime) {
    return value;
  }
  return DateTime.tryParse(value?.toString() ?? '') ?? DateTime(2026);
}

DateTime? demoNullableDate(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value;
  }
  return DateTime.tryParse(value.toString());
}

PortalRole demoRoleFromCode(String? code) {
  switch ((code ?? '').toLowerCase()) {
    case 'teacher':
      return PortalRole.teacher;
    case 'faculty':
      return PortalRole.faculty;
    case 'admin':
      return PortalRole.admin;
    case 'student':
    default:
      return PortalRole.student;
  }
}

enum DemoAttendanceStatus { present, absent, late, excused }

DemoAttendanceStatus demoAttendanceStatusFromCode(String? code) {
  return DemoAttendanceStatus.values.firstWhere(
    (status) => status.name == (code ?? '').toLowerCase(),
    orElse: () => DemoAttendanceStatus.present,
  );
}

class DemoAccount {
  DemoAccount({
    required this.id,
    required this.universityId,
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
    required this.departmentId,
    this.program,
    this.semester,
    this.section,
    this.batch,
    this.designation,
    this.phone,
    this.address,
    this.emergencyContact,
    this.cgpa,
    this.completedCredits = 0,
    this.currentCredits = 0,
    this.active = true,
  });

  factory DemoAccount.fromJson(JsonMap json) {
    return DemoAccount(
      id: json['id'] as String,
      universityId: json['universityId'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      fullName: json['fullName'] as String,
      role: demoRoleFromCode(json['role'] as String?),
      departmentId: json['departmentId'] as String,
      program: json['program'] as String?,
      semester: json['semester'] as String?,
      section: json['section'] as String?,
      batch: json['batch'] as String?,
      designation: json['designation'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      emergencyContact: json['emergencyContact'] as String?,
      cgpa: json['cgpa'] as num?,
      completedCredits: json['completedCredits'] as int? ?? 0,
      currentCredits: json['currentCredits'] as int? ?? 0,
      active: json['active'] as bool? ?? true,
    );
  }

  final String id;
  final String universityId;
  final String email;
  final String password;
  String fullName;
  PortalRole role;
  String departmentId;
  String? program;
  String? semester;
  String? section;
  String? batch;
  String? designation;
  String? phone;
  String? address;
  String? emergencyContact;
  num? cgpa;
  int completedCredits;
  int currentCredits;
  bool active;

  JsonMap toJson() {
    return {
      'id': id,
      'universityId': universityId,
      'email': email,
      'password': password,
      'fullName': fullName,
      'role': role.code,
      'departmentId': departmentId,
      'program': program,
      'semester': semester,
      'section': section,
      'batch': batch,
      'designation': designation,
      'phone': phone,
      'address': address,
      'emergencyContact': emergencyContact,
      'cgpa': cgpa,
      'completedCredits': completedCredits,
      'currentCredits': currentCredits,
      'active': active,
    };
  }
}

class DemoDepartment {
  const DemoDepartment({
    required this.id,
    required this.name,
    required this.shortName,
    required this.faculty,
  });

  factory DemoDepartment.fromJson(JsonMap json) {
    return DemoDepartment(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      faculty: json['faculty'] as String,
    );
  }

  final String id;
  final String name;
  final String shortName;
  final String faculty;

  JsonMap toJson() {
    return {'id': id, 'name': name, 'shortName': shortName, 'faculty': faculty};
  }
}

class DemoCourse {
  const DemoCourse({
    required this.id,
    required this.departmentId,
    required this.code,
    required this.title,
    required this.credits,
  });

  factory DemoCourse.fromJson(JsonMap json) {
    return DemoCourse(
      id: json['id'] as String,
      departmentId: json['departmentId'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
    );
  }

  final String id;
  final String departmentId;
  final String code;
  final String title;
  final int credits;

  JsonMap toJson() {
    return {
      'id': id,
      'departmentId': departmentId,
      'code': code,
      'title': title,
      'credits': credits,
    };
  }
}

class DemoSection {
  const DemoSection({
    required this.id,
    required this.courseId,
    required this.teacherId,
    required this.sectionCode,
    required this.semester,
    required this.capacity,
  });

  factory DemoSection.fromJson(JsonMap json) {
    return DemoSection(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      teacherId: json['teacherId'] as String,
      sectionCode: json['sectionCode'] as String,
      semester: json['semester'] as String,
      capacity: json['capacity'] as int,
    );
  }

  final String id;
  final String courseId;
  final String teacherId;
  final String sectionCode;
  final String semester;
  final int capacity;

  JsonMap toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'teacherId': teacherId,
      'sectionCode': sectionCode,
      'semester': semester,
      'capacity': capacity,
    };
  }
}

class DemoEnrollment {
  const DemoEnrollment({
    required this.id,
    required this.studentId,
    required this.sectionId,
    required this.status,
  });

  factory DemoEnrollment.fromJson(JsonMap json) {
    return DemoEnrollment(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      sectionId: json['sectionId'] as String,
      status: json['status'] as String? ?? 'enrolled',
    );
  }

  final String id;
  final String studentId;
  final String sectionId;
  final String status;

  JsonMap toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'sectionId': sectionId,
      'status': status,
    };
  }
}

class DemoScheduleEntry {
  const DemoScheduleEntry({
    required this.id,
    required this.sectionId,
    required this.day,
    required this.start,
    required this.end,
    required this.room,
    required this.type,
  });

  factory DemoScheduleEntry.fromJson(JsonMap json) {
    return DemoScheduleEntry(
      id: json['id'] as String,
      sectionId: json['sectionId'] as String,
      day: json['day'] as String,
      start: json['start'] as String,
      end: json['end'] as String,
      room: json['room'] as String,
      type: json['type'] as String,
    );
  }

  final String id;
  final String sectionId;
  final String day;
  final String start;
  final String end;
  final String room;
  final String type;

  JsonMap toJson() {
    return {
      'id': id,
      'sectionId': sectionId,
      'day': day,
      'start': start,
      'end': end,
      'room': room,
      'type': type,
    };
  }
}

class DemoAttendanceRecord {
  DemoAttendanceRecord({
    required this.id,
    required this.sectionId,
    required this.studentId,
    required this.date,
    required this.slot,
    required this.status,
    required this.note,
  });

  factory DemoAttendanceRecord.fromJson(JsonMap json) {
    return DemoAttendanceRecord(
      id: json['id'] as String,
      sectionId: json['sectionId'] as String,
      studentId: json['studentId'] as String,
      date: demoDate(json['date']),
      slot: json['slot'] as String,
      status: demoAttendanceStatusFromCode(json['status'] as String?),
      note: json['note'] as String? ?? '',
    );
  }

  final String id;
  final String sectionId;
  final String studentId;
  final DateTime date;
  final String slot;
  DemoAttendanceStatus status;
  String note;

  JsonMap toJson() {
    return {
      'id': id,
      'sectionId': sectionId,
      'studentId': studentId,
      'date': date.toIso8601String(),
      'slot': slot,
      'status': status.name,
      'note': note,
    };
  }
}

class DemoAssignment {
  DemoAssignment({
    required this.id,
    required this.sectionId,
    required this.teacherId,
    required this.title,
    required this.instructions,
    required this.totalMarks,
    required this.publishedAt,
    required this.dueAt,
    required this.status,
    this.attachments = const [],
    this.allowResubmission = true,
  });

  factory DemoAssignment.fromJson(JsonMap json) {
    return DemoAssignment(
      id: json['id'] as String,
      sectionId: json['sectionId'] as String,
      teacherId: json['teacherId'] as String,
      title: json['title'] as String,
      instructions: json['instructions'] as String,
      totalMarks: json['totalMarks'] as num,
      publishedAt: demoDate(json['publishedAt']),
      dueAt: demoDate(json['dueAt']),
      status: json['status'] as String? ?? 'published',
      attachments: List<String>.from(json['attachments'] as List? ?? const []),
      allowResubmission: json['allowResubmission'] as bool? ?? true,
    );
  }

  final String id;
  final String sectionId;
  final String teacherId;
  String title;
  String instructions;
  num totalMarks;
  DateTime publishedAt;
  DateTime dueAt;
  String status;
  List<String> attachments;
  bool allowResubmission;

  JsonMap toJson() {
    return {
      'id': id,
      'sectionId': sectionId,
      'teacherId': teacherId,
      'title': title,
      'instructions': instructions,
      'totalMarks': totalMarks,
      'publishedAt': publishedAt.toIso8601String(),
      'dueAt': dueAt.toIso8601String(),
      'status': status,
      'attachments': attachments,
      'allowResubmission': allowResubmission,
    };
  }
}

class DemoSubmission {
  DemoSubmission({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.note,
    required this.fileName,
    required this.status,
    this.submittedAt,
    this.marks,
    this.feedback,
  });

  factory DemoSubmission.fromJson(JsonMap json) {
    return DemoSubmission(
      id: json['id'] as String,
      assignmentId: json['assignmentId'] as String,
      studentId: json['studentId'] as String,
      note: json['note'] as String? ?? '',
      fileName: json['fileName'] as String? ?? '',
      status: json['status'] as String? ?? 'submitted',
      submittedAt: demoNullableDate(json['submittedAt']),
      marks: json['marks'] as num?,
      feedback: json['feedback'] as String?,
    );
  }

  final String id;
  final String assignmentId;
  final String studentId;
  String note;
  String fileName;
  String status;
  DateTime? submittedAt;
  num? marks;
  String? feedback;

  JsonMap toJson() {
    return {
      'id': id,
      'assignmentId': assignmentId,
      'studentId': studentId,
      'note': note,
      'fileName': fileName,
      'status': status,
      'submittedAt': submittedAt?.toIso8601String(),
      'marks': marks,
      'feedback': feedback,
    };
  }
}

class DemoQuizOption {
  const DemoQuizOption({required this.id, required this.text});

  factory DemoQuizOption.fromJson(JsonMap json) {
    return DemoQuizOption(
      id: json['id'] as String,
      text: json['text'] as String,
    );
  }

  final String id;
  final String text;

  JsonMap toJson() => {'id': id, 'text': text};
}

class DemoQuizQuestion {
  const DemoQuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionId,
    required this.marks,
  });

  factory DemoQuizQuestion.fromJson(JsonMap json) {
    return DemoQuizQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List? ?? const [])
          .whereType<Map>()
          .map(
            (item) => DemoQuizOption.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
      correctOptionId: json['correctOptionId'] as String,
      marks: json['marks'] as num,
    );
  }

  final String id;
  final String question;
  final List<DemoQuizOption> options;
  final String correctOptionId;
  final num marks;

  JsonMap toJson() {
    return {
      'id': id,
      'question': question,
      'options': options.map((option) => option.toJson()).toList(),
      'correctOptionId': correctOptionId,
      'marks': marks,
    };
  }
}

class DemoQuiz {
  DemoQuiz({
    required this.id,
    required this.sectionId,
    required this.teacherId,
    required this.title,
    required this.instructions,
    required this.totalMarks,
    required this.durationMinutes,
    required this.opensAt,
    required this.closesAt,
    required this.status,
    required this.questions,
    this.attemptLimit = 2,
    this.showResultImmediately = true,
  });

  factory DemoQuiz.fromJson(JsonMap json) {
    return DemoQuiz(
      id: json['id'] as String,
      sectionId: json['sectionId'] as String,
      teacherId: json['teacherId'] as String,
      title: json['title'] as String,
      instructions: json['instructions'] as String,
      totalMarks: json['totalMarks'] as num,
      durationMinutes: json['durationMinutes'] as int,
      opensAt: demoDate(json['opensAt']),
      closesAt: demoDate(json['closesAt']),
      status: json['status'] as String? ?? 'published',
      questions: (json['questions'] as List? ?? const [])
          .whereType<Map>()
          .map(
            (item) =>
                DemoQuizQuestion.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
      attemptLimit: json['attemptLimit'] as int? ?? 2,
      showResultImmediately: json['showResultImmediately'] as bool? ?? true,
    );
  }

  final String id;
  final String sectionId;
  final String teacherId;
  String title;
  String instructions;
  num totalMarks;
  int durationMinutes;
  DateTime opensAt;
  DateTime closesAt;
  String status;
  List<DemoQuizQuestion> questions;
  int attemptLimit;
  bool showResultImmediately;

  JsonMap toJson() {
    return {
      'id': id,
      'sectionId': sectionId,
      'teacherId': teacherId,
      'title': title,
      'instructions': instructions,
      'totalMarks': totalMarks,
      'durationMinutes': durationMinutes,
      'opensAt': opensAt.toIso8601String(),
      'closesAt': closesAt.toIso8601String(),
      'status': status,
      'questions': questions.map((question) => question.toJson()).toList(),
      'attemptLimit': attemptLimit,
      'showResultImmediately': showResultImmediately,
    };
  }
}

class DemoQuizAttempt {
  DemoQuizAttempt({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.status,
    this.submittedAt,
    this.score,
    this.answers = const {},
  });

  factory DemoQuizAttempt.fromJson(JsonMap json) {
    return DemoQuizAttempt(
      id: json['id'] as String,
      quizId: json['quizId'] as String,
      studentId: json['studentId'] as String,
      status: json['status'] as String? ?? 'submitted',
      submittedAt: demoNullableDate(json['submittedAt']),
      score: json['score'] as num?,
      answers: Map<String, String>.from(json['answers'] as Map? ?? const {}),
    );
  }

  final String id;
  final String quizId;
  final String studentId;
  String status;
  DateTime? submittedAt;
  num? score;
  Map<String, String> answers;

  JsonMap toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'studentId': studentId,
      'status': status,
      'submittedAt': submittedAt?.toIso8601String(),
      'score': score,
      'answers': answers,
    };
  }
}

class DemoNotice {
  DemoNotice({
    required this.id,
    required this.title,
    required this.body,
    required this.authorId,
    required this.target,
    required this.publishedAt,
    this.sectionId,
  });

  factory DemoNotice.fromJson(JsonMap json) {
    return DemoNotice(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      authorId: json['authorId'] as String,
      target: json['target'] as String,
      publishedAt: demoDate(json['publishedAt']),
      sectionId: json['sectionId'] as String?,
    );
  }

  final String id;
  String title;
  String body;
  final String authorId;
  String target;
  DateTime publishedAt;
  String? sectionId;

  JsonMap toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'authorId': authorId,
      'target': target,
      'publishedAt': publishedAt.toIso8601String(),
      'sectionId': sectionId,
    };
  }
}

class DemoEvent {
  DemoEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.venue,
    required this.organizer,
    required this.capacity,
    required this.status,
  });

  factory DemoEvent.fromJson(JsonMap json) {
    return DemoEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: demoDate(json['date']),
      venue: json['venue'] as String,
      organizer: json['organizer'] as String,
      capacity: json['capacity'] as int,
      status: json['status'] as String? ?? 'published',
    );
  }

  final String id;
  String title;
  String description;
  DateTime date;
  String venue;
  String organizer;
  int capacity;
  String status;

  JsonMap toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'venue': venue,
      'organizer': organizer,
      'capacity': capacity,
      'status': status,
    };
  }
}

class DemoEventRegistration {
  DemoEventRegistration({
    required this.id,
    required this.eventId,
    required this.studentId,
    required this.registeredAt,
    required this.status,
  });

  factory DemoEventRegistration.fromJson(JsonMap json) {
    return DemoEventRegistration(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      studentId: json['studentId'] as String,
      registeredAt: demoDate(json['registeredAt']),
      status: json['status'] as String? ?? 'registered',
    );
  }

  final String id;
  final String eventId;
  final String studentId;
  DateTime registeredAt;
  String status;

  JsonMap toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'studentId': studentId,
      'registeredAt': registeredAt.toIso8601String(),
      'status': status,
    };
  }
}

class DemoClub {
  DemoClub({
    required this.id,
    required this.name,
    required this.description,
    required this.advisorId,
    required this.presidentId,
  });

  factory DemoClub.fromJson(JsonMap json) {
    return DemoClub(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      advisorId: json['advisorId'] as String,
      presidentId: json['presidentId'] as String,
    );
  }

  final String id;
  String name;
  String description;
  String advisorId;
  String presidentId;

  JsonMap toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'advisorId': advisorId,
      'presidentId': presidentId,
    };
  }
}

class DemoClubMembership {
  DemoClubMembership({
    required this.id,
    required this.clubId,
    required this.studentId,
    required this.status,
    required this.joinedAt,
  });

  factory DemoClubMembership.fromJson(JsonMap json) {
    return DemoClubMembership(
      id: json['id'] as String,
      clubId: json['clubId'] as String,
      studentId: json['studentId'] as String,
      status: json['status'] as String? ?? 'active',
      joinedAt: demoDate(json['joinedAt']),
    );
  }

  final String id;
  final String clubId;
  final String studentId;
  String status;
  DateTime joinedAt;

  JsonMap toJson() {
    return {
      'id': id,
      'clubId': clubId,
      'studentId': studentId,
      'status': status,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}

class DemoForumCategory {
  const DemoForumCategory({required this.id, required this.name});

  factory DemoForumCategory.fromJson(JsonMap json) {
    return DemoForumCategory(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  final String id;
  final String name;

  JsonMap toJson() => {'id': id, 'name': name};
}

class DemoForumPost {
  DemoForumPost({
    required this.id,
    required this.categoryId,
    required this.authorId,
    required this.title,
    required this.body,
    required this.createdAt,
    this.reactions = 0,
    this.hidden = false,
  });

  factory DemoForumPost.fromJson(JsonMap json) {
    return DemoForumPost(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      authorId: json['authorId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: demoDate(json['createdAt']),
      reactions: json['reactions'] as int? ?? 0,
      hidden: json['hidden'] as bool? ?? false,
    );
  }

  final String id;
  String categoryId;
  final String authorId;
  String title;
  String body;
  DateTime createdAt;
  int reactions;
  bool hidden;

  JsonMap toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'authorId': authorId,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'reactions': reactions,
      'hidden': hidden,
    };
  }
}

class DemoForumComment {
  DemoForumComment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.body,
    required this.createdAt,
    this.parentId,
    this.hidden = false,
  });

  factory DemoForumComment.fromJson(JsonMap json) {
    return DemoForumComment(
      id: json['id'] as String,
      postId: json['postId'] as String,
      authorId: json['authorId'] as String,
      body: json['body'] as String,
      createdAt: demoDate(json['createdAt']),
      parentId: json['parentId'] as String?,
      hidden: json['hidden'] as bool? ?? false,
    );
  }

  final String id;
  final String postId;
  final String authorId;
  String body;
  DateTime createdAt;
  String? parentId;
  bool hidden;

  JsonMap toJson() {
    return {
      'id': id,
      'postId': postId,
      'authorId': authorId,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'parentId': parentId,
      'hidden': hidden,
    };
  }
}

class DemoForumReport {
  DemoForumReport({
    required this.id,
    required this.postId,
    required this.reporterId,
    required this.reason,
    required this.status,
    required this.createdAt,
    this.commentId,
  });

  factory DemoForumReport.fromJson(JsonMap json) {
    return DemoForumReport(
      id: json['id'] as String,
      postId: json['postId'] as String,
      reporterId: json['reporterId'] as String,
      reason: json['reason'] as String,
      status: json['status'] as String? ?? 'pending',
      createdAt: demoDate(json['createdAt']),
      commentId: json['commentId'] as String?,
    );
  }

  final String id;
  final String postId;
  final String reporterId;
  String reason;
  String status;
  DateTime createdAt;
  String? commentId;

  JsonMap toJson() {
    return {
      'id': id,
      'postId': postId,
      'reporterId': reporterId,
      'reason': reason,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'commentId': commentId,
    };
  }
}

class DemoSupportTicket {
  DemoSupportTicket({
    required this.id,
    required this.requesterId,
    required this.subject,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdAt,
  });

  factory DemoSupportTicket.fromJson(JsonMap json) {
    return DemoSupportTicket(
      id: json['id'] as String,
      requesterId: json['requesterId'] as String,
      subject: json['subject'] as String,
      category: json['category'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String? ?? 'open',
      createdAt: demoDate(json['createdAt']),
    );
  }

  final String id;
  final String requesterId;
  String subject;
  String category;
  String priority;
  String status;
  DateTime createdAt;

  JsonMap toJson() {
    return {
      'id': id,
      'requesterId': requesterId,
      'subject': subject,
      'category': category,
      'priority': priority,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class DemoSupportMessage {
  DemoSupportMessage({
    required this.id,
    required this.ticketId,
    required this.authorId,
    required this.message,
    required this.createdAt,
  });

  factory DemoSupportMessage.fromJson(JsonMap json) {
    return DemoSupportMessage(
      id: json['id'] as String,
      ticketId: json['ticketId'] as String,
      authorId: json['authorId'] as String,
      message: json['message'] as String,
      createdAt: demoDate(json['createdAt']),
    );
  }

  final String id;
  final String ticketId;
  final String authorId;
  String message;
  DateTime createdAt;

  JsonMap toJson() {
    return {
      'id': id,
      'ticketId': ticketId,
      'authorId': authorId,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class DemoInvoice {
  DemoInvoice({
    required this.id,
    required this.studentId,
    required this.semester,
    required this.items,
    required this.waiver,
    required this.paid,
    required this.dueDate,
  });

  factory DemoInvoice.fromJson(JsonMap json) {
    return DemoInvoice(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      semester: json['semester'] as String,
      items: Map<String, num>.from(json['items'] as Map? ?? const {}),
      waiver: json['waiver'] as num? ?? 0,
      paid: json['paid'] as num? ?? 0,
      dueDate: demoDate(json['dueDate']),
    );
  }

  final String id;
  final String studentId;
  String semester;
  Map<String, num> items;
  num waiver;
  num paid;
  DateTime dueDate;

  num get subtotal =>
      items.values.fold<num>(0, (total, value) => total + value);
  num get total => subtotal - waiver;
  num get due => total - paid;

  JsonMap toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'semester': semester,
      'items': items,
      'waiver': waiver,
      'paid': paid,
      'dueDate': dueDate.toIso8601String(),
    };
  }
}

class DemoPayment {
  DemoPayment({
    required this.id,
    required this.invoiceId,
    required this.studentId,
    required this.amount,
    required this.method,
    required this.paidAt,
    required this.receiptNo,
  });

  factory DemoPayment.fromJson(JsonMap json) {
    return DemoPayment(
      id: json['id'] as String,
      invoiceId: json['invoiceId'] as String,
      studentId: json['studentId'] as String,
      amount: json['amount'] as num,
      method: json['method'] as String,
      paidAt: demoDate(json['paidAt']),
      receiptNo: json['receiptNo'] as String,
    );
  }

  final String id;
  final String invoiceId;
  final String studentId;
  num amount;
  String method;
  DateTime paidAt;
  String receiptNo;

  JsonMap toJson() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'studentId': studentId,
      'amount': amount,
      'method': method,
      'paidAt': paidAt.toIso8601String(),
      'receiptNo': receiptNo,
    };
  }
}

class DemoResult {
  const DemoResult({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.semester,
    required this.marks,
    required this.letterGrade,
    required this.gradePoint,
  });

  factory DemoResult.fromJson(JsonMap json) {
    return DemoResult(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      courseId: json['courseId'] as String,
      semester: json['semester'] as String,
      marks: json['marks'] as num,
      letterGrade: json['letterGrade'] as String,
      gradePoint: json['gradePoint'] as num,
    );
  }

  final String id;
  final String studentId;
  final String courseId;
  final String semester;
  final num marks;
  final String letterGrade;
  final num gradePoint;

  JsonMap toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'semester': semester,
      'marks': marks,
      'letterGrade': letterGrade,
      'gradePoint': gradePoint,
    };
  }
}

class DemoScholarship {
  DemoScholarship({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.eligibility,
    required this.status,
  });

  factory DemoScholarship.fromJson(JsonMap json) {
    return DemoScholarship(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      deadline: demoDate(json['deadline']),
      eligibility: json['eligibility'] as String,
      status: json['status'] as String? ?? 'open',
    );
  }

  final String id;
  String title;
  String description;
  DateTime deadline;
  String eligibility;
  String status;

  JsonMap toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'eligibility': eligibility,
      'status': status,
    };
  }
}

class DemoNotification {
  DemoNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
  });

  factory DemoNotification.fromJson(JsonMap json) {
    return DemoNotification(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: demoDate(json['createdAt']),
      read: json['read'] as bool? ?? false,
    );
  }

  final String id;
  final String userId;
  String title;
  String body;
  DateTime createdAt;
  bool read;

  JsonMap toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'read': read,
    };
  }
}

class DemoApproval {
  DemoApproval({
    required this.id,
    required this.type,
    required this.title,
    required this.requesterId,
    required this.status,
    required this.createdAt,
  });

  factory DemoApproval.fromJson(JsonMap json) {
    return DemoApproval(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      requesterId: json['requesterId'] as String,
      status: json['status'] as String? ?? 'pending',
      createdAt: demoDate(json['createdAt']),
    );
  }

  final String id;
  String type;
  String title;
  String requesterId;
  String status;
  DateTime createdAt;

  JsonMap toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'requesterId': requesterId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class DemoActivity {
  DemoActivity({
    required this.id,
    required this.actorId,
    required this.title,
    required this.detail,
    required this.createdAt,
  });

  factory DemoActivity.fromJson(JsonMap json) {
    return DemoActivity(
      id: json['id'] as String,
      actorId: json['actorId'] as String,
      title: json['title'] as String,
      detail: json['detail'] as String,
      createdAt: demoDate(json['createdAt']),
    );
  }

  final String id;
  final String actorId;
  String title;
  String detail;
  DateTime createdAt;

  JsonMap toJson() {
    return {
      'id': id,
      'actorId': actorId,
      'title': title,
      'detail': detail,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
