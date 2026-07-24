import 'package:eub_connect/core/routes/app_routes.dart';
import 'package:eub_connect/feature/common/depertment_facalty_info/screen/depertment_facalty_info_screen.dart';
import 'package:eub_connect/feature/common/event_management/screen/event_management_screen.dart';
import 'package:eub_connect/feature/common/lost_found_section/screen/lost_found_section_screen.dart';
import 'package:eub_connect/feature/common/notice/screen/notice_screen.dart';
import 'package:eub_connect/feature/common/settings/screen/settings_screen.dart';
import 'package:eub_connect/feature/auth/screen/auth_screen.dart';
import 'package:eub_connect/feature/facalty/academic_calander_management/screen/academic_calander_management_screen.dart';
import 'package:eub_connect/feature/facalty/admin_facalty/screen/admin_facalty_screen.dart';
import 'package:eub_connect/feature/facalty/depertment_management/screen/depertment_management_screen.dart';
import 'package:eub_connect/feature/facalty/payment/screen/payment_screen.dart';
import 'package:eub_connect/feature/facalty/result_academic_report/screen/result_academic_report_screen.dart';
import 'package:eub_connect/feature/facalty/routine_management/screen/routine_management_screen.dart';
import 'package:eub_connect/feature/facalty/student_management/screen/student_management_screen.dart';
import 'package:eub_connect/feature/facalty/system_activity/screen/system_activity_screen.dart';
import 'package:eub_connect/feature/facalty/teacher/academic_report/screen/academic_report_screen.dart';
import 'package:eub_connect/feature/facalty/teacher/dashboard/screen/dashboard_screen.dart';
import 'package:eub_connect/feature/facalty/teacher/manage_course/assignment_and_quiz/screen/assignment_and_quiz_screen.dart';
import 'package:eub_connect/feature/facalty/teacher/manage_course/attendence_management/screen/attendence_management_screen.dart';
import 'package:eub_connect/feature/facalty/teacher/manage_course/lecture_materials/screen/lecture_materials_screen.dart';
import 'package:eub_connect/feature/facalty/teacher/manage_course/marks_result/screen/marks_result_screen.dart';
import 'package:eub_connect/feature/facalty/teacher/notice_for_student/screen/notice_for_student_screen.dart';
import 'package:eub_connect/feature/facalty/teacher_management/screen/teacher_management_screen.dart';
import 'package:eub_connect/feature/facalty/user_role_management/screen/user_role_management_screen.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:eub_connect/feature/splash/screen/splash_screen.dart';
import 'package:eub_connect/feature/student/assingment/screen/assingment_screen.dart';
import 'package:eub_connect/feature/student/attendance_tracking/screen/attendance_tracking_screen.dart';
import 'package:eub_connect/feature/student/class_routine_schedule/screen/class_routine_schedule_screen.dart';
import 'package:eub_connect/feature/student/club_community/screen/club_community_screen.dart';
import 'package:eub_connect/feature/student/event/screen/event_screen.dart';
import 'package:eub_connect/feature/student/exam_result/screen/exam_result_screen.dart';
import 'package:eub_connect/feature/student/payment_history/screen/payment_history_screen.dart';
import 'package:eub_connect/feature/student/profile/screen/profile_screen.dart';
import 'package:eub_connect/feature/student/quiz_practice/screen/quiz_practice_screen.dart';
import 'package:eub_connect/feature/student/scholershi_info/screen/scholershi_info_screen.dart';
import 'package:eub_connect/feature/student/semester_course_info/screen/semester_course_info_screen.dart';
import 'package:eub_connect/feature/student/student_discussion_forum/screen/student_discussion_forum_screen.dart';
import 'package:eub_connect/feature/student/student_support/screen/student_support_screen.dart';
import 'package:eub_connect/feature/student/tution_fee/screen/tution_fee_screen.dart';
import 'package:get/get.dart';

class AppPages {
  const AppPages._();

  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.auth, page: () => AuthScreen()),
    GetPage(name: AppRoutes.home, page: () => HomeScreen()),
    GetPage(
      name: AppRoutes.departments,
      page: () => const DepertmentFacaltyInfoScreen(),
    ),
    GetPage(name: AppRoutes.events, page: () => const EventManagementScreen()),
    GetPage(
      name: AppRoutes.lostFound,
      page: () => const LostFoundSectionScreen(),
    ),
    GetPage(name: AppRoutes.notice, page: () => const NoticeScreen()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsScreen()),
    GetPage(
      name: AppRoutes.academicCalendar,
      page: () => const AcademicCalanderManagementScreen(),
    ),
    GetPage(
      name: AppRoutes.adminFaculty,
      page: () => const AdminFacaltyScreen(),
    ),
    GetPage(
      name: AppRoutes.departmentManagement,
      page: () => const DepertmentManagementScreen(),
    ),
    GetPage(name: AppRoutes.payment, page: () => const PaymentScreen()),
    GetPage(
      name: AppRoutes.resultReport,
      page: () => const ResultAcademicReportScreen(),
    ),
    GetPage(
      name: AppRoutes.routineManagement,
      page: () => const RoutineManagementScreen(),
    ),
    GetPage(
      name: AppRoutes.studentManagement,
      page: () => const StudentManagementScreen(),
    ),
    GetPage(
      name: AppRoutes.systemActivity,
      page: () => const SystemActivityScreen(),
    ),
    GetPage(
      name: AppRoutes.teacherManagement,
      page: () => const TeacherManagementScreen(),
    ),
    GetPage(
      name: AppRoutes.userRoleManagement,
      page: () => const UserRoleManagementScreen(),
    ),
    GetPage(
      name: AppRoutes.teacherDashboard,
      page: () => const DashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.teacherAcademicReport,
      page: () => const AcademicReportScreen(),
    ),
    GetPage(
      name: AppRoutes.assignmentQuiz,
      page: () => const AssignmentAndQuizScreen(),
    ),
    GetPage(
      name: AppRoutes.attendanceManagement,
      page: () => const AttendenceManagementScreen(),
    ),
    GetPage(
      name: AppRoutes.lectureMaterials,
      page: () => const LectureMaterialsScreen(),
    ),
    GetPage(name: AppRoutes.marksResult, page: () => const MarksResultScreen()),
    GetPage(
      name: AppRoutes.noticeForStudent,
      page: () => const NoticeForStudentScreen(),
    ),
    GetPage(
      name: AppRoutes.studentAssignments,
      page: () => const AssingmentScreen(),
    ),
    GetPage(
      name: AppRoutes.studentAttendance,
      page: () => const AttendanceTrackingScreen(),
    ),
    GetPage(
      name: AppRoutes.studentClassRoutine,
      page: () => const ClassRoutineScheduleScreen(),
    ),
    GetPage(
      name: AppRoutes.studentClubCommunity,
      page: () => const ClubCommunityScreen(),
    ),
    GetPage(name: AppRoutes.studentEvents, page: () => const EventScreen()),
    GetPage(
      name: AppRoutes.studentExamResults,
      page: () => const ExamResultScreen(),
    ),
    GetPage(
      name: AppRoutes.studentPaymentHistory,
      page: () => const PaymentHistoryScreen(),
    ),
    GetPage(name: AppRoutes.studentProfile, page: () => const ProfileScreen()),
    GetPage(
      name: AppRoutes.studentQuizPractice,
      page: () => const QuizPracticeScreen(),
    ),
    GetPage(
      name: AppRoutes.studentScholarships,
      page: () => const ScholershiInfoScreen(),
    ),
    GetPage(
      name: AppRoutes.studentSemesterCourses,
      page: () => const SemesterCourseInfoScreen(),
    ),
    GetPage(
      name: AppRoutes.studentDiscussionForum,
      page: () => const StudentDiscussionForumScreen(),
    ),
    GetPage(
      name: AppRoutes.studentSupport,
      page: () => const StudentSupportScreen(),
    ),
    GetPage(
      name: AppRoutes.studentTuitionFee,
      page: () => const TutionFeeScreen(),
    ),
  ];
}
