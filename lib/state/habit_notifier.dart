import 'package:flutter/foundation.dart';
import '../models/habit.dart';
import '../services/habit_storage_service.dart';

/// State Management Layer (ViewModel / Notifier):
///
/// In modern software architecture, you NEVER put business logic inside button click listeners.
/// Instead, the UI calls methods on the [ChangeNotifier], and whenever the data updates,
/// `notifyListeners()` automatically triggers the UI to re-render.
class HabitNotifier extends ChangeNotifier {
  final HabitStorageService _storageService;

  List<Habit> _habits = [];
  bool _isLoading = true;

  HabitNotifier({HabitStorageService? storageService})
      : _storageService = storageService ?? HabitStorageService() {
    _init();
  }

  // --- Getters: Expose state as read-only to the UI ---

  List<Habit> get habits => List.unmodifiable(_habits);
  bool get isLoading => _isLoading;

  /// Number of habits marked completed today
  int get completedTodayCount {
    return _habits.where((h) => h.isCompletedToday()).length;
  }

  /// Total number of habits
  int get totalHabitsCount => _habits.length;

  /// Progress ratio from 0.0 to 1.0 (for progress bars and circular rings)
  double get todayCompletionRatio {
    if (_habits.isEmpty) return 0.0;
    return completedTodayCount / totalHabitsCount;
  }

  /// Highest active streak among all habits
  int get bestCurrentStreak {
    if (_habits.isEmpty) return 0;
    return _habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b);
  }

  // --- Actions / Mutators: Methods the UI can call ---

  /// Initialize and load saved habits on app start
  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    _habits = await _storageService.loadHabits();
    _isLoading = false;
    notifyListeners();
  }

  /// Toggles completion status for today for a specific habit
  Future<void> toggleHabitCompletion(String habitId) async {
    final todayKey = Habit.dateKey(DateTime.now());

    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index == -1) return;

    final habit = _habits[index];
    final updatedDates = List<String>.from(habit.completedDates);

    if (updatedDates.contains(todayKey)) {
      updatedDates.remove(todayKey); // Uncheck
    } else {
      updatedDates.add(todayKey); // Check
    }

    _habits[index] = habit.copyWith(completedDates: updatedDates);
    notifyListeners(); // Immediate UI update for instant snappiness

    await _storageService.saveHabits(_habits); // Persist to disk asynchronously
  }

  /// Adds a new custom habit
  Future<void> addHabit({
    required String title,
    String description = '',
    required int iconCodePoint,
    required int colorValue,
  }) async {
    final newHabit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      description: description.trim(),
      iconCodePoint: iconCodePoint,
      colorValue: colorValue,
      createdAt: DateTime.now(),
      completedDates: [],
    );

    _habits.insert(0, newHabit); // Add to the top of list
    notifyListeners();

    await _storageService.saveHabits(_habits);
  }

  /// Deletes a habit
  Future<void> deleteHabit(String habitId) async {
    _habits.removeWhere((h) => h.id == habitId);
    notifyListeners();

    await _storageService.saveHabits(_habits);
  }
}
