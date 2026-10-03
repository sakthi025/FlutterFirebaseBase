import 'package:flutter/material.dart';
import '../../state/habit_notifier.dart';
import '../widgets/add_habit_dialog.dart';
import '../widgets/habit_card.dart';
import '../widgets/streak_summary.dart';

/// Presentation Screen: Main dashboard of the app.
///
/// Teaches:
/// - ListenableBuilder: Reactively updates the UI whenever the ViewModel notifies of changes.
/// - Modular widget composition: Assembles the screen from smaller widgets.
/// - Modal bottom sheet invocation: `showModalBottomSheet`.
class HomeScreen extends StatelessWidget {
  final HabitNotifier notifier;

  const HomeScreen({super.key, required this.notifier});

  void _showAddHabitSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return AddHabitDialog(
          onAdd: ({
            required String title,
            required String description,
            required int iconCodePoint,
            required int colorValue,
          }) {
            notifier.addHabit(
              title: title,
              description: description,
              iconCodePoint: iconCodePoint,
              colorValue: colorValue,
            );
          },
        );
      },
    );
  }

  void _showArchitectureInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.architecture_rounded, color: Colors.indigo),
            SizedBox(width: 8),
            Text('App Architecture'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This app demonstrates 4 core software engineering layers:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Text('• 1. Domain Model (Habit.dart): Pure data representation & streak calculation logic.'),
              SizedBox(height: 6),
              Text('• 2. Storage Service (SharedPreferences): Reads & writes JSON to device disk.'),
              SizedBox(height: 6),
              Text('• 3. State Notifier (HabitNotifier): Holds reactive state and notifies UI of changes.'),
              SizedBox(height: 6),
              Text('• 4. UI Layer (Widgets & Screens): Declarative, beautiful presentation components.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.bolt_rounded, color: Colors.amber, size: 28),
            SizedBox(width: 6),
            Text(
              'HabitPulse',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'Architecture Info',
            onPressed: () => _showArchitectureInfo(context),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: notifier,
        builder: (context, _) {
          if (notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final habits = notifier.habits;

          return CustomScrollView(
            slivers: [
              // Hero Progress & Streak Card
              SliverToBoxAdapter(
                child: StreakSummary(notifier: notifier),
              ),

              // Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MY HABITS',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${habits.length} habits',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Empty State or List of Habit Cards
              if (habits.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.eco_rounded,
                          size: 64,
                          color: theme.colorScheme.outlineVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No habits yet!',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap + below to create your first daily habit.',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final habit = habits[index];
                      return HabitCard(
                        habit: habit,
                        onToggle: () => notifier.toggleHabitCompletion(habit.id),
                        onDelete: () => notifier.deleteHabit(habit.id),
                      );
                    },
                    childCount: habits.length,
                  ),
                ),

              // Bottom padding so floating button doesn't obscure the last card
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddHabitSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Habit', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
