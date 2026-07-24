import 'package:eub_connect/core/domain/university_calculations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('calculateGpa', () {
    test('uses credit-weighted grade points', () {
      final gpa = calculateGpa(const [
        GradeItem(credits: 3, gradePoint: 4),
        GradeItem(credits: 1.5, gradePoint: 3.5),
        GradeItem(credits: 3, gradePoint: 3),
      ]);

      expect(gpa, 3.5);
    });

    test('returns zero when there are no credits', () {
      expect(calculateGpa(const []), 0);
    });
  });

  group('AttendanceSummary', () {
    test('calculates attendance percentage', () {
      const summary = AttendanceSummary(attended: 18, total: 20);

      expect(summary.percentage, 90);
    });

    test('does not divide by zero', () {
      const summary = AttendanceSummary(attended: 0, total: 0);

      expect(summary.percentage, 0);
    });
  });

  group('calculateTuitionDue', () {
    test('subtracts waiver and payments while including previous balance', () {
      final due = calculateTuitionDue(
        totalAmount: 50000,
        waiverAmount: 5000,
        previousBalance: 2000,
        paidAmount: 30000,
      );

      expect(due, 17000);
    });

    test('never returns a negative due amount', () {
      final due = calculateTuitionDue(
        totalAmount: 10000,
        waiverAmount: 1000,
        previousBalance: 0,
        paidAmount: 20000,
      );

      expect(due, 0);
    });
  });

  group('scoreSingleChoiceQuiz', () {
    test('scores only correct answers', () {
      final score = scoreSingleChoiceQuiz(
        correctOptionByQuestion: const {'q1': 'a', 'q2': 'b'},
        selectedOptionByQuestion: const {'q1': 'a', 'q2': 'c'},
        marksByQuestion: const {'q1': 5, 'q2': 5},
      );

      expect(score, 5);
    });
  });

  group('findScheduleConflicts', () {
    test('detects room, teacher, or section overlap', () {
      final conflicts = findScheduleConflicts(const [
        ScheduleSlot(
          dayOfWeek: 1,
          startsAtMinutes: 540,
          endsAtMinutes: 600,
          roomId: '604',
          teacherId: 't1',
          sectionId: 's1',
        ),
        ScheduleSlot(
          dayOfWeek: 1,
          startsAtMinutes: 570,
          endsAtMinutes: 630,
          roomId: '604',
          teacherId: 't2',
          sectionId: 's2',
        ),
        ScheduleSlot(
          dayOfWeek: 2,
          startsAtMinutes: 570,
          endsAtMinutes: 630,
          roomId: '604',
          teacherId: 't1',
          sectionId: 's1',
        ),
      ]);

      expect(conflicts.length, 2);
    });
  });
}
