import 'package:eub_connect/feature/home/model/static_feature.dart';

enum AttendanceDayStatus { present, absent, late, excused }

class AttendanceDay {
  const AttendanceDay({
    required this.date,
    required this.weekday,
    required this.slot,
    required this.status,
    required this.note,
  });

  final String date;
  final String weekday;
  final String slot;
  final AttendanceDayStatus status;
  final String note;
}

class CourseAttendance {
  const CourseAttendance({
    required this.code,
    required this.title,
    required this.teacher,
    required this.room,
    required this.days,
  });

  final String code;
  final String title;
  final String teacher;
  final String room;
  final List<AttendanceDay> days;

  int get total => days.length;
  int get present => _count(AttendanceDayStatus.present);
  int get absent => _count(AttendanceDayStatus.absent);
  int get late => _count(AttendanceDayStatus.late);
  int get excused => _count(AttendanceDayStatus.excused);
  int get attended => present + late + excused;
  double get percentage => total == 0 ? 0 : (attended / total) * 100;

  List<AttendanceDay> get missedDays {
    return days
        .where((day) => day.status == AttendanceDayStatus.absent)
        .toList();
  }

  int _count(AttendanceDayStatus status) {
    return days.where((day) => day.status == status).length;
  }
}

class AttendanceTrackingModel extends FeatureModuleModel {
  const AttendanceTrackingModel()
    : super(title: 'Attendance', category: 'Student');

  List<CourseAttendance> get courses => studentAttendanceCourses;

  int get totalClasses {
    return courses.fold(0, (total, course) => total + course.total);
  }

  int get attendedClasses {
    return courses.fold(0, (total, course) => total + course.attended);
  }

  int get missedClasses {
    return courses.fold(0, (total, course) => total + course.absent);
  }

  double get overallPercentage {
    if (totalClasses == 0) {
      return 0;
    }
    return (attendedClasses / totalClasses) * 100;
  }

  List<AttendanceDay> get missedDays {
    return courses.expand((course) => course.missedDays).toList();
  }
}

const studentAttendanceCourses = [
  CourseAttendance(
    code: 'CSE 410',
    title: 'Artificial Intelligence',
    teacher: 'Dr. Karim',
    room: 'Room 604',
    days: [
      AttendanceDay(
        date: 'Jul 04, 2026',
        weekday: 'Saturday',
        slot: '09:00 AM',
        status: AttendanceDayStatus.present,
        note: 'Checked in by QR',
      ),
      AttendanceDay(
        date: 'Jul 07, 2026',
        weekday: 'Tuesday',
        slot: '09:00 AM',
        status: AttendanceDayStatus.absent,
        note: 'Missed AI lecture',
      ),
      AttendanceDay(
        date: 'Jul 11, 2026',
        weekday: 'Saturday',
        slot: '09:00 AM',
        status: AttendanceDayStatus.late,
        note: 'Entered 8 minutes late',
      ),
      AttendanceDay(
        date: 'Jul 14, 2026',
        weekday: 'Tuesday',
        slot: '09:00 AM',
        status: AttendanceDayStatus.present,
        note: 'Class quiz attended',
      ),
      AttendanceDay(
        date: 'Jul 18, 2026',
        weekday: 'Saturday',
        slot: '09:00 AM',
        status: AttendanceDayStatus.present,
        note: 'Lab briefing attended',
      ),
    ],
  ),
  CourseAttendance(
    code: 'CSE 420',
    title: 'Software Engineering',
    teacher: 'Nusrat Jahan',
    room: 'Room 502',
    days: [
      AttendanceDay(
        date: 'Jul 05, 2026',
        weekday: 'Sunday',
        slot: '11:00 AM',
        status: AttendanceDayStatus.present,
        note: 'Sprint planning class',
      ),
      AttendanceDay(
        date: 'Jul 09, 2026',
        weekday: 'Thursday',
        slot: '11:00 AM',
        status: AttendanceDayStatus.present,
        note: 'Group task submitted',
      ),
      AttendanceDay(
        date: 'Jul 12, 2026',
        weekday: 'Sunday',
        slot: '11:00 AM',
        status: AttendanceDayStatus.absent,
        note: 'Missed design review',
      ),
      AttendanceDay(
        date: 'Jul 16, 2026',
        weekday: 'Thursday',
        slot: '11:00 AM',
        status: AttendanceDayStatus.excused,
        note: 'Medical application approved',
      ),
      AttendanceDay(
        date: 'Jul 19, 2026',
        weekday: 'Sunday',
        slot: '11:00 AM',
        status: AttendanceDayStatus.present,
        note: 'Prototype class attended',
      ),
    ],
  ),
  CourseAttendance(
    code: 'MAT 301',
    title: 'Numerical Methods',
    teacher: 'Dr. Alam',
    room: 'Room 302',
    days: [
      AttendanceDay(
        date: 'Jul 06, 2026',
        weekday: 'Monday',
        slot: '02:00 PM',
        status: AttendanceDayStatus.present,
        note: 'Interpolation lecture',
      ),
      AttendanceDay(
        date: 'Jul 08, 2026',
        weekday: 'Wednesday',
        slot: '02:00 PM',
        status: AttendanceDayStatus.present,
        note: 'Lab worksheet submitted',
      ),
      AttendanceDay(
        date: 'Jul 13, 2026',
        weekday: 'Monday',
        slot: '02:00 PM',
        status: AttendanceDayStatus.absent,
        note: 'Missed numerical lab',
      ),
      AttendanceDay(
        date: 'Jul 15, 2026',
        weekday: 'Wednesday',
        slot: '02:00 PM',
        status: AttendanceDayStatus.present,
        note: 'Matrix methods class',
      ),
      AttendanceDay(
        date: 'Jul 20, 2026',
        weekday: 'Monday',
        slot: '02:00 PM',
        status: AttendanceDayStatus.present,
        note: 'Quiz preparation',
      ),
    ],
  ),
];
