import 'package:eub_connect/core/constant/app_color/app_colors.dart';
import 'package:eub_connect/core/ui/state_panels.dart';
import 'package:eub_connect/feature/student/attendance_tracking/controller/attendance_tracking_controller.dart';
import 'package:eub_connect/feature/student/attendance_tracking/model/attendance_tracking_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceTrackingScreen extends StatelessWidget {
  const AttendanceTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AttendanceTrackingController>()
        ? Get.find<AttendanceTrackingController>()
        : Get.put(AttendanceTrackingController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        surfaceTintColor: AppColors.white,
        leading: BackButton(onPressed: () => Get.back()),
        title: const Text('Attendance'),
      ),
      body: Obx(() {
        final model = controller.model.value;
        if (model.courses.isEmpty) {
          return const SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: EmptyStatePanel(
              title: 'No attendance records',
              message:
                  'This demo account does not have enrolled course attendance yet.',
              icon: Icons.how_to_reg_outlined,
            ),
          );
        }
        final selectedCourse = controller.selectedCourse;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _AttendanceHeader(model: model),
                  const SizedBox(height: 14),
                  _AttendanceSummaryGrid(model: model),
                  const SizedBox(height: 14),
                  _CourseSelector(
                    courses: model.courses,
                    selectedIndex: controller.selectedCourseIndex.value,
                    onSelected: controller.selectCourse,
                  ),
                  const SizedBox(height: 14),
                  _CourseAttendancePanel(course: selectedCourse),
                  const SizedBox(height: 14),
                  _MissedDaysPanel(courses: model.courses),
                  const SizedBox(height: 14),
                  _AttendanceTimeline(course: selectedCourse),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _AttendanceHeader extends StatelessWidget {
  const _AttendanceHeader({required this.model});

  final AttendanceTrackingModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.how_to_reg_outlined,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attendance Tracking',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${model.missedClasses} missed classes across ${model.courses.length} courses',
                  style: const TextStyle(color: Color(0xFF667085)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceSummaryGrid extends StatelessWidget {
  const _AttendanceSummaryGrid({required this.model});

  final AttendanceTrackingModel model;

  @override
  Widget build(BuildContext context) {
    final items = [
      _AttendanceSummaryItem(
        label: 'Overall',
        value: '${model.overallPercentage.round()}%',
        icon: Icons.query_stats_outlined,
        color: AppColors.primary,
      ),
      _AttendanceSummaryItem(
        label: 'Attended',
        value: '${model.attendedClasses}',
        icon: Icons.check_circle_outline,
        color: AppColors.secondary,
      ),
      _AttendanceSummaryItem(
        label: 'Missed',
        value: '${model.missedClasses}',
        icon: Icons.cancel_outlined,
        color: const Color(0xFFB42318),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 720 ? 3 : 1;
        return GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 94,
          ),
          itemBuilder: (context, index) => items[index],
        );
      },
    );
  }
}

class _AttendanceSummaryItem extends StatelessWidget {
  const _AttendanceSummaryItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseSelector extends StatelessWidget {
  const _CourseSelector({
    required this.courses,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<CourseAttendance> courses;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final course = courses[index];
          final selected = index == selectedIndex;
          return ChoiceChip(
            selected: selected,
            label: Text(course.code),
            avatar: Icon(
              Icons.menu_book_outlined,
              size: 18,
              color: selected ? AppColors.white : AppColors.primary,
            ),
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(
              color: selected ? AppColors.white : AppColors.textDark,
              fontWeight: FontWeight.w800,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFFE3E6EA)),
            ),
            onSelected: (_) => onSelected(index),
          );
        },
      ),
    );
  }
}

class _CourseAttendancePanel extends StatelessWidget {
  const _CourseAttendancePanel({required this.course});

  final CourseAttendance course;

  @override
  Widget build(BuildContext context) {
    final percent = course.percentage.clamp(0, 100) / 100;
    final riskColor = course.percentage >= 80
        ? AppColors.secondary
        : const Color(0xFFB42318);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.code,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      course.title,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${course.teacher} - ${course.room}',
                      style: const TextStyle(color: Color(0xFF667085)),
                    ),
                  ],
                ),
              ),
              _StatusBadge(
                label: '${course.percentage.round()}%',
                color: riskColor,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: percent.toDouble(),
              minHeight: 9,
              backgroundColor: const Color(0xFFE3E6EA),
              valueColor: AlwaysStoppedAnimation<Color>(riskColor),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusBadge(
                label: '${course.present} present',
                color: AppColors.secondary,
              ),
              _StatusBadge(
                label: '${course.absent} absent',
                color: const Color(0xFFB42318),
              ),
              _StatusBadge(
                label: '${course.late} late',
                color: const Color(0xFFCA8A04),
              ),
              _StatusBadge(
                label: '${course.excused} excused',
                color: const Color(0xFF0D9488),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MissedDaysPanel extends StatelessWidget {
  const _MissedDaysPanel({required this.courses});

  final List<CourseAttendance> courses;

  @override
  Widget build(BuildContext context) {
    final missedEntries = <({CourseAttendance course, AttendanceDay day})>[];
    for (final course in courses) {
      for (final day in course.missedDays) {
        missedEntries.add((course: course, day: day));
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PanelTitle(
            title: 'Missed Classes',
            subtitle: 'Dates where attendance is marked absent',
          ),
          const SizedBox(height: 12),
          if (missedEntries.isEmpty)
            const Text(
              'No missed classes found.',
              style: TextStyle(color: Color(0xFF667085)),
            )
          else
            for (final entry in missedEntries)
              _AttendanceDayTile(
                courseCode: entry.course.code,
                day: entry.day,
                compact: true,
              ),
        ],
      ),
    );
  }
}

class _AttendanceTimeline extends StatelessWidget {
  const _AttendanceTimeline({required this.course});

  final CourseAttendance course;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelTitle(
            title: '${course.code} Timeline',
            subtitle: 'All recorded attendance days',
          ),
          const SizedBox(height: 12),
          for (final day in course.days)
            _AttendanceDayTile(courseCode: course.code, day: day),
        ],
      ),
    );
  }
}

class _AttendanceDayTile extends StatelessWidget {
  const _AttendanceDayTile({
    required this.courseCode,
    required this.day,
    this.compact = false,
  });

  final String courseCode;
  final AttendanceDay day;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = _attendanceStatusColor(day.status);
    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 8 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _attendanceStatusIcon(day.status),
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '$courseCode - ${day.date}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(
                      label: _attendanceStatusLabel(day.status),
                      color: color,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${day.weekday}, ${day.slot}',
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  day.note,
                  style: const TextStyle(color: Color(0xFF667085), height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PanelTitle extends StatelessWidget {
  const _PanelTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF667085), fontSize: 13),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          height: 1.15,
        ),
      ),
    );
  }
}

String _attendanceStatusLabel(AttendanceDayStatus status) {
  switch (status) {
    case AttendanceDayStatus.present:
      return 'Present';
    case AttendanceDayStatus.absent:
      return 'Absent';
    case AttendanceDayStatus.late:
      return 'Late';
    case AttendanceDayStatus.excused:
      return 'Excused';
  }
}

Color _attendanceStatusColor(AttendanceDayStatus status) {
  switch (status) {
    case AttendanceDayStatus.present:
      return AppColors.secondary;
    case AttendanceDayStatus.absent:
      return const Color(0xFFB42318);
    case AttendanceDayStatus.late:
      return const Color(0xFFCA8A04);
    case AttendanceDayStatus.excused:
      return const Color(0xFF0D9488);
  }
}

IconData _attendanceStatusIcon(AttendanceDayStatus status) {
  switch (status) {
    case AttendanceDayStatus.present:
      return Icons.check_circle_outline;
    case AttendanceDayStatus.absent:
      return Icons.cancel_outlined;
    case AttendanceDayStatus.late:
      return Icons.schedule_outlined;
    case AttendanceDayStatus.excused:
      return Icons.medical_information_outlined;
  }
}
