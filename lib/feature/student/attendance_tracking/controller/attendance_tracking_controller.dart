import 'package:eub_connect/core/demo/demo_models.dart';
import 'package:eub_connect/core/demo/demo_store.dart';
import 'package:eub_connect/feature/student/attendance_tracking/model/attendance_tracking_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceTrackingController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const AttendanceTrackingModel().obs;
  final selectedCourseIndex = 0.obs;
  Worker? _demoRevisionWorker;

  @override
  void onInit() {
    super.onInit();
    _syncFromStore();
    _demoRevisionWorker = ever(DemoStore.instance.revision, (_) {
      _syncFromStore();
    });
  }

  CourseAttendance get selectedCourse {
    final courses = model.value.courses;
    if (courses.isEmpty) {
      throw StateError('No attendance courses available');
    }
    var index = selectedCourseIndex.value;
    if (index < 0) {
      index = 0;
    }
    if (index >= courses.length) {
      index = courses.length - 1;
    }
    return courses[index];
  }

  void selectCourse(int index) {
    final courses = model.value.courses;
    if (index < 0 || index >= courses.length) {
      return;
    }
    selectedCourseIndex.value = index;
  }

  void _syncFromStore() {
    final store = DemoStore.instance;
    final student = store.currentAccount;
    if (student == null) {
      return;
    }
    final sectionIds = store.enrolledSectionIds(student.id);
    final courses = <CourseAttendance>[];
    for (final sectionId in sectionIds) {
      final subject = store.subjectForSection(sectionId);
      final sectionSchedules = store.schedules
          .where((schedule) => schedule.sectionId == sectionId)
          .toList();
      final room = sectionSchedules.isEmpty
          ? 'Room pending'
          : sectionSchedules
                .map((schedule) => schedule.room)
                .toSet()
                .join(', ');
      final rows = store.attendance.where((record) {
        return record.studentId == student.id && record.sectionId == sectionId;
      }).toList();
      rows.sort((a, b) => a.date.compareTo(b.date));
      courses.add(
        CourseAttendance(
          code: subject.code,
          title: subject.name,
          teacher: subject.teacher,
          room: room,
          days: rows.map(_attendanceDay).toList(),
        ),
      );
    }
    model.value = AttendanceTrackingModel(courses: courses);
    if (selectedCourseIndex.value >= courses.length) {
      selectedCourseIndex.value = courses.isEmpty ? 0 : courses.length - 1;
    }
  }

  AttendanceDay _attendanceDay(DemoAttendanceRecord record) {
    return AttendanceDay(
      date: DateFormat('MMM dd, yyyy').format(record.date),
      weekday: DateFormat('EEEE').format(record.date),
      slot: record.slot,
      status: _status(record.status),
      note: record.note,
    );
  }

  AttendanceDayStatus _status(DemoAttendanceStatus status) {
    switch (status) {
      case DemoAttendanceStatus.present:
        return AttendanceDayStatus.present;
      case DemoAttendanceStatus.absent:
        return AttendanceDayStatus.absent;
      case DemoAttendanceStatus.late:
        return AttendanceDayStatus.late;
      case DemoAttendanceStatus.excused:
        return AttendanceDayStatus.excused;
    }
  }

  @override
  void onClose() {
    _demoRevisionWorker?.dispose();
    super.onClose();
  }
}
