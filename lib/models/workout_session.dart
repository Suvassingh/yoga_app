class WorkoutSession {
  final String exerciseTitle;
  final int repsCompleted;
  final int targetReps;
  final double caloriesBurned;
  final Duration duration;
  final DateTime completedAt;

  const WorkoutSession({
    required this.exerciseTitle,
    required this.repsCompleted,
    required this.targetReps,
    required this.caloriesBurned,
    required this.duration,
    required this.completedAt,
  });

  Map<String, dynamic> toJson() => {
        'exerciseTitle': exerciseTitle,
        'repsCompleted': repsCompleted,
        'targetReps': targetReps,
        'caloriesBurned': caloriesBurned,
        'durationSeconds': duration.inSeconds,
        'completedAt': completedAt.toIso8601String(),
      };

  factory WorkoutSession.fromJson(Map<String, dynamic> json) => WorkoutSession(
        exerciseTitle: json['exerciseTitle'] as String,
        repsCompleted: json['repsCompleted'] as int,
        targetReps: json['targetReps'] as int,
        caloriesBurned: (json['caloriesBurned'] as num).toDouble(),
        duration: Duration(seconds: json['durationSeconds'] as int),
        completedAt: DateTime.parse(json['completedAt'] as String),
      );
}
