import 'package:flutter/material.dart';

enum PortalRole { student, teacher, faculty, admin }

extension PortalRoleDetails on PortalRole {
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
        return 'Classes, dues, results, support';
      case PortalRole.teacher:
        return 'Courses, attendance, notices';
      case PortalRole.faculty:
        return 'Departments, teachers, reports';
      case PortalRole.admin:
        return 'Roles, approvals, system activity';
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
    required this.metrics,
    required this.actions,
    required this.records,
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
    required this.metrics,
    required this.priorities,
    required this.schedule,
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
      metrics: metrics,
      actions: actions,
      records: records,
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
  List<StaticMetric>? metrics,
  List<String>? actions,
  List<StaticRecord>? records,
}) {
  for (final feature in staticFeatures) {
    if (feature.title == title) {
      return feature;
    }
  }

  final moduleIcon = icon ?? moduleFallbackIcon(title);

  return StaticFeature(
    title: title,
    category: category,
    description:
        description ??
        'Review $title information, reports, and status for EUB Connect.',
    icon: moduleIcon,
    accent: accent,
    access: access,
    metrics:
        metrics ??
        const [
          StaticMetric(
            label: 'Items',
            value: '24',
            note: 'Static entries',
            icon: Icons.folder_copy_outlined,
          ),
          StaticMetric(
            label: 'Pending',
            value: '6',
            note: 'Needs review',
            icon: Icons.pending_actions_outlined,
          ),
          StaticMetric(
            label: 'Complete',
            value: '18',
            note: 'This semester',
            icon: Icons.task_alt_outlined,
          ),
        ],
    actions: actions ?? const ['Create item', 'Review list', 'Export report'],
    records:
        records ??
        [
          StaticRecord(
            title: '$title overview',
            subtitle: 'Core information is ready for review',
            meta: 'EUB Connect',
            status: 'Ready',
            icon: moduleIcon,
          ),
          const StaticRecord(
            title: 'Pending approval',
            subtitle: 'Faculty and admin can review this item',
            meta: 'Today',
            status: 'Pending',
            icon: Icons.pending_actions_outlined,
          ),
          const StaticRecord(
            title: 'Report generated',
            subtitle: 'Summary export is available in the demo',
            meta: 'Static demo',
            status: 'Complete',
            icon: Icons.summarize_outlined,
          ),
        ],
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
        'Track today classes, assignments, fees, results, and campus services.',
    metrics: [
      StaticMetric(
        label: 'Attendance',
        value: '87%',
        note: '+4% from last week',
        icon: Icons.fact_check_outlined,
      ),
      StaticMetric(
        label: 'Current CGPA',
        value: '3.74',
        note: 'Spring 2026',
        icon: Icons.school_outlined,
      ),
      StaticMetric(
        label: 'Due amount',
        value: 'BDT 8,500',
        note: 'Due by Jul 10',
        icon: Icons.payments_outlined,
      ),
      StaticMetric(
        label: 'Open tasks',
        value: '6',
        note: '2 urgent',
        icon: Icons.task_alt_outlined,
      ),
    ],
    priorities: [
      StaticRecord(
        title: 'Submit Data Mining assignment',
        subtitle: 'Upload PDF and source files',
        meta: 'Tonight, 11:59 PM',
        status: 'Pending',
        icon: Icons.assignment_outlined,
      ),
      StaticRecord(
        title: 'Tuition installment',
        subtitle: 'Accounts office and online payment',
        meta: 'Jul 10, 2026',
        status: 'Due',
        icon: Icons.account_balance_wallet_outlined,
      ),
      StaticRecord(
        title: 'Scholarship form',
        subtitle: 'Merit scholarship application window',
        meta: '5 days left',
        status: 'Open',
        icon: Icons.workspace_premium_outlined,
      ),
    ],
    schedule: [
      StaticRecord(
        title: 'Software Engineering',
        subtitle: 'Room 604, CSE Building',
        meta: '09:00 AM',
        status: 'Class',
        icon: Icons.menu_book_outlined,
      ),
      StaticRecord(
        title: 'AI Lab',
        subtitle: 'Lab 3 with Section A',
        meta: '12:30 PM',
        status: 'Lab',
        icon: Icons.computer_outlined,
      ),
      StaticRecord(
        title: 'Advising hour',
        subtitle: 'Course registration support',
        meta: '03:00 PM',
        status: 'Support',
        icon: Icons.support_agent_outlined,
      ),
    ],
  ),
  DashboardProfile(
    role: PortalRole.teacher,
    headline: 'Teacher workspace',
    summary:
        'Review classes, attendance sheets, submissions, notices, and course activity.',
    metrics: [
      StaticMetric(
        label: 'Today classes',
        value: '4',
        note: '2 labs included',
        icon: Icons.event_available_outlined,
      ),
      StaticMetric(
        label: 'Pending checks',
        value: '38',
        note: 'Assignments and quizzes',
        icon: Icons.rate_review_outlined,
      ),
      StaticMetric(
        label: 'Attendance avg',
        value: '82%',
        note: 'Across active courses',
        icon: Icons.how_to_reg_outlined,
      ),
      StaticMetric(
        label: 'Student notices',
        value: '5',
        note: '2 scheduled',
        icon: Icons.campaign_outlined,
      ),
    ],
    priorities: [
      StaticRecord(
        title: 'Approve quiz marks',
        subtitle: 'CSE 410 online quiz',
        meta: '24 scripts',
        status: 'Review',
        icon: Icons.quiz_outlined,
      ),
      StaticRecord(
        title: 'Publish lab material',
        subtitle: 'Mobile App Development',
        meta: 'Week 5',
        status: 'Draft',
        icon: Icons.upload_file_outlined,
      ),
      StaticRecord(
        title: 'Send class notice',
        subtitle: 'Room changed for CSE 303',
        meta: 'Section B',
        status: 'Ready',
        icon: Icons.notifications_active_outlined,
      ),
    ],
    schedule: [
      StaticRecord(
        title: 'CSE 303',
        subtitle: 'Data Communication',
        meta: '10:00 AM',
        status: 'Class',
        icon: Icons.co_present_outlined,
      ),
      StaticRecord(
        title: 'CSE 410',
        subtitle: 'Artificial Intelligence',
        meta: '01:00 PM',
        status: 'Class',
        icon: Icons.psychology_outlined,
      ),
      StaticRecord(
        title: 'Project viva',
        subtitle: 'Final year project panel',
        meta: '04:00 PM',
        status: 'Panel',
        icon: Icons.groups_outlined,
      ),
    ],
  ),
  DashboardProfile(
    role: PortalRole.faculty,
    headline: 'Faculty workspace',
    summary:
        'Coordinate departments, teachers, students, calendars, payments, and reports.',
    metrics: [
      StaticMetric(
        label: 'Departments',
        value: '9',
        note: '2 updates pending',
        icon: Icons.account_tree_outlined,
      ),
      StaticMetric(
        label: 'Active teachers',
        value: '126',
        note: '8 newly assigned',
        icon: Icons.badge_outlined,
      ),
      StaticMetric(
        label: 'Pending payments',
        value: '214',
        note: 'Across 3 faculties',
        icon: Icons.receipt_long_outlined,
      ),
      StaticMetric(
        label: 'Reports',
        value: '12',
        note: 'Awaiting publish',
        icon: Icons.analytics_outlined,
      ),
    ],
    priorities: [
      StaticRecord(
        title: 'Publish academic calendar',
        subtitle: 'Summer 2026 exam and holiday dates',
        meta: 'Needs dean approval',
        status: 'Approval',
        icon: Icons.calendar_month_outlined,
      ),
      StaticRecord(
        title: 'Assign department head',
        subtitle: 'Textile Engineering',
        meta: 'Candidate shortlisted',
        status: 'Pending',
        icon: Icons.manage_accounts_outlined,
      ),
      StaticRecord(
        title: 'Approve result upload',
        subtitle: 'CSE Spring 2026 final result',
        meta: '3 courses flagged',
        status: 'Review',
        icon: Icons.fact_check_outlined,
      ),
    ],
    schedule: [
      StaticRecord(
        title: 'Dean meeting',
        subtitle: 'Faculty performance overview',
        meta: '11:30 AM',
        status: 'Meeting',
        icon: Icons.meeting_room_outlined,
      ),
      StaticRecord(
        title: 'Payment report review',
        subtitle: 'Accounts office',
        meta: '02:00 PM',
        status: 'Report',
        icon: Icons.payments_outlined,
      ),
      StaticRecord(
        title: 'Teacher onboarding',
        subtitle: 'New contract faculty orientation',
        meta: '04:30 PM',
        status: 'Session',
        icon: Icons.group_add_outlined,
      ),
    ],
  ),
  DashboardProfile(
    role: PortalRole.admin,
    headline: 'Admin workspace',
    summary:
        'Monitor roles, approvals, notices, security, system activity, and campus operations.',
    metrics: [
      StaticMetric(
        label: 'Active users',
        value: '8,432',
        note: '+126 this month',
        icon: Icons.people_alt_outlined,
      ),
      StaticMetric(
        label: 'Approvals',
        value: '47',
        note: 'Events, roles, notices',
        icon: Icons.verified_outlined,
      ),
      StaticMetric(
        label: 'System logs',
        value: '1,284',
        note: 'Last 24 hours',
        icon: Icons.history_outlined,
      ),
      StaticMetric(
        label: 'Open tickets',
        value: '29',
        note: '7 high priority',
        icon: Icons.support_agent_outlined,
      ),
    ],
    priorities: [
      StaticRecord(
        title: 'Approve university event',
        subtitle: 'Cultural week proposal',
        meta: 'Student Affairs',
        status: 'Approval',
        icon: Icons.event_outlined,
      ),
      StaticRecord(
        title: 'Review role changes',
        subtitle: 'Teacher and faculty permissions',
        meta: '12 requests',
        status: 'Security',
        icon: Icons.admin_panel_settings_outlined,
      ),
      StaticRecord(
        title: 'Publish emergency notice',
        subtitle: 'Maintenance window announcement',
        meta: 'Campus wide',
        status: 'Ready',
        icon: Icons.warning_amber_outlined,
      ),
    ],
    schedule: [
      StaticRecord(
        title: 'System audit',
        subtitle: 'Login and activity logs',
        meta: '09:30 AM',
        status: 'Audit',
        icon: Icons.security_outlined,
      ),
      StaticRecord(
        title: 'Operations review',
        subtitle: 'Support tickets and incident queue',
        meta: '01:30 PM',
        status: 'Review',
        icon: Icons.dashboard_customize_outlined,
      ),
      StaticRecord(
        title: 'Backup check',
        subtitle: 'Static demo data snapshot',
        meta: '06:00 PM',
        status: 'System',
        icon: Icons.backup_outlined,
      ),
    ],
  ),
];

const staticFeatures = [
  StaticFeature(
    title: 'Authentication',
    category: 'Core',
    description:
        'Registration, login, forgot password, OTP, reset password, and session overview.',
    icon: Icons.login_outlined,
    accent: Color(0xFF2A2D7E),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'New signups',
        value: '42',
        note: 'This week',
        icon: Icons.person_add_alt_outlined,
      ),
      StaticMetric(
        label: 'OTP sent',
        value: '118',
        note: 'Static queue',
        icon: Icons.sms_outlined,
      ),
      StaticMetric(
        label: 'Sessions',
        value: '1,906',
        note: 'Active today',
        icon: Icons.devices_outlined,
      ),
    ],
    actions: ['Create account', 'Send OTP', 'Reset password'],
    records: [
      StaticRecord(
        title: 'Student registration',
        subtitle: 'CSE-2026-014 added profile details',
        meta: '10 minutes ago',
        status: 'Complete',
        icon: Icons.person_add_alt_outlined,
      ),
      StaticRecord(
        title: 'Password reset',
        subtitle: 'OTP verified for faculty account',
        meta: '25 minutes ago',
        status: 'Verified',
        icon: Icons.lock_reset_outlined,
      ),
      StaticRecord(
        title: 'Remember me setting',
        subtitle: 'Saved for current browser session',
        meta: 'Static demo',
        status: 'Enabled',
        icon: Icons.verified_user_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Student Portal',
    category: 'Portal',
    description:
        'A student view for assignments, attendance, results, fees, courses, support, and profile.',
    icon: Icons.person_outline,
    accent: Color(0xFF007F3D),
    access: studentAccess,
    metrics: [
      StaticMetric(
        label: 'Courses',
        value: '6',
        note: '18 credit hours',
        icon: Icons.library_books_outlined,
      ),
      StaticMetric(
        label: 'Assignments',
        value: '4',
        note: '2 due soon',
        icon: Icons.assignment_outlined,
      ),
      StaticMetric(
        label: 'Tickets',
        value: '1',
        note: 'In progress',
        icon: Icons.support_agent_outlined,
      ),
    ],
    actions: ['View routine', 'Submit ticket', 'Pay tuition'],
    records: [
      StaticRecord(
        title: 'Course registration',
        subtitle: 'CSE 410, CSE 420, MAT 301',
        meta: 'Spring 2026',
        status: 'Approved',
        icon: Icons.fact_check_outlined,
      ),
      StaticRecord(
        title: 'Support request',
        subtitle: 'ID card reissue request',
        meta: 'Ticket #1042',
        status: 'Open',
        icon: Icons.confirmation_number_outlined,
      ),
      StaticRecord(
        title: 'Profile update',
        subtitle: 'Phone number and guardian contact',
        meta: 'Yesterday',
        status: 'Saved',
        icon: Icons.manage_accounts_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Teacher Portal',
    category: 'Portal',
    description:
        'Course materials, attendance, assignments, academic reports, and student notices.',
    icon: Icons.co_present_outlined,
    accent: Color(0xFF8B5E00),
    access: teacherAccess,
    metrics: [
      StaticMetric(
        label: 'Courses',
        value: '5',
        note: '3 sections',
        icon: Icons.class_outlined,
      ),
      StaticMetric(
        label: 'Submissions',
        value: '86',
        note: 'Need review',
        icon: Icons.rate_review_outlined,
      ),
      StaticMetric(
        label: 'Notices',
        value: '5',
        note: '2 scheduled',
        icon: Icons.campaign_outlined,
      ),
    ],
    actions: ['Create course', 'Upload material', 'Send notice'],
    records: [
      StaticRecord(
        title: 'CSE 410 material',
        subtitle: 'Search algorithms lecture uploaded',
        meta: 'Week 6',
        status: 'Published',
        icon: Icons.upload_file_outlined,
      ),
      StaticRecord(
        title: 'Attendance sheet',
        subtitle: 'CSE 303 Section B',
        meta: 'Today',
        status: 'Draft',
        icon: Icons.how_to_reg_outlined,
      ),
      StaticRecord(
        title: 'Academic report',
        subtitle: 'Midterm performance summary',
        meta: '38 students',
        status: 'Ready',
        icon: Icons.analytics_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Faculty Portal',
    category: 'Portal',
    description:
        'Faculty dashboard for teachers, departments, reports, calendars, payments, and results.',
    icon: Icons.business_center_outlined,
    accent: Color(0xFF0F766E),
    access: facultyAccess,
    metrics: [
      StaticMetric(
        label: 'Teachers',
        value: '126',
        note: '8 pending updates',
        icon: Icons.badge_outlined,
      ),
      StaticMetric(
        label: 'Departments',
        value: '9',
        note: 'All active',
        icon: Icons.account_tree_outlined,
      ),
      StaticMetric(
        label: 'Reports',
        value: '12',
        note: 'Awaiting publish',
        icon: Icons.summarize_outlined,
      ),
    ],
    actions: ['Add teacher', 'Publish result', 'Create routine'],
    records: [
      StaticRecord(
        title: 'Teacher assignment',
        subtitle: 'Dr. Rahman assigned to CSE 410',
        meta: 'Today',
        status: 'Done',
        icon: Icons.group_add_outlined,
      ),
      StaticRecord(
        title: 'Payment record',
        subtitle: 'Pending tuition list generated',
        meta: '214 rows',
        status: 'Ready',
        icon: Icons.receipt_long_outlined,
      ),
      StaticRecord(
        title: 'Routine update',
        subtitle: 'Exam routine changed for final week',
        meta: 'Spring 2026',
        status: 'Published',
        icon: Icons.calendar_month_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Administration Panel',
    category: 'Administration',
    description:
        'System activity, approvals, user roles, event moderation, and university-wide control.',
    icon: Icons.admin_panel_settings_outlined,
    accent: Color(0xFFB42318),
    access: adminAccess,
    metrics: [
      StaticMetric(
        label: 'Approvals',
        value: '47',
        note: 'Needs action',
        icon: Icons.rule_folder_outlined,
      ),
      StaticMetric(
        label: 'Active roles',
        value: '14',
        note: '4 custom roles',
        icon: Icons.manage_accounts_outlined,
      ),
      StaticMetric(
        label: 'Logs',
        value: '1,284',
        note: 'Last 24 hours',
        icon: Icons.history_outlined,
      ),
    ],
    actions: ['Approve event', 'Manage role', 'Review logs'],
    records: [
      StaticRecord(
        title: 'Event approval',
        subtitle: 'Department seminar request',
        meta: 'Pending',
        status: 'Review',
        icon: Icons.event_available_outlined,
      ),
      StaticRecord(
        title: 'Role update',
        subtitle: 'Temporary finance viewer access',
        meta: 'Expires Jul 5',
        status: 'Limited',
        icon: Icons.security_outlined,
      ),
      StaticRecord(
        title: 'System activity',
        subtitle: 'Bulk notice publish completed',
        meta: '1 hour ago',
        status: 'Logged',
        icon: Icons.history_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Departments',
    category: 'Academic',
    description:
        'Department directory, profile details, teacher assignments, and editable academic metadata.',
    icon: Icons.account_tree_outlined,
    accent: Color(0xFF2563EB),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'Departments',
        value: '12',
        note: '9 faculties',
        icon: Icons.domain_outlined,
      ),
      StaticMetric(
        label: 'Programs',
        value: '34',
        note: 'Undergraduate and graduate',
        icon: Icons.school_outlined,
      ),
      StaticMetric(
        label: 'Updates',
        value: '3',
        note: 'Pending approval',
        icon: Icons.pending_actions_outlined,
      ),
    ],
    actions: ['View details', 'Edit department', 'Assign teacher'],
    records: [
      StaticRecord(
        title: 'Computer Science and Engineering',
        subtitle: 'Faculty of Science and Engineering',
        meta: '1,246 students',
        status: 'Active',
        icon: Icons.memory_outlined,
      ),
      StaticRecord(
        title: 'Business Administration',
        subtitle: 'Faculty of Business Studies',
        meta: '936 students',
        status: 'Active',
        icon: Icons.business_center_outlined,
      ),
      StaticRecord(
        title: 'Textile Engineering',
        subtitle: 'Department head update requested',
        meta: 'Pending',
        status: 'Review',
        icon: Icons.approval_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Department Management',
    category: 'Faculty',
    description:
        'Create departments, assign heads, manage programs, and review faculty-level department status.',
    icon: Icons.account_tree_outlined,
    accent: Color(0xFF1D4ED8),
    access: facultyAccess,
    metrics: [
      StaticMetric(
        label: 'Departments',
        value: '9',
        note: 'Across 4 faculties',
        icon: Icons.account_tree_outlined,
      ),
      StaticMetric(
        label: 'Programs',
        value: '31',
        note: 'Undergraduate and graduate',
        icon: Icons.school_outlined,
      ),
      StaticMetric(
        label: 'Head updates',
        value: '3',
        note: 'Awaiting dean approval',
        icon: Icons.manage_accounts_outlined,
      ),
    ],
    actions: ['Add department', 'Assign head', 'Export program list'],
    records: [
      StaticRecord(
        title: 'CSE program review',
        subtitle: 'New AI lab course attached to the curriculum map',
        meta: 'Faculty of Engineering',
        status: 'Review',
        icon: Icons.memory_outlined,
      ),
      StaticRecord(
        title: 'Textile head assignment',
        subtitle: 'Shortlisted faculty profile sent for dean approval',
        meta: 'Pending approval',
        status: 'Pending',
        icon: Icons.approval_outlined,
      ),
      StaticRecord(
        title: 'Business program archive',
        subtitle: 'Old concentration list moved to inactive catalog',
        meta: 'Summer 2026',
        status: 'Complete',
        icon: Icons.archive_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Teacher Management',
    category: 'Faculty',
    description:
        'Teacher profiles, course load, designation, department assignment, and onboarding workflow.',
    icon: Icons.co_present_outlined,
    accent: Color(0xFF0F766E),
    access: facultyAccess,
    metrics: [
      StaticMetric(
        label: 'Active teachers',
        value: '126',
        note: '8 newly assigned',
        icon: Icons.badge_outlined,
      ),
      StaticMetric(
        label: 'Course loads',
        value: '342',
        note: 'Current semester',
        icon: Icons.menu_book_outlined,
      ),
      StaticMetric(
        label: 'Pending profiles',
        value: '11',
        note: 'Documents to verify',
        icon: Icons.fact_check_outlined,
      ),
    ],
    actions: ['Add teacher', 'Assign course', 'Verify profile'],
    records: [
      StaticRecord(
        title: 'Dr. Rahman assigned',
        subtitle: 'CSE 410 Artificial Intelligence lecture and lab',
        meta: '3 sections',
        status: 'Active',
        icon: Icons.co_present_outlined,
      ),
      StaticRecord(
        title: 'Nusrat Jahan profile',
        subtitle: 'Joining documents uploaded for HR verification',
        meta: 'New faculty',
        status: 'Review',
        icon: Icons.description_outlined,
      ),
      StaticRecord(
        title: 'Guest teacher contract',
        subtitle: 'Business analytics short course contract prepared',
        meta: 'Summer 2026',
        status: 'Draft',
        icon: Icons.edit_note_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Student Management',
    category: 'Faculty',
    description:
        'Student profiles, enrollment status, advising notes, section assignment, and academic profile review.',
    icon: Icons.people_alt_outlined,
    accent: Color(0xFF2563EB),
    access: facultyAccess,
    metrics: [
      StaticMetric(
        label: 'Active students',
        value: '8,432',
        note: 'All faculties',
        icon: Icons.people_alt_outlined,
      ),
      StaticMetric(
        label: 'New admissions',
        value: '312',
        note: 'Summer intake',
        icon: Icons.person_add_alt_outlined,
      ),
      StaticMetric(
        label: 'Advising queue',
        value: '58',
        note: 'Course registration',
        icon: Icons.support_agent_outlined,
      ),
    ],
    actions: ['Add student', 'Assign section', 'Review advising'],
    records: [
      StaticRecord(
        title: 'CSE-2026-014',
        subtitle: 'Section A confirmed with 18 credit hours',
        meta: 'Registration complete',
        status: 'Approved',
        icon: Icons.fact_check_outlined,
      ),
      StaticRecord(
        title: 'Probation review',
        subtitle: 'Academic advisor note required before enrollment',
        meta: '12 students',
        status: 'Alert',
        icon: Icons.warning_amber_outlined,
      ),
      StaticRecord(
        title: 'Transfer credit batch',
        subtitle: 'Registrar uploaded equivalency documents',
        meta: '8 requests',
        status: 'Review',
        icon: Icons.folder_copy_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Events',
    category: 'Campus',
    description:
        'Student, faculty, teacher, and university events with create, approve, reject, and publish flow.',
    icon: Icons.event_outlined,
    accent: Color(0xFF9333EA),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'Published',
        value: '18',
        note: 'This month',
        icon: Icons.event_available_outlined,
      ),
      StaticMetric(
        label: 'Approvals',
        value: '7',
        note: 'Awaiting review',
        icon: Icons.approval_outlined,
      ),
      StaticMetric(
        label: 'Attendees',
        value: '1.8K',
        note: 'Registered',
        icon: Icons.groups_outlined,
      ),
    ],
    actions: ['Create event', 'Approve request', 'Publish event'],
    records: [
      StaticRecord(
        title: 'Cultural Week',
        subtitle: 'University auditorium and field',
        meta: 'Jul 14',
        status: 'Approved',
        icon: Icons.celebration_outlined,
      ),
      StaticRecord(
        title: 'Research Seminar',
        subtitle: 'Faculty of Engineering',
        meta: 'Jul 2',
        status: 'Published',
        icon: Icons.science_outlined,
      ),
      StaticRecord(
        title: 'Programming Contest',
        subtitle: 'CSE Club proposal',
        meta: 'Pending',
        status: 'Review',
        icon: Icons.code_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Routine Management',
    category: 'Academic',
    description:
        'Create class routines, assign rooms, resolve teacher conflicts, and publish semester schedules.',
    icon: Icons.calendar_month_outlined,
    accent: Color(0xFF7C2D12),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'Published slots',
        value: '214',
        note: 'Current semester',
        icon: Icons.event_available_outlined,
      ),
      StaticMetric(
        label: 'Conflicts',
        value: '5',
        note: 'Room and teacher overlap',
        icon: Icons.warning_amber_outlined,
      ),
      StaticMetric(
        label: 'Lab rooms',
        value: '18',
        note: 'Allocated',
        icon: Icons.computer_outlined,
      ),
    ],
    actions: ['Create routine', 'Resolve conflict', 'Publish schedule'],
    records: [
      StaticRecord(
        title: 'CSE Section A routine',
        subtitle: 'Morning classes moved to Room 604',
        meta: 'Effective Jul 12',
        status: 'Published',
        icon: Icons.schedule_outlined,
      ),
      StaticRecord(
        title: 'AI Lab conflict',
        subtitle: 'Teacher and lab room overlap detected',
        meta: 'Needs coordinator',
        status: 'Alert',
        icon: Icons.warning_amber_outlined,
      ),
      StaticRecord(
        title: 'Final exam draft',
        subtitle: 'Routine prepared for faculty review',
        meta: 'Summer 2026',
        status: 'Draft',
        icon: Icons.edit_calendar_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Class Routine',
    category: 'Academic',
    description:
        'Student class routine with rooms, teachers, labs, breaks, and current-day schedule summary.',
    icon: Icons.schedule_outlined,
    accent: Color(0xFF0284C7),
    access: studentAccess,
    metrics: [
      StaticMetric(
        label: 'Today classes',
        value: '4',
        note: '2 theory, 2 lab',
        icon: Icons.event_available_outlined,
      ),
      StaticMetric(
        label: 'Weekly hours',
        value: '18',
        note: 'Credit schedule',
        icon: Icons.timer_outlined,
      ),
      StaticMetric(
        label: 'Room changes',
        value: '1',
        note: 'This week',
        icon: Icons.meeting_room_outlined,
      ),
    ],
    actions: ['View today', 'Download routine', 'Set reminder'],
    records: [
      StaticRecord(
        title: 'Software Engineering',
        subtitle: 'Room 604 with Nusrat Jahan',
        meta: '09:00 AM',
        status: 'Class',
        icon: Icons.menu_book_outlined,
      ),
      StaticRecord(
        title: 'Artificial Intelligence Lab',
        subtitle: 'Lab 3 with Dr. Karim',
        meta: '12:30 PM',
        status: 'Lab',
        icon: Icons.computer_outlined,
      ),
      StaticRecord(
        title: 'Numerical Methods',
        subtitle: 'Room 302 with Dr. Alam',
        meta: '03:00 PM',
        status: 'Class',
        icon: Icons.calculate_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Academic Calendar',
    category: 'Academic',
    description:
        'Semesters, holidays, exams, events, registration windows, and publication workflow.',
    icon: Icons.calendar_month_outlined,
    accent: Color(0xFF0891B2),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'Events',
        value: '32',
        note: 'Summer 2026',
        icon: Icons.event_note_outlined,
      ),
      StaticMetric(
        label: 'Holidays',
        value: '9',
        note: 'Published',
        icon: Icons.beach_access_outlined,
      ),
      StaticMetric(
        label: 'Exam slots',
        value: '18',
        note: 'Draft routine',
        icon: Icons.edit_calendar_outlined,
      ),
    ],
    actions: ['Create calendar', 'Edit date', 'Publish calendar'],
    records: [
      StaticRecord(
        title: 'Midterm exam',
        subtitle: 'Summer 2026 schedule',
        meta: 'Aug 4-12',
        status: 'Draft',
        icon: Icons.assignment_outlined,
      ),
      StaticRecord(
        title: 'Registration deadline',
        subtitle: 'Course add/drop closes',
        meta: 'Jul 8',
        status: 'Published',
        icon: Icons.app_registration_outlined,
      ),
      StaticRecord(
        title: 'Foundation Day',
        subtitle: 'University holiday',
        meta: 'Jul 21',
        status: 'Published',
        icon: Icons.flag_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Lost and Found',
    category: 'Campus',
    description:
        'Post lost or found items, upload images, contact owners, and mark items as resolved.',
    icon: Icons.search_outlined,
    accent: Color(0xFFDC2626),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'Open posts',
        value: '23',
        note: '11 lost, 12 found',
        icon: Icons.inventory_2_outlined,
      ),
      StaticMetric(
        label: 'Resolved',
        value: '9',
        note: 'This week',
        icon: Icons.task_alt_outlined,
      ),
      StaticMetric(
        label: 'Messages',
        value: '36',
        note: 'Owner contacts',
        icon: Icons.message_outlined,
      ),
    ],
    actions: ['Post lost item', 'Post found item', 'Mark resolved'],
    records: [
      StaticRecord(
        title: 'Found wallet',
        subtitle: 'Near library entrance',
        meta: 'Today',
        status: 'Found',
        icon: Icons.account_balance_wallet_outlined,
      ),
      StaticRecord(
        title: 'Lost calculator',
        subtitle: 'Casio scientific, Room 302',
        meta: 'Yesterday',
        status: 'Open',
        icon: Icons.calculate_outlined,
      ),
      StaticRecord(
        title: 'ID card returned',
        subtitle: 'CSE-2025-087',
        meta: '2 days ago',
        status: 'Resolved',
        icon: Icons.badge_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Notice Board',
    category: 'Communication',
    description:
        'Student, teacher, faculty, department, and university notices with segmented publishing.',
    icon: Icons.campaign_outlined,
    accent: Color(0xFFEA580C),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'Notices',
        value: '64',
        note: 'Active',
        icon: Icons.article_outlined,
      ),
      StaticMetric(
        label: 'Drafts',
        value: '8',
        note: 'Needs publish',
        icon: Icons.edit_note_outlined,
      ),
      StaticMetric(
        label: 'Audience',
        value: '8.4K',
        note: 'Students and staff',
        icon: Icons.groups_outlined,
      ),
    ],
    actions: ['Create notice', 'Schedule notice', 'Publish now'],
    records: [
      StaticRecord(
        title: 'Final exam form fill-up',
        subtitle: 'Accounts clearance required',
        meta: 'All students',
        status: 'Pinned',
        icon: Icons.push_pin_outlined,
      ),
      StaticRecord(
        title: 'Class suspension',
        subtitle: 'Room maintenance for CSE building',
        meta: 'CSE students',
        status: 'Scheduled',
        icon: Icons.schedule_outlined,
      ),
      StaticRecord(
        title: 'Faculty meeting',
        subtitle: 'Dean office agenda published',
        meta: 'Faculty',
        status: 'Published',
        icon: Icons.meeting_room_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Assignments',
    category: 'Academic',
    description:
        'Assignment publishing, submissions, file upload status, feedback, and due-date tracking.',
    icon: Icons.assignment_outlined,
    accent: Color(0xFF4F46E5),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'Assigned',
        value: '14',
        note: 'Current semester',
        icon: Icons.assignment_outlined,
      ),
      StaticMetric(
        label: 'Submitted',
        value: '10',
        note: '2 graded',
        icon: Icons.upload_file_outlined,
      ),
      StaticMetric(
        label: 'Due soon',
        value: '2',
        note: 'Within 48 hours',
        icon: Icons.timer_outlined,
      ),
    ],
    actions: ['View assignment', 'Submit file', 'Download feedback'],
    records: [
      StaticRecord(
        title: 'Data Mining report',
        subtitle: 'PDF and source file required',
        meta: 'Due tonight',
        status: 'Pending',
        icon: Icons.description_outlined,
      ),
      StaticRecord(
        title: 'Mobile app prototype',
        subtitle: 'Flutter UI implementation',
        meta: 'Due Jul 6',
        status: 'Open',
        icon: Icons.phone_android_outlined,
      ),
      StaticRecord(
        title: 'Database ER diagram',
        subtitle: 'Faculty feedback attached',
        meta: 'Graded',
        status: 'Returned',
        icon: Icons.account_tree_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Attendance',
    category: 'Academic',
    description:
        'Daily attendance, class-wise percentages, low attendance alerts, and teacher sheet review.',
    icon: Icons.how_to_reg_outlined,
    accent: Color(0xFF16A34A),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'Average',
        value: '87%',
        note: 'Current semester',
        icon: Icons.insights_outlined,
      ),
      StaticMetric(
        label: 'At risk',
        value: '12',
        note: 'Below 70%',
        icon: Icons.warning_amber_outlined,
      ),
      StaticMetric(
        label: 'Sheets',
        value: '28',
        note: 'Pending submit',
        icon: Icons.fact_check_outlined,
      ),
    ],
    actions: ['Take attendance', 'View percentage', 'Export sheet'],
    records: [
      StaticRecord(
        title: 'CSE 410',
        subtitle: 'Present 42 of 48 students',
        meta: 'Today',
        status: 'Submitted',
        icon: Icons.fact_check_outlined,
      ),
      StaticRecord(
        title: 'MAT 301',
        subtitle: 'Attendance below threshold',
        meta: '68%',
        status: 'Alert',
        icon: Icons.warning_amber_outlined,
      ),
      StaticRecord(
        title: 'EEE 210',
        subtitle: 'Teacher sheet pending',
        meta: 'Yesterday',
        status: 'Draft',
        icon: Icons.edit_note_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Student Notices',
    category: 'Teacher',
    description:
        'Teacher notice publishing for class changes, assignment reminders, exam updates, and student alerts.',
    icon: Icons.campaign_outlined,
    accent: Color(0xFFB45309),
    access: teacherAccess,
    metrics: [
      StaticMetric(
        label: 'Published',
        value: '21',
        note: 'This semester',
        icon: Icons.campaign_outlined,
      ),
      StaticMetric(
        label: 'Scheduled',
        value: '4',
        note: 'Next 7 days',
        icon: Icons.schedule_outlined,
      ),
      StaticMetric(
        label: 'Recipients',
        value: '382',
        note: 'Active students',
        icon: Icons.groups_outlined,
      ),
    ],
    actions: ['Create notice', 'Schedule notice', 'Send reminder'],
    records: [
      StaticRecord(
        title: 'CSE 303 room changed',
        subtitle: 'Section B moved to Room 704 for the next class',
        meta: 'Sent to 48 students',
        status: 'Published',
        icon: Icons.notifications_active_outlined,
      ),
      StaticRecord(
        title: 'Quiz preparation notice',
        subtitle: 'Topic list attached for Artificial Intelligence',
        meta: 'Scheduled 08:00 PM',
        status: 'Ready',
        icon: Icons.quiz_outlined,
      ),
      StaticRecord(
        title: 'Assignment reminder',
        subtitle: 'Data Mining report submission window closes tonight',
        meta: 'Urgent',
        status: 'Urgent',
        icon: Icons.notification_important_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Lecture Materials',
    category: 'Teacher',
    description:
        'Upload slides, class notes, lab files, reading lists, and course resources for students.',
    icon: Icons.folder_copy_outlined,
    accent: Color(0xFF4338CA),
    access: teacherAccess,
    metrics: [
      StaticMetric(
        label: 'Materials',
        value: '84',
        note: 'Slides, PDFs, code',
        icon: Icons.folder_copy_outlined,
      ),
      StaticMetric(
        label: 'Downloads',
        value: '1.4K',
        note: 'Last 30 days',
        icon: Icons.file_download_outlined,
      ),
      StaticMetric(
        label: 'Drafts',
        value: '5',
        note: 'Not published',
        icon: Icons.edit_note_outlined,
      ),
    ],
    actions: ['Upload material', 'Publish folder', 'Archive file'],
    records: [
      StaticRecord(
        title: 'Search algorithms slides',
        subtitle: 'Week 5 lecture deck for CSE 410',
        meta: 'PDF, 2.4 MB',
        status: 'Published',
        icon: Icons.picture_as_pdf_outlined,
      ),
      StaticRecord(
        title: 'Flutter starter project',
        subtitle: 'Mobile App Development lab resources',
        meta: 'ZIP, 8 files',
        status: 'Ready',
        icon: Icons.code_outlined,
      ),
      StaticRecord(
        title: 'Database normalization notes',
        subtitle: 'Draft reading material awaiting review',
        meta: 'Week 4',
        status: 'Draft',
        icon: Icons.description_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Academic Report',
    category: 'Teacher',
    description:
        'Course performance reports, weak-student lists, section summaries, and advisor-ready analytics.',
    icon: Icons.analytics_outlined,
    accent: Color(0xFF0369A1),
    access: teacherAccess,
    metrics: [
      StaticMetric(
        label: 'Reports',
        value: '12',
        note: 'Generated',
        icon: Icons.analytics_outlined,
      ),
      StaticMetric(
        label: 'At risk',
        value: '18',
        note: 'Below target',
        icon: Icons.warning_amber_outlined,
      ),
      StaticMetric(
        label: 'Sections',
        value: '5',
        note: 'Current courses',
        icon: Icons.class_outlined,
      ),
    ],
    actions: ['Generate report', 'Filter section', 'Export PDF'],
    records: [
      StaticRecord(
        title: 'CSE 410 midterm report',
        subtitle: 'Average mark 78 with 6 students below target',
        meta: 'Section A',
        status: 'Ready',
        icon: Icons.leaderboard_outlined,
      ),
      StaticRecord(
        title: 'Attendance-risk summary',
        subtitle: 'Advisor follow-up recommended for 12 students',
        meta: 'All courses',
        status: 'Alert',
        icon: Icons.how_to_reg_outlined,
      ),
      StaticRecord(
        title: 'Course outcome map',
        subtitle: 'CO1 and CO2 achievement uploaded',
        meta: 'Spring 2026',
        status: 'Complete',
        icon: Icons.task_alt_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Marks Result',
    category: 'Teacher',
    description:
        'Enter marks, review grade sheets, publish results, and handle flagged student result corrections.',
    icon: Icons.leaderboard_outlined,
    accent: Color(0xFF059669),
    access: teacherAccess,
    metrics: [
      StaticMetric(
        label: 'Marks entered',
        value: '286',
        note: 'Across sections',
        icon: Icons.edit_note_outlined,
      ),
      StaticMetric(
        label: 'Pending review',
        value: '31',
        note: 'Manual checks',
        icon: Icons.rate_review_outlined,
      ),
      StaticMetric(
        label: 'Published',
        value: '9',
        note: 'Grade sheets',
        icon: Icons.verified_outlined,
      ),
    ],
    actions: ['Enter marks', 'Review sheet', 'Publish result'],
    records: [
      StaticRecord(
        title: 'CSE 410 Quiz 2',
        subtitle: 'Manual review completed for short answers',
        meta: '24 scripts',
        status: 'Complete',
        icon: Icons.quiz_outlined,
      ),
      StaticRecord(
        title: 'CSE 303 lab marks',
        subtitle: 'Two roll numbers flagged for missing submission',
        meta: 'Section B',
        status: 'Flagged',
        icon: Icons.report_problem_outlined,
      ),
      StaticRecord(
        title: 'MAT 301 grade sheet',
        subtitle: 'Final marks ready for faculty approval',
        meta: 'Spring 2026',
        status: 'Ready',
        icon: Icons.fact_check_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Community Forum',
    category: 'Communication',
    description:
        'Student social posts, comments, likes, media, announcements, and moderation status.',
    icon: Icons.forum_outlined,
    accent: Color(0xFFDB2777),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'Posts',
        value: '382',
        note: 'This month',
        icon: Icons.dynamic_feed_outlined,
      ),
      StaticMetric(
        label: 'Comments',
        value: '1.9K',
        note: 'Active threads',
        icon: Icons.comment_outlined,
      ),
      StaticMetric(
        label: 'Moderation',
        value: '6',
        note: 'Flagged posts',
        icon: Icons.gavel_outlined,
      ),
    ],
    actions: ['Create post', 'Moderate post', 'Attach media'],
    records: [
      StaticRecord(
        title: 'Club recruitment',
        subtitle: 'Computer Club volunteer call',
        meta: '120 likes',
        status: 'Live',
        icon: Icons.groups_outlined,
      ),
      StaticRecord(
        title: 'Lab partner request',
        subtitle: 'CSE 303 Section A',
        meta: '16 replies',
        status: 'Open',
        icon: Icons.handshake_outlined,
      ),
      StaticRecord(
        title: 'Photo album',
        subtitle: 'Freshers reception gallery',
        meta: '32 photos',
        status: 'Published',
        icon: Icons.photo_library_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Discussion Board',
    category: 'Communication',
    description:
        'Question, answer, category, reply, and academic thread management for student discussion.',
    icon: Icons.question_answer_outlined,
    accent: Color(0xFF0D9488),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'Questions',
        value: '154',
        note: '38 unanswered',
        icon: Icons.help_outline,
      ),
      StaticMetric(
        label: 'Answers',
        value: '426',
        note: 'Peer support',
        icon: Icons.question_answer_outlined,
      ),
      StaticMetric(
        label: 'Categories',
        value: '12',
        note: 'Course and campus',
        icon: Icons.category_outlined,
      ),
    ],
    actions: ['Ask question', 'Answer thread', 'Filter category'],
    records: [
      StaticRecord(
        title: 'How to apply for scholarship?',
        subtitle: 'Answered by Student Affairs',
        meta: 'Finance',
        status: 'Answered',
        icon: Icons.workspace_premium_outlined,
      ),
      StaticRecord(
        title: 'CSE 410 project group',
        subtitle: 'Looking for one teammate',
        meta: 'Academics',
        status: 'Open',
        icon: Icons.groups_outlined,
      ),
      StaticRecord(
        title: 'Library database access',
        subtitle: 'Resolved with login steps',
        meta: 'Campus',
        status: 'Resolved',
        icon: Icons.local_library_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Tuition Fees',
    category: 'Finance',
    description:
        'Current due, payment status, previous payments, installments, and fee clearance.',
    icon: Icons.account_balance_wallet_outlined,
    accent: Color(0xFFCA8A04),
    access: studentAccess,
    metrics: [
      StaticMetric(
        label: 'Current due',
        value: 'BDT 8,500',
        note: 'Installment 2',
        icon: Icons.payments_outlined,
      ),
      StaticMetric(
        label: 'Paid',
        value: 'BDT 42,000',
        note: 'Spring 2026',
        icon: Icons.verified_outlined,
      ),
      StaticMetric(
        label: 'Deadline',
        value: '10 Jul',
        note: 'Without late fee',
        icon: Icons.event_busy_outlined,
      ),
    ],
    actions: ['View due', 'Pay now', 'Download invoice'],
    records: [
      StaticRecord(
        title: 'Spring 2026 tuition',
        subtitle: 'Second installment pending',
        meta: 'BDT 8,500',
        status: 'Due',
        icon: Icons.receipt_long_outlined,
      ),
      StaticRecord(
        title: 'Lab fee',
        subtitle: 'CSE lab charge',
        meta: 'BDT 2,000',
        status: 'Paid',
        icon: Icons.check_circle_outline,
      ),
      StaticRecord(
        title: 'Late fee waiver',
        subtitle: 'Application under review',
        meta: 'Accounts',
        status: 'Review',
        icon: Icons.request_quote_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Scholarships',
    category: 'Finance',
    description:
        'Available scholarships, eligibility, application information, documents, and review status.',
    icon: Icons.workspace_premium_outlined,
    accent: Color(0xFF7C3AED),
    access: studentAccess,
    metrics: [
      StaticMetric(
        label: 'Open programs',
        value: '5',
        note: 'Merit and need based',
        icon: Icons.card_membership_outlined,
      ),
      StaticMetric(
        label: 'Eligible',
        value: '3',
        note: 'Based on CGPA',
        icon: Icons.verified_outlined,
      ),
      StaticMetric(
        label: 'Applications',
        value: '214',
        note: 'Under review',
        icon: Icons.assignment_turned_in_outlined,
      ),
    ],
    actions: ['Check eligibility', 'Apply now', 'Upload document'],
    records: [
      StaticRecord(
        title: 'Merit Scholarship',
        subtitle: 'CGPA 3.70 or higher',
        meta: 'Eligible',
        status: 'Open',
        icon: Icons.workspace_premium_outlined,
      ),
      StaticRecord(
        title: 'Need-based support',
        subtitle: 'Income certificate required',
        meta: 'Docs needed',
        status: 'Draft',
        icon: Icons.description_outlined,
      ),
      StaticRecord(
        title: 'Sports scholarship',
        subtitle: 'Inter-university participation',
        meta: 'Deadline Jul 22',
        status: 'Open',
        icon: Icons.sports_soccer_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Quiz System',
    category: 'Academic',
    description:
        'Online quizzes, automated evaluation, marks review, schedules, and teacher controls.',
    icon: Icons.quiz_outlined,
    accent: Color(0xFF0284C7),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'Active quizzes',
        value: '8',
        note: '2 today',
        icon: Icons.quiz_outlined,
      ),
      StaticMetric(
        label: 'Avg score',
        value: '76%',
        note: 'Across courses',
        icon: Icons.leaderboard_outlined,
      ),
      StaticMetric(
        label: 'Pending marks',
        value: '31',
        note: 'Manual review',
        icon: Icons.rate_review_outlined,
      ),
    ],
    actions: ['Start quiz', 'Create quiz', 'Publish marks'],
    records: [
      StaticRecord(
        title: 'CSE 410 Quiz 2',
        subtitle: 'Search algorithms',
        meta: '20 minutes',
        status: 'Open',
        icon: Icons.play_circle_outline,
      ),
      StaticRecord(
        title: 'MAT 301 Quiz 1',
        subtitle: 'Auto evaluated',
        meta: 'Score 18/20',
        status: 'Graded',
        icon: Icons.check_circle_outline,
      ),
      StaticRecord(
        title: 'EEE 210 quiz draft',
        subtitle: 'Teacher editing questions',
        meta: '10 MCQ',
        status: 'Draft',
        icon: Icons.edit_note_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Results',
    category: 'Academic',
    description:
        'GPA, CGPA, semester results, faculty publishing, flagged courses, and transcript summary.',
    icon: Icons.leaderboard_outlined,
    accent: Color(0xFF059669),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'CGPA',
        value: '3.74',
        note: 'Student view',
        icon: Icons.school_outlined,
      ),
      StaticMetric(
        label: 'Pending publish',
        value: '12',
        note: 'Faculty queue',
        icon: Icons.pending_actions_outlined,
      ),
      StaticMetric(
        label: 'Flagged',
        value: '3',
        note: 'Needs review',
        icon: Icons.flag_outlined,
      ),
    ],
    actions: ['View result', 'Upload result', 'Publish result'],
    records: [
      StaticRecord(
        title: 'Spring 2026 result',
        subtitle: 'Semester GPA 3.82',
        meta: 'Published',
        status: 'Live',
        icon: Icons.leaderboard_outlined,
      ),
      StaticRecord(
        title: 'CSE 303 marks',
        subtitle: 'Lab mark mismatch reported',
        meta: 'Teacher review',
        status: 'Flagged',
        icon: Icons.report_problem_outlined,
      ),
      StaticRecord(
        title: 'Transcript request',
        subtitle: 'PDF generation ready',
        meta: 'Registrar',
        status: 'Ready',
        icon: Icons.picture_as_pdf_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Payment History',
    category: 'Finance',
    description:
        'Tuition payments, due amounts, paid history, receipts, and payment reports.',
    icon: Icons.receipt_long_outlined,
    accent: Color(0xFF64748B),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'Receipts',
        value: '9',
        note: 'Current student',
        icon: Icons.receipt_outlined,
      ),
      StaticMetric(
        label: 'Total paid',
        value: 'BDT 168K',
        note: 'All semesters',
        icon: Icons.payments_outlined,
      ),
      StaticMetric(
        label: 'Reports',
        value: '6',
        note: 'Faculty exports',
        icon: Icons.file_download_outlined,
      ),
    ],
    actions: ['View receipt', 'Export report', 'Filter semester'],
    records: [
      StaticRecord(
        title: 'Spring 2026 installment 1',
        subtitle: 'Online payment',
        meta: 'BDT 32,000',
        status: 'Paid',
        icon: Icons.check_circle_outline,
      ),
      StaticRecord(
        title: 'Library fine',
        subtitle: 'Late return fee',
        meta: 'BDT 250',
        status: 'Paid',
        icon: Icons.local_library_outlined,
      ),
      StaticRecord(
        title: 'Semester report',
        subtitle: 'Faculty payment collection',
        meta: 'CSV ready',
        status: 'Ready',
        icon: Icons.file_download_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'User Roles',
    category: 'Administration',
    description:
        'Student, teacher, faculty, and admin permissions with read, write, update, and delete scopes.',
    icon: Icons.manage_accounts_outlined,
    accent: Color(0xFFBE123C),
    access: adminAccess,
    metrics: [
      StaticMetric(
        label: 'Roles',
        value: '14',
        note: '4 custom',
        icon: Icons.security_outlined,
      ),
      StaticMetric(
        label: 'Requests',
        value: '12',
        note: 'Pending approval',
        icon: Icons.pending_actions_outlined,
      ),
      StaticMetric(
        label: 'Policies',
        value: '38',
        note: 'Permission rules',
        icon: Icons.policy_outlined,
      ),
    ],
    actions: ['Create role', 'Edit permission', 'Audit access'],
    records: [
      StaticRecord(
        title: 'Faculty editor',
        subtitle: 'Department write access',
        meta: 'Expires Jul 5',
        status: 'Limited',
        icon: Icons.edit_outlined,
      ),
      StaticRecord(
        title: 'Teacher course manager',
        subtitle: 'Course read/write permission',
        meta: 'Active',
        status: 'Enabled',
        icon: Icons.verified_user_outlined,
      ),
      StaticRecord(
        title: 'Student support agent',
        subtitle: 'Ticket update permission',
        meta: 'Request #221',
        status: 'Review',
        icon: Icons.support_agent_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'System Activity',
    category: 'Administration',
    description:
        'System logs, login activity, role changes, backup status, moderation tasks, and audit events.',
    icon: Icons.history_outlined,
    accent: Color(0xFF6D28D9),
    access: adminAccess,
    metrics: [
      StaticMetric(
        label: 'Logs',
        value: '1.2K',
        note: 'Last 24 hours',
        icon: Icons.history_outlined,
      ),
      StaticMetric(
        label: 'Security alerts',
        value: '7',
        note: 'Needs review',
        icon: Icons.security_outlined,
      ),
      StaticMetric(
        label: 'Backups',
        value: '3',
        note: 'Healthy today',
        icon: Icons.backup_outlined,
      ),
    ],
    actions: ['View logs', 'Audit roles', 'Export activity'],
    records: [
      StaticRecord(
        title: 'Bulk notice publish',
        subtitle: 'Admin pushed emergency maintenance notice',
        meta: '1 hour ago',
        status: 'Logged',
        icon: Icons.campaign_outlined,
      ),
      StaticRecord(
        title: 'Role permission change',
        subtitle: 'Temporary finance viewer access granted',
        meta: 'Request #221',
        status: 'Security',
        icon: Icons.admin_panel_settings_outlined,
      ),
      StaticRecord(
        title: 'Nightly backup check',
        subtitle: 'Demo database snapshot completed successfully',
        meta: '06:00 PM',
        status: 'Healthy',
        icon: Icons.backup_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Notifications',
    category: 'Settings',
    description:
        'Notification preferences, channels, quiet hours, categories, and delivery status.',
    icon: Icons.notifications_outlined,
    accent: Color(0xFF0F766E),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'Unread',
        value: '17',
        note: 'Across features',
        icon: Icons.mark_email_unread_outlined,
      ),
      StaticMetric(
        label: 'Channels',
        value: '4',
        note: 'App, SMS, email, push',
        icon: Icons.settings_input_antenna_outlined,
      ),
      StaticMetric(
        label: 'Muted',
        value: '2',
        note: 'Categories',
        icon: Icons.notifications_off_outlined,
      ),
    ],
    actions: ['Mark read', 'Set quiet hours', 'Update channel'],
    records: [
      StaticRecord(
        title: 'Assignment reminder',
        subtitle: 'Data Mining deadline tonight',
        meta: 'Unread',
        status: 'Urgent',
        icon: Icons.notification_important_outlined,
      ),
      StaticRecord(
        title: 'Payment alert',
        subtitle: 'Installment due Jul 10',
        meta: 'Email and app',
        status: 'Sent',
        icon: Icons.payments_outlined,
      ),
      StaticRecord(
        title: 'Notice digest',
        subtitle: 'Daily university digest',
        meta: '08:00 PM',
        status: 'Scheduled',
        icon: Icons.schedule_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Profile',
    category: 'Core',
    description:
        'Personal information, academic information, contacts, digital student ID, and privacy.',
    icon: Icons.account_circle_outlined,
    accent: Color(0xFF4338CA),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'Completion',
        value: '92%',
        note: 'Guardian info missing',
        icon: Icons.account_circle_outlined,
      ),
      StaticMetric(
        label: 'Documents',
        value: '7',
        note: 'Uploaded',
        icon: Icons.folder_copy_outlined,
      ),
      StaticMetric(
        label: 'Privacy',
        value: 'High',
        note: 'Limited visibility',
        icon: Icons.privacy_tip_outlined,
      ),
    ],
    actions: ['Edit profile', 'View ID card', 'Update privacy'],
    records: [
      StaticRecord(
        title: 'Academic info',
        subtitle: 'CSE, Batch 2026, Section A',
        meta: 'Verified',
        status: 'Locked',
        icon: Icons.school_outlined,
      ),
      StaticRecord(
        title: 'Contact details',
        subtitle: 'Phone and email updated',
        meta: 'Yesterday',
        status: 'Saved',
        icon: Icons.contact_phone_outlined,
      ),
      StaticRecord(
        title: 'Digital student ID',
        subtitle: 'QR attendance ready',
        meta: 'Static preview',
        status: 'Active',
        icon: Icons.qr_code_2_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Settings',
    category: 'Settings',
    description:
        'Notification preferences, delivery channels, quiet hours, and alert categories.',
    icon: Icons.settings_outlined,
    accent: Color(0xFF475569),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'App alerts',
        value: 'On',
        note: 'Campus and academic',
        icon: Icons.notifications_active_outlined,
      ),
      StaticMetric(
        label: 'Email digest',
        value: 'Daily',
        note: '08:00 PM',
        icon: Icons.mark_email_read_outlined,
      ),
      StaticMetric(
        label: 'Quiet hours',
        value: '10 PM',
        note: 'Until 07:00 AM',
        icon: Icons.notifications_paused_outlined,
      ),
    ],
    actions: ['Toggle app alerts', 'Update email digest', 'Set quiet hours'],
    records: [
      StaticRecord(
        title: 'Assignment reminders',
        subtitle: 'Deadline and submission alerts',
        meta: 'App and email',
        status: 'On',
        icon: Icons.assignment_late_outlined,
      ),
      StaticRecord(
        title: 'Payment alerts',
        subtitle: 'Due, receipt, and clearance notifications',
        meta: 'App, SMS, email',
        status: 'Enabled',
        icon: Icons.payments_outlined,
      ),
      StaticRecord(
        title: 'Campus notice digest',
        subtitle: 'Daily summary for university notices',
        meta: '08:00 PM',
        status: 'Scheduled',
        icon: Icons.campaign_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Student Support',
    category: 'Campus',
    description:
        'Support tickets, administration contact, issue reporting, ticket status, and response tracking.',
    icon: Icons.support_agent_outlined,
    accent: Color(0xFF2563EB),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'Open tickets',
        value: '29',
        note: '7 high priority',
        icon: Icons.confirmation_number_outlined,
      ),
      StaticMetric(
        label: 'Avg response',
        value: '4h',
        note: 'This week',
        icon: Icons.timer_outlined,
      ),
      StaticMetric(
        label: 'Resolved',
        value: '82%',
        note: 'Monthly rate',
        icon: Icons.task_alt_outlined,
      ),
    ],
    actions: ['Submit ticket', 'Contact admin', 'Report problem'],
    records: [
      StaticRecord(
        title: 'ID card reissue',
        subtitle: 'Student Affairs assigned',
        meta: 'Ticket #1042',
        status: 'Open',
        icon: Icons.badge_outlined,
      ),
      StaticRecord(
        title: 'Portal login issue',
        subtitle: 'Password reset link delivered',
        meta: 'Ticket #1037',
        status: 'Resolved',
        icon: Icons.lock_reset_outlined,
      ),
      StaticRecord(
        title: 'Payment receipt mismatch',
        subtitle: 'Accounts team reviewing',
        meta: 'High priority',
        status: 'Review',
        icon: Icons.receipt_long_outlined,
      ),
    ],
  ),
  StaticFeature(
    title: 'Semester Courses',
    category: 'Academic',
    description:
        'Registered courses, credit hours, assigned teachers, materials, and semester overview.',
    icon: Icons.menu_book_outlined,
    accent: Color(0xFF0EA5E9),
    access: allPortalRoles,
    metrics: [
      StaticMetric(
        label: 'Courses',
        value: '6',
        note: '18 credit hours',
        icon: Icons.library_books_outlined,
      ),
      StaticMetric(
        label: 'Teachers',
        value: '5',
        note: 'One shared lab',
        icon: Icons.co_present_outlined,
      ),
      StaticMetric(
        label: 'Materials',
        value: '42',
        note: 'Slides and files',
        icon: Icons.folder_copy_outlined,
      ),
    ],
    actions: ['View courses', 'Download material', 'Contact teacher'],
    records: [
      StaticRecord(
        title: 'CSE 410',
        subtitle: 'Artificial Intelligence with Dr. Karim',
        meta: '3 credits',
        status: 'Running',
        icon: Icons.psychology_outlined,
      ),
      StaticRecord(
        title: 'CSE 420',
        subtitle: 'Software Engineering with Nusrat Jahan',
        meta: '3 credits',
        status: 'Running',
        icon: Icons.engineering_outlined,
      ),
      StaticRecord(
        title: 'MAT 301',
        subtitle: 'Numerical Methods with Dr. Alam',
        meta: '3 credits',
        status: 'Running',
        icon: Icons.calculate_outlined,
      ),
    ],
  ),
];
