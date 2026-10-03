import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_firebase_base/models/habit.dart';

void main() {
  group('Habit Model & Streak Logic Tests', () {
    test('Habit serialization to and from JSON preserves all fields', () {
      final now = DateTime.now();
      final habit = Habit(
        id: 'test-101',
        title: 'Morning Run',
        description: '5km jog',
        iconCodePoint: 12345,
        colorValue: 0xFF4CAF50,
        createdAt: now,
        completedDates: ['2026-10-01', '2026-10-02'],
      );

      final json = habit.toJson();
      final reconstructed = Habit.fromJson(json);

      expect(reconstructed.id, equals('test-101'));
      expect(reconstructed.title, equals('Morning Run'));
      expect(reconstructed.description, equals('5km jog'));
      expect(reconstructed.iconCodePoint, equals(12345));
      expect(reconstructed.colorValue, equals(0xFF4CAF50));
      expect(reconstructed.completedDates, equals(['2026-10-01', '2026-10-02']));
    });

    test('currentStreak calculates consecutive completed days accurately', () {
      final now = DateTime.now();
      final todayKey = Habit.dateKey(now);
      final yesterdayKey = Habit.dateKey(now.subtract(const Duration(days: 1)));
      final twoDaysAgoKey = Habit.dateKey(now.subtract(const Duration(days: 2)));

      // 3 consecutive days completed (two days ago, yesterday, today)
      final habit = Habit(
        id: '1',
        title: 'Meditation',
        iconCodePoint: 100,
        colorValue: 0xFFFFFFFF,
        createdAt: now,
        completedDates: [twoDaysAgoKey, yesterdayKey, todayKey],
      );

      expect(habit.isCompletedToday(), isTrue);
      expect(habit.currentStreak, equals(3));
    });

    test('currentStreak holds count if completed yesterday but not yet today', () {
      final now = DateTime.now();
      final yesterdayKey = Habit.dateKey(now.subtract(const Duration(days: 1)));
      final twoDaysAgoKey = Habit.dateKey(now.subtract(const Duration(days: 2)));

      // Completed yesterday & two days ago, but not today yet
      final habit = Habit(
        id: '2',
        title: 'Drink Water',
        iconCodePoint: 100,
        colorValue: 0xFFFFFFFF,
        createdAt: now,
        completedDates: [twoDaysAgoKey, yesterdayKey],
      );

      expect(habit.isCompletedToday(), isFalse);
      expect(habit.currentStreak, equals(2)); // Streak is not broken until the day ends
    });

    test('currentStreak resets to 0 if yesterday was missed', () {
      final now = DateTime.now();
      final threeDaysAgoKey = Habit.dateKey(now.subtract(const Duration(days: 3)));

      final habit = Habit(
        id: '3',
        title: 'Reading',
        iconCodePoint: 100,
        colorValue: 0xFFFFFFFF,
        createdAt: now,
        completedDates: [threeDaysAgoKey],
      );

      expect(habit.isCompletedToday(), isFalse);
      expect(habit.currentStreak, equals(0)); // Broken streak
    });
  });
}
