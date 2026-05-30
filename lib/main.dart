
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/exercise_list_screen.dart';
import 'utils/app_theme.dart';
import 'package:camera/camera.dart';
late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  cameras = await availableCameras();
  runApp(const AIFitnessApp());
}

class AIFitnessApp extends StatelessWidget {
  const AIFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Fitness Trainer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: ExerciseListScreen(cameras: cameras),
    );
  }
}
