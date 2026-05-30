import 'dart:ui';

enum ExerciseType { pushup, squats, downwardplank, jumping, highknee }

class ExerciseModel {
  final String title;
  final String image;
  final Color color;
  final ExerciseType type;
  final double caloriesPerRep;
  final String muscleGroup;
  final String difficulty;

  const ExerciseModel({
    required this.title,
    required this.image,
    required this.color,
    required this.type,
    required this.caloriesPerRep,
    required this.muscleGroup,
    required this.difficulty,
  });
}

const List<ExerciseModel> kExercises = [
  ExerciseModel(
    title: 'Push Ups',
    image: 'pushup.gif',
    color: Color(0xff005F9C),
    type: ExerciseType.pushup,
    caloriesPerRep: 0.36,
    muscleGroup: 'Chest · Triceps · Core',
    difficulty: 'Intermediate',
  ),
  ExerciseModel(
    title: 'Squats',
    image: 'squat.gif',
    color: Color(0xff0F5089),
    type: ExerciseType.squats,
    caloriesPerRep: 0.32,
    muscleGroup: 'Quads · Glutes · Hamstrings',
    difficulty: 'Beginner',
  ),
  ExerciseModel(
    title: 'Plank to Downward Dog',
    image: 'plank.gif',
    color: Color(0xff086366),
    type: ExerciseType.downwardplank,
    caloriesPerRep: 0.28,
    muscleGroup: 'Core · Shoulders · Hamstrings',
    difficulty: 'Intermediate',
  ),
  ExerciseModel(
    title: 'Jumping Jacks',
    image: 'jumping.gif',
    color: Color(0xff1a1a2e),
    type: ExerciseType.jumping,
    caloriesPerRep: 0.20,
    muscleGroup: 'Full Body · Cardio',
    difficulty: 'Beginner',
  ),
  ExerciseModel(
    title: 'High Knees',
    image: 'highknee.gif',
    color: Color(0xff4a0080),
    type: ExerciseType.highknee,
    caloriesPerRep: 0.15,
    muscleGroup: 'Core · Hip Flexors · Cardio',
    difficulty: 'Beginner',
  ),
];
