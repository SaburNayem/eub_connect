import 'package:flutter/material.dart';

enum PortalRole { student, teacher, faculty, admin }

extension PortalRoleDetails on PortalRole {
  String get code {
    switch (this) {
      case PortalRole.student:
        return 'student';
      case PortalRole.teacher:
        return 'teacher';
      case PortalRole.faculty:
        return 'faculty';
      case PortalRole.admin:
        return 'admin';
    }
  }

  String get label {
    switch (this) {
      case PortalRole.student:
        return 'Student';
      case PortalRole.teacher:
        return 'Teacher';
      case PortalRole.faculty:
        return 'Faculty';
      case PortalRole.admin:
        return 'Admin';
    }
  }

  String get subtitle {
    switch (this) {
      case PortalRole.student:
        return 'Courses, attendance, results, fees, support';
      case PortalRole.teacher:
        return 'Teaching, attendance, grading, notices';
      case PortalRole.faculty:
        return 'Departments, teachers, students, reports';
      case PortalRole.admin:
        return 'Users, roles, approvals, audit, settings';
    }
  }

  IconData get icon {
    switch (this) {
      case PortalRole.student:
        return Icons.person_outline;
      case PortalRole.teacher:
        return Icons.co_present_outlined;
      case PortalRole.faculty:
        return Icons.business_center_outlined;
      case PortalRole.admin:
        return Icons.admin_panel_settings_outlined;
    }
  }

  Color get color {
    switch (this) {
      case PortalRole.student:
        return const Color(0xFF2A2D7E);
      case PortalRole.teacher:
        return const Color(0xFF007F3D);
      case PortalRole.faculty:
        return const Color(0xFF8B5E00);
      case PortalRole.admin:
        return const Color(0xFFB42318);
    }
  }
}

class StaticMetric {
  const StaticMetric({
    required this.label,
    required this.value,
    required this.note,
    required this.icon,
  });

  final String label;
  final String value;
  final String note;
  final IconData icon;
}

class StaticRecord {
  const StaticRecord({
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.status,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String meta;
  final String status;
  final IconData icon;
}

class StaticFeature {
  const StaticFeature({
    required this.title,
    required this.category,
    required this.description,
    required this.icon,
    required this.accent,
    required this.access,
    this.metrics = const [],
    this.actions = const [],
    this.records = const [],
  });

  final String title;
  final String category;
  final String description;
  final IconData icon;
  final Color accent;
  final List<PortalRole> access;
  final List<StaticMetric> metrics;
  final List<String> actions;
  final List<StaticRecord> records;
}

class DashboardProfile {
  const DashboardProfile({
    required this.role,
    required this.headline,
    required this.summary,
    this.metrics = const [],
    this.priorities = const [],
    this.schedule = const [],
  });

  final PortalRole role;
  final String headline;
  final String summary;
  final List<StaticMetric> metrics;
  final List<StaticRecord> priorities;
  final List<StaticRecord> schedule;
}

class FeatureModuleModel {
  const FeatureModuleModel({
    required this.title,
    this.category = 'Feature',
    this.description,
    this.icon,
    this.accent = const Color(0xFF2A2D7E),
    this.access = allPortalRoles,
    this.metrics,
    this.actions,
    this.records,
  });

  final String title;
  final String category;
  final String? description;
  final IconData? icon;
  final Color accent;
  final List<PortalRole> access;
  final List<StaticMetric>? metrics;
  final List<String>? actions;
  final List<StaticRecord>? records;

  StaticFeature get feature {
    return moduleFeature(
      title: title,
      category: category,
      description: description,
      icon: icon,
      accent: accent,
      access: access,
    );
  }
}

StaticFeature moduleFeature({
  required String title,
  String category = 'Feature',
  String? description,
  IconData? icon,
  Color accent = const Color(0xFF2A2D7E),
  List<PortalRole> access = allPortalRoles,
}) {
  for (final feature in staticFeatures) {
    if (feature.title == title) {
      return feature;
    }
  }

  return StaticFeature(
    title: title,
    category: category,
    description:
        description ??
        'This feature uses the shared local demo university dataset and can be replaced by a repository/API later.',
    icon: icon ?? moduleFallbackIcon(title),
    accent: accent,
    access: access,
  );
}

IconData moduleFallbackIcon(String title) {
  final lower = title.toLowerCase();
  if (lower.contains('teacher')) return Icons.co_present_outlined;
  if (lower.contains('student')) return Icons.person_outline;
  if (lower.contains('payment') || lower.contains('fee')) {
    return Icons.payments_outlined;
  }
  if (lower.contains('notice')) return Icons.campaign_outlined;
  if (lower.contains('routine') || lower.contains('calendar')) {
    return Icons.calendar_month_outlined;
  }
  if (lower.contains('attendance')) return Icons.how_to_reg_outlined;
  if (lower.contains('result') || lower.contains('report')) {
    return Icons.analytics_outlined;
  }
  if (lower.contains('department')) return Icons.account_tree_outlined;
  if (lower.contains('role')) return Icons.manage_accounts_outlined;
  if (lower.contains('event')) return Icons.event_outlined;
  if (lower.contains('setting')) return Icons.settings_outlined;
  return Icons.dashboard_customize_outlined;
}

const allPortalRoles = [
  PortalRole.student,
  PortalRole.teacher,
  PortalRole.faculty,
  PortalRole.admin,
];

const studentAccess = [PortalRole.student, PortalRole.admin];
const teacherAccess = [
  PortalRole.teacher,
  PortalRole.faculty,
  PortalRole.admin,
];
const facultyAccess = [PortalRole.faculty, PortalRole.admin];
const adminAccess = [PortalRole.admin];

const dashboardProfiles = [
  DashboardProfile(
    role: PortalRole.student,
    headline: 'Student workspace',
    summary:
        'Courses, routine, attendance, assignments, results, fees, and support.',
  ),
  DashboardProfile(
    role: PortalRole.teacher,
    headline: 'Teacher workspace',
    summary:
        'Assigned sections, attendance, assignments, quizzes, materials, and grading.',
  ),
  DashboardProfile(
    role: PortalRole.faculty,
    headline: 'Faculty workspace',
    summary:
        'Departments, courses, teachers, students, schedules, results, and reports.',
  ),
  DashboardProfile(
    role: PortalRole.admin,
    headline: 'Admin workspace',
    summary:
        'Users, roles, approvals, audit logs, moderation, configuration, and oversight.',
  ),
];

const staticFeatures = [
  StaticFeature(
    title: 'Authentication',
    category: 'Core',
    description:
        'Demo sign in, registration, session restore, role assignment, and account security.',
    icon: Icons.login_outlined,
    accent: Color(0xFF2A2D7E),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Student Portal',
    category: 'Portal',
    description:
        'Student profile, courses, attendance, assignments, results, invoices, notices, and support.',
    icon: Icons.person_outline,
    accent: Color(0xFF007F3D),
    access: studentAccess,
  ),
  StaticFeature(
    title: 'Teacher Portal',
    category: 'Portal',
    description:
        'Teacher dashboard for assigned courses, class work, attendance, materials, notices, and grading.',
    icon: Icons.co_present_outlined,
    accent: Color(0xFF8B5E00),
    access: teacherAccess,
  ),
  StaticFeature(
    title: 'Faculty Portal',
    category: 'Portal',
    description:
        'Faculty oversight for departments, academic records, teachers, students, schedules, and reports.',
    icon: Icons.business_center_outlined,
    accent: Color(0xFF0F766E),
    access: facultyAccess,
  ),
  StaticFeature(
    title: 'Administration Panel',
    category: 'Admin',
    description:
        'System administration for users, roles, approvals, moderation, audit logs, and settings.',
    icon: Icons.admin_panel_settings_outlined,
    accent: Color(0xFFB42318),
    access: adminAccess,
  ),
  StaticFeature(
    title: 'Departments',
    category: 'Academic',
    description: 'Published faculties, departments, programs, and contacts.',
    icon: Icons.account_tree_outlined,
    accent: Color(0xFF2A2D7E),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Department Management',
    category: 'Faculty',
    description: 'Department, program, head, contact, and status management.',
    icon: Icons.account_balance_outlined,
    accent: Color(0xFF0F766E),
    access: facultyAccess,
  ),
  StaticFeature(
    title: 'Teacher Management',
    category: 'Faculty',
    description:
        'Teacher directory, department assignment, workload, and verification.',
    icon: Icons.co_present_outlined,
    accent: Color(0xFF0F766E),
    access: facultyAccess,
  ),
  StaticFeature(
    title: 'Student Management',
    category: 'Faculty',
    description:
        'Student records, enrollment, advising, attendance, and academic standing.',
    icon: Icons.groups_outlined,
    accent: Color(0xFF0F766E),
    access: facultyAccess,
  ),
  StaticFeature(
    title: 'Events',
    category: 'Campus',
    description:
        'Event browsing, registration, creator workflow, approval, and moderation.',
    icon: Icons.event_outlined,
    accent: Color(0xFF007F3D),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Routine Management',
    category: 'Academic',
    description:
        'Class schedule creation, publication, and conflict detection for rooms, teachers, and sections.',
    icon: Icons.calendar_month_outlined,
    accent: Color(0xFF2A2D7E),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Class Routine',
    category: 'Student',
    description:
        'Student weekly and daily routine for enrolled course sections.',
    icon: Icons.schedule_outlined,
    accent: Color(0xFF0EA5E9),
    access: studentAccess,
  ),
  StaticFeature(
    title: 'Academic Calendar',
    category: 'Academic',
    description:
        'Published semester dates, holidays, exams, registration, and deadlines.',
    icon: Icons.calendar_today_outlined,
    accent: Color(0xFF2A2D7E),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Lost and Found',
    category: 'Campus',
    description:
        'Lost or found item submission, claims, status tracking, and moderation.',
    icon: Icons.search_outlined,
    accent: Color(0xFF007F3D),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Notice Board',
    category: 'Campus',
    description:
        'Database-backed notices with audience targeting, publication, expiry, and attachments.',
    icon: Icons.campaign_outlined,
    accent: Color(0xFF007F3D),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Assignments',
    category: 'Academic',
    description:
        'Assignments, resources, submissions, grading, feedback, deadlines, and resubmission rules.',
    icon: Icons.assignment_outlined,
    accent: Color(0xFF4F46E5),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Attendance',
    category: 'Academic',
    description:
        'Attendance sessions and calculated present, absent, late, excused, and course percentages.',
    icon: Icons.how_to_reg_outlined,
    accent: Color(0xFF16A34A),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Student Notices',
    category: 'Teacher',
    description:
        'Teacher-created notices targeted to assigned courses and sections.',
    icon: Icons.notification_add_outlined,
    accent: Color(0xFF8B5E00),
    access: teacherAccess,
  ),
  StaticFeature(
    title: 'Lecture Materials',
    category: 'Teacher',
    description:
        'Course material upload, storage, topic tagging, and enrolled-student access.',
    icon: Icons.folder_copy_outlined,
    accent: Color(0xFF8B5E00),
    access: teacherAccess,
  ),
  StaticFeature(
    title: 'Academic Report',
    category: 'Teacher',
    description:
        'Academic reports generated from attendance, marks, results, and course records.',
    icon: Icons.analytics_outlined,
    accent: Color(0xFF8B5E00),
    access: teacherAccess,
  ),
  StaticFeature(
    title: 'Marks Result',
    category: 'Teacher',
    description:
        'Assessment marks entry, validation, result workflow, and release control.',
    icon: Icons.grade_outlined,
    accent: Color(0xFF8B5E00),
    access: teacherAccess,
  ),
  StaticFeature(
    title: 'Community Forum',
    category: 'Communication',
    description:
        'Club community, posts, comments, reactions, reports, and moderation.',
    icon: Icons.groups_2_outlined,
    accent: Color(0xFF0D9488),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Discussion Board',
    category: 'Communication',
    description:
        'Forum categories, posts, replies, reactions, reports, pagination, and moderation.',
    icon: Icons.forum_outlined,
    accent: Color(0xFF0D9488),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Tuition Fees',
    category: 'Finance',
    description:
        'Tuition invoices, waivers, previous balance, paid amount, due amount, and deadline.',
    icon: Icons.payments_outlined,
    accent: Color(0xFFCA8A04),
    access: studentAccess,
  ),
  StaticFeature(
    title: 'Scholarships',
    category: 'Finance',
    description:
        'Scholarship opportunities, eligibility, deadlines, applications, and review status.',
    icon: Icons.workspace_premium_outlined,
    accent: Color(0xFFCA8A04),
    access: studentAccess,
  ),
  StaticFeature(
    title: 'Quiz System',
    category: 'Academic',
    description:
        'Teacher-created quizzes, questions, options, attempts, scoring, and result visibility.',
    icon: Icons.quiz_outlined,
    accent: Color(0xFF4F46E5),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Results',
    category: 'Academic',
    description:
        'Released academic results, course grades, semester GPA, and CGPA from stored records.',
    icon: Icons.assessment_outlined,
    accent: Color(0xFF16A34A),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Payment History',
    category: 'Finance',
    description:
        'Payment transactions, invoice references, receipts, methods, and status.',
    icon: Icons.receipt_long_outlined,
    accent: Color(0xFFCA8A04),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'User Roles',
    category: 'Admin',
    description:
        'Protected role assignment, activation, deactivation, role-change review, and audit logging.',
    icon: Icons.manage_accounts_outlined,
    accent: Color(0xFFB42318),
    access: adminAccess,
  ),
  StaticFeature(
    title: 'System Activity',
    category: 'Admin',
    description:
        'Paginated audit logs for role changes, moderation, publishing, attendance, and financial actions.',
    icon: Icons.history_outlined,
    accent: Color(0xFFB42318),
    access: adminAccess,
  ),
  StaticFeature(
    title: 'Notifications',
    category: 'Core',
    description:
        'Unread notifications, delivery state, and user notification preferences.',
    icon: Icons.notifications_outlined,
    accent: Color(0xFF2A2D7E),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Profile',
    category: 'Core',
    description:
        'Authenticated user profile, permitted edits, contact details, and photo.',
    icon: Icons.account_circle_outlined,
    accent: Color(0xFF2A2D7E),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Settings',
    category: 'Core',
    description:
        'Persisted theme, notification, account, and security preferences.',
    icon: Icons.settings_outlined,
    accent: Color(0xFF475569),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Student Support',
    category: 'Campus',
    description:
        'Support tickets, priority, categories, messages, attachments, and status tracking.',
    icon: Icons.support_agent_outlined,
    accent: Color(0xFF007F3D),
    access: allPortalRoles,
  ),
  StaticFeature(
    title: 'Semester Courses',
    category: 'Academic',
    description:
        'Registered semester courses, sections, teachers, credits, prerequisites, and enrollment state.',
    icon: Icons.menu_book_outlined,
    accent: Color(0xFF0EA5E9),
    access: allPortalRoles,
  ),
];
