/// Domain Model: Represents a single habit and its completion history.
///
/// In app development, the **Model** is the definition of what data looks like.
/// It doesn't know about buttons, screens, or databases—it just holds pure data
/// and helper methods to inspect that data.
class Habit {
  final String id;
  final String title;
  final String description;
  final int iconCodePoint; // Unicode code point for Flutter Icons
  final int colorValue;    // 32-bit ARGB integer for Flutter Color
  final DateTime createdAt;
  final List<String> completedDates; // Format: 'YYYY-MM-DD' for date consistency

  const Habit({
    required this.id,
    required this.title,
    this.description = '',
    required this.iconCodePoint,
    required this.colorValue,
    required this.createdAt,
    this.completedDates = const [],
  });

  /// Helper to convert a [DateTime] into a normalized date string: "YYYY-MM-DD"
  /// This ignores time (hours/minutes/seconds) so any completion on the same day counts.
  static String dateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Checks if the habit was completed today.
  bool isCompletedToday() {
    return isCompletedOn(DateTime.now());
  }

  /// Checks if the habit was completed on a specific calendar date.
  bool isCompletedOn(DateTime date) {
    return completedDates.contains(dateKey(date));
  }

  /// Calculates the current consecutive daily streak.
  ///
  /// Streak Logic:
  /// - If completed today, start counting backward from today.
  /// - If not completed today, start counting backward from yesterday (streak not broken yet today).
  /// - If yesterday was also missed, streak is 0.
  int get currentStreak {
    if (completedDates.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    DateTime checkDate;
    if (isCompletedOn(today)) {
      checkDate = today;
    } else if (isCompletedOn(yesterday)) {
      checkDate = yesterday;
    } else {
      return 0; // Missed today and yesterday -> streak broken
    }

    int streak = 0;
    while (isCompletedOn(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  /// Creates a copy of this habit with modified fields (Immutability pattern).
  Habit copyWith({
    String? id,
    String? title,
    String? description,
    int? iconCodePoint,
    int? colorValue,
    DateTime? createdAt,
    List<String>? completedDates,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
      completedDates: completedDates ?? this.completedDates,
    );
  }

  /// **Serialization**: Converts Dart Object -> JSON Map (for saving to disk/cloud)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconCodePoint': iconCodePoint,
      'colorValue': colorValue,
      'createdAt': createdAt.toIso8601String(),
      'completedDates': completedDates,
    };
  }

  /// **Deserialization**: Converts JSON Map -> Dart Object (for loading from disk/cloud)
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      iconCodePoint: json['iconCodePoint'] as int,
      colorValue: json['colorValue'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedDates: List<String>.from(json['completedDates'] as List? ?? []),
    );
  }
}
