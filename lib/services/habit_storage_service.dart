import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

/// Storage Service: Manages reading and writing data to the device's disk.
///
/// In mobile apps, RAM is volatile—as soon as the app closes or the OS kills it,
/// in-memory objects are gone. Services provide persistent storage.
///
/// We use [SharedPreferences] (key-value store backed by Android SharedPreferences / iOS UserDefaults).
class HabitStorageService {
  static const String _habitsKey = 'saved_user_habits_v1';

  /// Loads all habits from local storage.
  /// If this is the user's very first time launching the app, returns initial starter habits.
  Future<List<Habit>> loadHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? habitsJsonString = prefs.getString(_habitsKey);

      if (habitsJsonString == null || habitsJsonString.isEmpty) {
        // First-time user experience: return pre-built starter habits
        return _getStarterHabits();
      }

      final List<dynamic> decodedList = jsonDecode(habitsJsonString) as List<dynamic>;
      return decodedList
          .map((item) => Habit.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error reading habits from storage: $e');
      return _getStarterHabits();
    }
  }

  /// Saves the current list of habits to local storage as a JSON string.
  Future<bool> saveHabits(List<Habit> habits) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> mapList =
          habits.map((habit) => habit.toJson()).toList();
      final String encodedJson = jsonEncode(mapList);
      return await prefs.setString(_habitsKey, encodedJson);
    } catch (e) {
      debugPrint('Error saving habits to storage: $e');
      return false;
    }
  }

  /// Default habits to delight the user on first launch
  List<Habit> _getStarterHabits() {
    final now = DateTime.now();
    final todayKey = Habit.dateKey(now);
    final yesterdayKey = Habit.dateKey(now.subtract(const Duration(days: 1)));
    final dayBeforeYesterdayKey = Habit.dateKey(now.subtract(const Duration(days: 2)));

    return [
      Habit(
        id: '1',
        title: 'Morning Meditation',
        description: '10 minutes of calm mindful breathing',
        iconCodePoint: Icons.self_improvement.codePoint,
        colorValue: Colors.indigo.toARGB32(),
        createdAt: now.subtract(const Duration(days: 7)),
        completedDates: [dayBeforeYesterdayKey, yesterdayKey, todayKey],
      ),
      Habit(
        id: '2',
        title: 'Drink 2L Water',
        description: 'Stay hydrated throughout the workday',
        iconCodePoint: Icons.water_drop_rounded.codePoint,
        colorValue: Colors.teal.toARGB32(),
        createdAt: now.subtract(const Duration(days: 5)),
        completedDates: [yesterdayKey],
      ),
      Habit(
        id: '3',
        title: 'Read 15 Pages',
        description: 'Read software or personal growth books',
        iconCodePoint: Icons.menu_book_rounded.codePoint,
        colorValue: Colors.deepOrange.toARGB32(),
        createdAt: now.subtract(const Duration(days: 10)),
        completedDates: [dayBeforeYesterdayKey, yesterdayKey],
      ),
      Habit(
        id: '4',
        title: 'Workout / Walk 30m',
        description: 'Break a sweat or get 6,000 steps',
        iconCodePoint: Icons.directions_run_rounded.codePoint,
        colorValue: Colors.pink.toARGB32(),
        createdAt: now.subtract(const Duration(days: 3)),
        completedDates: [],
      ),
    ];
  }
}
