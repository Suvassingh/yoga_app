import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/target_reps_dialog.dart';
import 'realtime_detection_screen.dart';
import 'workout_history_screen.dart';
import 'image_pose_detection_screen.dart';
import 'package:camera/camera.dart';

class ExerciseListScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  const ExerciseListScreen({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppTheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff003d6b), AppTheme.surface],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.accent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image(
                            image: AssetImage('assets/logo1.png'),
                            width: 30,
                            height: 30,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Fitness Trainer',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'Real-time pose detection & rep counting',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.history_rounded, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WorkoutHistoryScreen(),
                  ),
                ),
                tooltip: 'History',
              ),
              IconButton(
                icon: const Icon(
                  Icons.image_search_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ImagePoseDetectionScreen(),
                  ),
                ),
                tooltip: 'Yoga Pose from Image',
              ),
            ],
          ),

          //  Section header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text(
                'Choose Exercise',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          //  Exercise cards
          SliverList(
            delegate: SliverChildBuilderDelegate((ctx, i) {
              final ex = kExercises[i];
              return ExerciseCard(
                title: ex.title,
                muscleGroup: ex.muscleGroup,
                difficulty: ex.difficulty,
                color: ex.color,
                imagePath: ex.image,
                onTap: () async {
                  final target = await showTargetRepsDialog(context, ex.title);
                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RealtimePoseDetectionScreen(
                        cameras: cameras,
                        exercise: ex,
                        targetReps: target ?? 0,
                      ),
                    ),
                  );
                },
              );
            }, childCount: kExercises.length),
          ),

          //  Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
