import 'package:flutter/material.dart';
import '../models/workout_session.dart';
import '../services/history_service.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../services/history_service.dart';
class SessionSummaryScreen extends StatefulWidget {
  final WorkoutSession session;

  const SessionSummaryScreen({super.key, required this.session});

  @override
  State<SessionSummaryScreen> createState() => _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends State<SessionSummaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleIn;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeIn = CurvedAnimation(parent: _ac, curve: Curves.easeOut);
    _scaleIn = Tween<double>(begin: 0.8, end: 1.0)
        .animate(CurvedAnimation(parent: _ac, curve: Curves.elasticOut));
    _ac.forward();
    _saveSession();
  }

  Future<void> _saveSession() async {
    await HistoryService.save(widget.session);
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  bool get _goalReached =>
      widget.session.targetReps > 0 &&
      widget.session.repsCompleted >= widget.session.targetReps;

  @override
  Widget build(BuildContext context) {
    final s = widget.session;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Trophy / completion icon
                ScaleTransition(
                  scale: _scaleIn,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: _goalReached
                            ? [
                                AppTheme.goodForm.withOpacity(0.3),
                                AppTheme.goodForm.withOpacity(0.05),
                              ]
                            : [
                                AppTheme.primary.withOpacity(0.3),
                                AppTheme.primary.withOpacity(0.05),
                              ],
                      ),
                      border: Border.all(
                        color: _goalReached
                            ? AppTheme.goodForm
                            : AppTheme.primary,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      _goalReached
                          ? Icons.emoji_events_rounded
                          : Icons.fitness_center_rounded,
                      size: 54,
                      color: _goalReached
                          ? AppTheme.goodForm
                          : AppTheme.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  _goalReached ? '🎉 Goal Reached!' : 'Workout Complete!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  s.exerciseTitle,
                  style: const TextStyle(
                    color: AppTheme.accent,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 32),

                // Stats grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    StatChip(
                      icon: Icons.repeat_rounded,
                      label: 'Reps Done',
                      value: '${s.repsCompleted}',
                      color: AppTheme.goodForm,
                    ),
                    StatChip(
                      icon: Icons.flag_rounded,
                      label: 'Target',
                      value: s.targetReps > 0 ? '${s.targetReps}' : '—',
                      color: AppTheme.accent,
                    ),
                    StatChip(
                      icon: Icons.local_fire_department_rounded,
                      label: 'Calories',
                      value: '${s.caloriesBurned.toStringAsFixed(1)} kcal',
                      color: const Color(0xffFF6B6B),
                    ),
                    StatChip(
                      icon: Icons.timer_rounded,
                      label: 'Duration',
                      value: _formatDuration(s.duration),
                      color: AppTheme.warning,
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Progress bar if goal set
                if (s.targetReps > 0) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Progress',
                          style: TextStyle(color: Colors.white70)),
                      Text(
                        '${((s.repsCompleted / s.targetReps) * 100).clamp(0, 100).round()}%',
                        style: const TextStyle(
                            color: AppTheme.accent,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (s.repsCompleted / s.targetReps).clamp(0.0, 1.0),
                      minHeight: 10,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation(
                        _goalReached ? AppTheme.goodForm : AppTheme.accent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Motivational message
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _motivationMessage(s.repsCompleted, s.targetReps),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Action buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      // Pop back to exercise list
                      Navigator.popUntil(context, (r) => r.isFirst);
                    },
                    child: const Text(
                      'Back to Exercises',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Do It Again',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _motivationMessage(int reps, int target) {
    if (target <= 0) {
      if (reps >= 20) return '"Champions are not born, they are made. You just proved it." 💪';
      if (reps >= 10) return '"Every rep counts. You showed up today — that\'s what matters." 🔥';
      return '"A journey of a thousand miles begins with a single step." 🚀';
    }
    if (reps >= target) {
      return '"You set the goal, you crushed the goal. That is what legends do." 🏆';
    }
    final pct = (reps / target * 100).round();
    if (pct >= 80) return '"So close! $pct% done. Next session — full set!" 💥';
    return '"$reps out of $target done. Every rep makes you stronger. Keep going!" 🌟';
  }
}
