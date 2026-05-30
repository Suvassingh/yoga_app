import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../models/exercise_model.dart';
import '../models/workout_session.dart';
import '../services/tts_service.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/pose_painter.dart';
import 'session_summary_screen.dart';

class RealtimePoseDetectionScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final ExerciseModel exercise;
  final int targetReps;

  const RealtimePoseDetectionScreen({
    super.key,
    required this.cameras,
    required this.exercise,
    required this.targetReps,
  });

  @override
  State<RealtimePoseDetectionScreen> createState() =>
      _RealtimePoseDetectionScreenState();
}

class _RealtimePoseDetectionScreenState
    extends State<RealtimePoseDetectionScreen> {
  //  Camera
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  bool _isBusy = false;
  CameraImage? _lastFrame;

  //  ML Kit
  late PoseDetector _poseDetector;
  List<Pose> _poses = [];

  // Reps & State
  int _repCount = 0;
  String _feedbackMsg = 'Get into position…';
  bool _feedbackIsGood = false;

  // Exercise-specific phase flags
  bool _isLowered = false;
  bool _isSquatting = false;
  bool _isInDownwardDog = false;
  bool _isJumpingJackOpen = false;
  bool _leftKneeUp = false;
  bool _rightKneeUp = false;

  //Angles for HUD display
  Map<String, double> _displayAngles = {};

  //  Timer
  late DateTime _startTime;
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  //  TTS Throttle
  DateTime _lastSpeak = DateTime.fromMillisecondsSinceEpoch(0);

  //  Orientation map
  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  //  Workout complete flag
  bool _workoutDone = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _initPoseDetector();
    _initCamera();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed = DateTime.now().difference(_startTime));
    });
  }

  void _initPoseDetector() {
    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
    );
  }

  Future<void> _initCamera() async {
    _cameraController = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
      enableAudio: false,
    );

    await _cameraController.initialize();
    if (!mounted) return;

    _cameraController.startImageStream((image) {
      if (!_isBusy && !_workoutDone) {
        _isBusy = true;
        _lastFrame = image;
        _processFrame();
      }
    });

    setState(() => _isCameraInitialized = true);
  }

  //  Frame Processing

  Future<void> _processFrame() async {
    final inputImage = _buildInputImage();
    if (inputImage == null) { _isBusy = false; return; }

    final poses = await _poseDetector.processImage(inputImage);

    if (!mounted) { _isBusy = false; return; }

    if (poses.isNotEmpty) {
      final pose = poses.first;
      _runExerciseDetection(pose);
    }

    setState(() => _poses = poses);
    _isBusy = false;
  }

  void _runExerciseDetection(Pose pose) {
    switch (widget.exercise.type) {
      case ExerciseType.pushup:
        _detectPushUp(pose.landmarks);
        break;
      case ExerciseType.squats:
        _detectSquat(pose.landmarks);
        break;
      case ExerciseType.downwardplank:
        _detectPlankToDownwardDog(pose);
        break;
      case ExerciseType.jumping:
        _detectJumpingJack(pose);
        break;
      case ExerciseType.highknee:
        _detectHighKnees(pose.landmarks);
        break;
    }
  }

  InputImage? _buildInputImage() {
    if (_lastFrame == null) return null;
    final camera = widget.cameras[0];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var comp = _orientations[_cameraController.value.deviceOrientation];
      if (comp == null) return null;
      comp = camera.lensDirection == CameraLensDirection.front
          ? (sensorOrientation + comp) % 360
          : (sensorOrientation - comp + 360) % 360;
      rotation = InputImageRotationValue.fromRawValue(comp);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(_lastFrame!.format.raw);
    if (format == null) return null;
    if (Platform.isAndroid && format != InputImageFormat.nv21) return null;
    if (Platform.isIOS && format != InputImageFormat.bgra8888) return null;
    if (_lastFrame!.planes.length != 1) return null;

    final plane = _lastFrame!.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(_lastFrame!.width.toDouble(), _lastFrame!.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  //  Rep Counting + Form Feedback

  void _onRepCompleted(String repAnnouncement) {
    _repCount++;
    _feedbackMsg = 'Great rep! Keep going!';
    _feedbackIsGood = true;

    TTSService.instance.speak(repAnnouncement);
    _lastSpeak = DateTime.now();

    if (widget.targetReps > 0 && _repCount >= widget.targetReps) {
      _onWorkoutComplete();
    }
  }

  void _setFeedback(String msg, bool isGood) {
    if (_feedbackMsg == msg) return;
    _feedbackMsg = msg;
    _feedbackIsGood = isGood;

    // Speak form cue at most once every 3 seconds
    if (!isGood &&
        DateTime.now().difference(_lastSpeak).inSeconds >= 3) {
      TTSService.instance.speak(msg);
      _lastSpeak = DateTime.now();
    }
  }

  void _onWorkoutComplete() {
    if (_workoutDone) return;
    _workoutDone = true;
    _timer.cancel();

    TTSService.instance.speak(
        'Workout complete! You did $_repCount reps. Amazing job!');

    final session = WorkoutSession(
      exerciseTitle: widget.exercise.title,
      repsCompleted: _repCount,
      targetReps: widget.targetReps,
      caloriesBurned: _repCount * widget.exercise.caloriesPerRep,
      duration: _elapsed,
      completedAt: DateTime.now(),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SessionSummaryScreen(session: session),
        ),
      );
    });
  }

  //  PUSH-UP

  void _detectPushUp(Map<PoseLandmarkType, PoseLandmark> lm) {
    final ls = lm[PoseLandmarkType.leftShoulder];
    final rs = lm[PoseLandmarkType.rightShoulder];
    final le = lm[PoseLandmarkType.leftElbow];
    final re = lm[PoseLandmarkType.rightElbow];
    final lw = lm[PoseLandmarkType.leftWrist];
    final rw = lm[PoseLandmarkType.rightWrist];
    final lh = lm[PoseLandmarkType.leftHip];
    final rh = lm[PoseLandmarkType.rightHip];
    final lk = lm[PoseLandmarkType.leftKnee];
    final rk = lm[PoseLandmarkType.rightKnee];

    if ([ls, rs, le, re, lw, rw, lh, rh].contains(null)) {
      _setFeedback('Move back — full body not visible', false);
      return;
    }

    final leftElbowAngle = _angle(ls!, le!, lw!);
    final rightElbowAngle = _angle(rs!, re!, rw!);
    final avgElbow = (leftElbowAngle + rightElbowAngle) / 2;

    final torsoAngle = _angle(ls, lh!, lk ?? rk!);
    final inPlank = torsoAngle > 155;

    _displayAngles = {
      'Elbow': avgElbow,
      'Torso': torsoAngle,
    };

    if (!inPlank) {
      _setFeedback('Keep your body in a straight plank line!', false);
      return;
    }

    if (avgElbow < 90 && inPlank) {
      _isLowered = true;
      _setFeedback('Good — now push up!', true);
    } else if (avgElbow > 160 && _isLowered && inPlank) {
      _isLowered = false;
      _onRepCompleted('$_repCount');
    } else if (!_isLowered) {
      if (avgElbow < 130) {
        _setFeedback('Go lower! Chest to the floor.', false);
      } else {
        _setFeedback('Lower down slowly…', false);
      }
    }
  }

  //  SQUAT

  void _detectSquat(Map<PoseLandmarkType, PoseLandmark> lm) {
    final lh = lm[PoseLandmarkType.leftHip];
    final rh = lm[PoseLandmarkType.rightHip];
    final lk = lm[PoseLandmarkType.leftKnee];
    final rk = lm[PoseLandmarkType.rightKnee];
    final la = lm[PoseLandmarkType.leftAnkle];
    final ra = lm[PoseLandmarkType.rightAnkle];
    final ls = lm[PoseLandmarkType.leftShoulder];
    final rs = lm[PoseLandmarkType.rightShoulder];

    if ([lh, rh, lk, rk, la, ra, ls, rs].contains(null)) {
      _setFeedback('Full body not visible', false);
      return;
    }

    final leftKneeAngle = _angle(lh!, lk!, la!);
    final rightKneeAngle = _angle(rh!, rk!, ra!);
    final avgKnee = (leftKneeAngle + rightKneeAngle) / 2;
    final hipY = (lh.y + rh.y) / 2;
    final kneeY = (lk.y + rk.y) / 2;

    _displayAngles = {'Knee': avgKnee};

    if (avgKnee < 90 && hipY > kneeY) {
      _isSquatting = true;
      _setFeedback('Deep squat! Now stand up.', true);
    } else if (avgKnee > 160 && _isSquatting) {
      _isSquatting = false;
      _onRepCompleted('$_repCount');
    } else if (!_isSquatting) {
      if (avgKnee < 130) {
        _setFeedback('Go deeper! Hips below knees.', false);
      } else {
        _setFeedback('Squat down — knees over toes.', false);
      }
    }
  }

  //  PLANK TO DOWNWARD DOG

void _detectPlankToDownwardDog(Pose pose) {
    final lm = pose.landmarks;
    final ls = lm[PoseLandmarkType.leftShoulder];
    final rs = lm[PoseLandmarkType.rightShoulder];
    final lh = lm[PoseLandmarkType.leftHip];
    final rh = lm[PoseLandmarkType.rightHip];
    final la = lm[PoseLandmarkType.leftAnkle];
    final ra = lm[PoseLandmarkType.rightAnkle];
    final lw = lm[PoseLandmarkType.leftWrist];
    final rw = lm[PoseLandmarkType.rightWrist];

    //  Add null check – return early if any landmark missing
    if (ls == null ||
        rs == null ||
        lh == null ||
        rh == null ||
        la == null ||
        ra == null ||
        lw == null ||
        rw == null) {
      _setFeedback('Get into position — full body must be visible', false);
      return;
    }

    // Now safe to use .y
    final isPlank =
        (lh.y - ls.y).abs() < 30 &&
        (rh.y - rs.y).abs() < 30 &&
        (lh.y - la.y).abs() > 100;

    final isDownwardDog = lh.y < ls.y - 50 && rh.y < rs.y - 50;

    if (isDownwardDog && !_isInDownwardDog) {
      _isInDownwardDog = true;
      _setFeedback('Great Downward Dog! Now back to plank.', true);
    } else if (isPlank && _isInDownwardDog) {
      _isInDownwardDog = false;
      _onRepCompleted('$_repCount'); // also add rep counting
    } else if (!_isInDownwardDog) {
      _setFeedback('Push hips up and back for Downward Dog.', false);
    }
  }

  //  JUMPING JACKS

  void _detectJumpingJack(Pose pose) {
    final lm = pose.landmarks;
    final la = lm[PoseLandmarkType.leftAnkle];
    final ra = lm[PoseLandmarkType.rightAnkle];
    final lh = lm[PoseLandmarkType.leftHip];
    final rh = lm[PoseLandmarkType.rightHip];
    final ls = lm[PoseLandmarkType.leftShoulder];
    final rs = lm[PoseLandmarkType.rightShoulder];
    final lw = lm[PoseLandmarkType.leftWrist];
    final rw = lm[PoseLandmarkType.rightWrist];

    if ([la, ra, lh, rh, ls, rs, lw, rw].contains(null)) {
      _setFeedback('Full body not visible', false);
      return;
    }

    final legSpread = (ra!.x - la!.x).abs();
    final armHeight = (lw!.y + rw!.y) / 2;
    final hipHeight = (lh!.y + rh!.y) / 2;
    final shoulderWidth = (rs!.x - ls!.x).abs();

    final armsUp = armHeight < (hipHeight - shoulderWidth * 0.5);
    final legsApart = legSpread > shoulderWidth * 1.2;

    _displayAngles = {'Leg Spread': legSpread, 'Arm Y': armHeight};

    if (armsUp && legsApart && !_isJumpingJackOpen) {
      _isJumpingJackOpen = true;
      _setFeedback('Open! Now close.', true);
    } else if (!armsUp && !legsApart && _isJumpingJackOpen) {
      _isJumpingJackOpen = false;
      _onRepCompleted('$_repCount');
    } else if (!_isJumpingJackOpen) {
      _setFeedback('Spread arms and legs wide!', false);
    }
  }

  //  HIGH KNEES

  void _detectHighKnees(Map<PoseLandmarkType, PoseLandmark> lm) {
    final lh = lm[PoseLandmarkType.leftHip];
    final rh = lm[PoseLandmarkType.rightHip];
    final lk = lm[PoseLandmarkType.leftKnee];
    final rk = lm[PoseLandmarkType.rightKnee];

    if ([lh, rh, lk, rk].contains(null)) {
      _setFeedback('Hips and knees must be visible', false);
      return;
    }

    _displayAngles = {
      'L Knee Y': lk!.y,
      'R Knee Y': rk!.y,
    };

    if (lk.y < lh!.y) {
      if (!_leftKneeUp) {
        _leftKneeUp = true;
        _setFeedback('Left knee up! Great!', true);
      }
    } else if (_leftKneeUp) {
      _leftKneeUp = false;
      _onRepCompleted('$_repCount');
    }

    if (rk.y < rh!.y) {
      if (!_rightKneeUp) {
        _rightKneeUp = true;
        _setFeedback('Right knee up!', true);
      }
    } else if (_rightKneeUp) {
      _rightKneeUp = false;
      _onRepCompleted('$_repCount');
    }
  }

  //  Geometry

  double _angle(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
    final ab = _dist(a, b);
    final bc = _dist(b, c);
    final ac = _dist(a, c);
    final cos = ((ab * ab + bc * bc - ac * ac) / (2 * ab * bc)).clamp(-1.0, 1.0);
    return acos(cos) * (180 / pi);
  }

  double _dist(PoseLandmark p1, PoseLandmark p2) =>
      sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));

  //  Timer display

  String get _elapsedStr {
    final m = _elapsed.inMinutes.toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  //  UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 18),
          ),
          onPressed: () => _confirmExit(),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.exercise.title,
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: !_isCameraInitialized
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.accent))
          : Stack(
              fit: StackFit.expand,
              children: [
                // ── Camera feed
                CameraPreview(_cameraController),

                // ── Skeleton overlay
                if (_poses.isNotEmpty)
                  CustomPaint(
                    painter: RealtimePosePainter(
                      Size(
                        _cameraController.value.previewSize!.height,
                        _cameraController.value.previewSize!.width,
                      ),
                      _poses,
                      anglesMap: _displayAngles,
                    ),
                  ),

                // ── Dark gradient at top and bottom for readability
                Positioned.fill(
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black54, Colors.transparent],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 160,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black87, Colors.transparent],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Rep counter badge (top-left)
                Positioned(
                  top: 90,
                  left: 16,
                  child: RepCounterBadge(
                    count: _repCount,
                    target: widget.targetReps,
                    exerciseTitle: widget.exercise.title,
                    color: widget.exercise.color,
                    elapsedTime: _elapsedStr,
                  ),
                ),

                // ── Angle badges (top-right)
                Positioned(
                  top: 90,
                  right: 16,
                  child: _buildAngleBadges(),
                ),

                // ── Feedback banner (bottom)
                Positioned(
                  bottom: 32,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      // Progress bar if target set
                      if (widget.targetReps > 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$_repCount / ${widget.targetReps} reps',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              '${((_repCount / widget.targetReps) * 100).clamp(0, 100).round()}%',
                              style: const TextStyle(
                                  color: AppTheme.accent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: (_repCount / widget.targetReps).clamp(0.0, 1.0),
                            minHeight: 6,
                            backgroundColor: Colors.white12,
                            valueColor:
                                const AlwaysStoppedAnimation(AppTheme.accent),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      FeedbackBanner(
                        message: _feedbackMsg,
                        isGood: _feedbackIsGood,
                      ),
                      const SizedBox(height: 12),
                      // Finish early button
                      GestureDetector(
                        onTap: _onWorkoutComplete,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 32),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Text(
                            'Finish Workout',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAngleBadges() {
    // Show only exercise-relevant angles — skip raw pixel coords
    final relevant = <String, double>{};
    _displayAngles.forEach((k, v) {
      if (k == 'Elbow' || k == 'Knee' || k == 'Hip' || k == 'Torso' || k == 'Shoulder') {
        relevant[k] = v;
      }
    });

    if (relevant.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: relevant.entries.map((e) {
        final isGood = _isAngleGood(e.key, e.value);
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: AngleBadge(label: e.key, angle: e.value, isGood: isGood),
        );
      }).toList(),
    );
  }

  bool _isAngleGood(String label, double angle) {
    switch (widget.exercise.type) {
      case ExerciseType.pushup:
        if (label == 'Elbow') return angle < 90;
        if (label == 'Torso') return angle > 155;
        break;
      case ExerciseType.squats:
        if (label == 'Knee') return angle < 100;
        break;
      case ExerciseType.downwardplank:
        if (label == 'Hip') return angle < 90;
        break;
      default:
        break;
    }
    return true;
  }

  Future<void> _confirmExit() async {
    if (_repCount == 0) { Navigator.pop(context); return; }
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.card,
        title: const Text('End Workout?', style: TextStyle(color: Colors.white)),
        content: Text(
          'You have $_repCount reps done. View your summary?',
          style: const TextStyle(color: Colors.white60),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep Going'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Finish', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
    if (leave == true) _onWorkoutComplete();
  }

  @override
  void dispose() {
    _timer.cancel();
    _cameraController.dispose();
    _poseDetector.close();
    TTSService.instance.stop();
    super.dispose();
  }
}
