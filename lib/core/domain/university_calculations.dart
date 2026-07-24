class GradeItem {
  const GradeItem({required this.credits, required this.gradePoint});

  final num credits;
  final num gradePoint;
}

class AttendanceSummary {
  const AttendanceSummary({required this.attended, required this.total});

  final int attended;
  final int total;

  double get percentage {
    if (total <= 0) {
      return 0;
    }
    return (attended / total) * 100;
  }
}

class ScheduleSlot {
  const ScheduleSlot({
    required this.dayOfWeek,
    required this.startsAtMinutes,
    required this.endsAtMinutes,
    this.roomId,
    this.teacherId,
    this.sectionId,
  });

  final int dayOfWeek;
  final int startsAtMinutes;
  final int endsAtMinutes;
  final String? roomId;
  final String? teacherId;
  final String? sectionId;

  bool overlaps(ScheduleSlot other) {
    if (dayOfWeek != other.dayOfWeek) {
      return false;
    }
    return startsAtMinutes < other.endsAtMinutes &&
        endsAtMinutes > other.startsAtMinutes;
  }

  bool conflictsWith(ScheduleSlot other) {
    if (!overlaps(other)) {
      return false;
    }
    return _sameNonNull(roomId, other.roomId) ||
        _sameNonNull(teacherId, other.teacherId) ||
        _sameNonNull(sectionId, other.sectionId);
  }

  bool _sameNonNull(String? left, String? right) {
    return left != null && right != null && left == right;
  }
}

double calculateGpa(List<GradeItem> items) {
  final validItems = items.where((item) => item.credits > 0).toList();
  if (validItems.isEmpty) {
    return 0;
  }

  final totalCredits = validItems.fold<num>(
    0,
    (sum, item) => sum + item.credits,
  );
  final weightedPoints = validItems.fold<num>(
    0,
    (sum, item) => sum + (item.credits * item.gradePoint),
  );

  return double.parse((weightedPoints / totalCredits).toStringAsFixed(2));
}

num calculateTuitionDue({
  required num totalAmount,
  required num waiverAmount,
  required num previousBalance,
  required num paidAmount,
}) {
  final due = totalAmount - waiverAmount + previousBalance - paidAmount;
  return due < 0 ? 0 : due;
}

num scoreSingleChoiceQuiz({
  required Map<String, String> correctOptionByQuestion,
  required Map<String, String> selectedOptionByQuestion,
  required Map<String, num> marksByQuestion,
}) {
  num score = 0;
  for (final entry in correctOptionByQuestion.entries) {
    if (selectedOptionByQuestion[entry.key] == entry.value) {
      score += marksByQuestion[entry.key] ?? 0;
    }
  }
  return score;
}

List<ScheduleSlot> findScheduleConflicts(List<ScheduleSlot> slots) {
  final conflicts = <ScheduleSlot>{};
  for (var i = 0; i < slots.length; i++) {
    for (var j = i + 1; j < slots.length; j++) {
      if (slots[i].conflictsWith(slots[j])) {
        conflicts.add(slots[i]);
        conflicts.add(slots[j]);
      }
    }
  }
  return conflicts.toList();
}
