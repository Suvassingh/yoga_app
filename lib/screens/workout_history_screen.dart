import 'package:flutter/material.dart';
import '../models/workout_session.dart';
import '../services/history_service.dart';
import '../utils/app_theme.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  List<WorkoutSession> _sessions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sessions = await HistoryService.loadAll();
    if (mounted) setState(() { _sessions = sessions; _loading = false; });
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.card,
        title: const Text('Clear History', style: TextStyle(color: Colors.white)),
        content: const Text('Delete all workout history? This cannot be undone.',
            style: TextStyle(color: Colors.white60)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await HistoryService.clearAll();
      _load();
    }
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // Summary totals
  int get _totalReps => _sessions.fold(0, (a, s) => a + s.repsCompleted);
  double get _totalCalories =>
      _sessions.fold(0.0, (a, s) => a + s.caloriesBurned);
  int get _totalMinutes =>
      _sessions.fold(0, (a, s) => a + s.duration.inMinutes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Workout History'),
        actions: [
          if (_sessions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: _clearAll,
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.accent))
          : _sessions.isEmpty
              ? _buildEmpty()
              : Column(
                  children: [
                    _buildSummaryHeader(),
                    Expanded(child: _buildList()),
                  ],
                ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 72, color: Colors.white12),
          const SizedBox(height: 16),
          const Text('No workouts yet',
              style: TextStyle(color: Colors.white38, fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Complete your first exercise to see it here',
              style: TextStyle(color: Colors.white24, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xff003d6b)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statCol('${_sessions.length}', 'Sessions', Icons.fitness_center),
          _divider(),
          _statCol('$_totalReps', 'Total Reps', Icons.repeat_rounded),
          _divider(),
          _statCol(
              '${_totalCalories.toStringAsFixed(0)} kcal', 'Calories',
              Icons.local_fire_department),
          _divider(),
          _statCol('$_totalMinutes min', 'Active', Icons.timer_rounded),
        ],
      ),
    );
  }

  Widget _statCol(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 10)),
      ],
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 40, color: Colors.white12);

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      itemCount: _sessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final s = _sessions[i];
        final goalReached =
            s.targetReps > 0 && s.repsCompleted >= s.targetReps;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(16),
            border: goalReached
                ? Border.all(color: AppTheme.goodForm.withOpacity(0.4))
                : null,
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  goalReached
                      ? Icons.emoji_events_rounded
                      : Icons.fitness_center_rounded,
                  color: goalReached ? AppTheme.goodForm : AppTheme.accent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.exerciseTitle,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(s.completedAt),
                      style:
                          const TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${s.repsCompleted} reps',
                      style: const TextStyle(
                          color: AppTheme.accent,
                          fontWeight: FontWeight.w800,
                          fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(
                    '${s.caloriesBurned.toStringAsFixed(1)} kcal  •  ${_formatDuration(s.duration)}',
                    style:
                        const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
