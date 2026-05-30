import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:yoga_app/utils/app_theme.dart';
import 'package:yoga_app/widgets/common_widgets.dart';
import '../widgets/pose_painter.dart';
import 'yoga_validators.dart';

class ImagePoseDetectionScreen extends StatefulWidget {
  const ImagePoseDetectionScreen({super.key});

  @override
  State<ImagePoseDetectionScreen> createState() =>
      _ImagePoseDetectionScreenState();
}

class _ImagePoseDetectionScreenState
    extends State<ImagePoseDetectionScreen> {
  final _picker = ImagePicker();
  File? _image;
  dynamic _decodedImage;
  late PoseDetector _poseDetector;
  List<Pose> _poses = [];
  String _poseName = '';
  String _poseResult = '';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(
        model: PoseDetectionModel.accurate,
        mode: PoseDetectionMode.single,
      ),
    );
  }

  @override
  void dispose() {
    _poseDetector.close();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final xfile = await _picker.pickImage(source: source);
    if (xfile == null) return;

    setState(() {
      _image = File(xfile.path);
      _poses = [];
      _poseName = '';
      _poseResult = '';
      _isProcessing = true;
    });

    await _loadDecodedImage();
    await _runDetection();
    if (mounted) setState(() => _isProcessing = false);
  }

  Future<void> _loadDecodedImage() async {
    final bytes = await _image!.readAsBytes();
    _decodedImage = await decodeImageFromList(bytes);
  }

  Future<void> _runDetection() async {
    final inputImage = InputImage.fromFile(_image!);
    _poses = await _poseDetector.processImage(inputImage);
    if (_poses.isEmpty) {
      _poseResult = 'No pose detected. Try a clearer photo.';
      return;
    }
    _classifyPose(_poses.first);
  }

  void _classifyPose(Pose pose) {
    final validators = getAllYogaValidators();
    for (final entry in validators.entries) {
      final result = entry.value(pose);
      if (result.startsWith('Correct') ||
          result.contains('!') ||
          result.startsWith('Good') ||
          result.startsWith('Excellent') ||
          result.startsWith('Great') ||
          result.startsWith('Perfect') ||
          result.startsWith('Restful')) {
        _poseName = entry.key;
        _poseResult = result;
        return;
      }
    }
    _poseName = 'Unknown';
    _poseResult = 'Could not identify a known yoga pose. Try adjusting your position.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Yoga Pose Identifier'),
      ),
      body: Column(
        children: [
          // ── Image area
          Expanded(
            child: _image != null && _decodedImage != null
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      FittedBox(
                        child: SizedBox(
                          width: _decodedImage.width.toDouble(),
                          height: _decodedImage.height.toDouble(),
                          child: CustomPaint(
                            painter:
                                ImagePosePainter(_decodedImage, _poses),
                          ),
                        ),
                      ),
                      if (_isProcessing)
                        Container(
                          color: Colors.black54,
                          child: const Center(
                            child: CircularProgressIndicator(
                                color: AppTheme.accent),
                          ),
                        ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.self_improvement_rounded,
                            size: 80, color: Colors.white12),
                        const SizedBox(height: 16),
                        const Text(
                          'Take or pick a photo\nto identify your yoga pose',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white38),
                        ),
                      ],
                    ),
                  ),
          ),

          // ── Result
          if (_poseResult.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: FeedbackBanner(
                message: _poseName.isNotEmpty
                    ? '$_poseName — $_poseResult'
                    : _poseResult,
                isGood: _poseName != 'Unknown' && _poseResult.isNotEmpty,
              ),
            ),

          // ── Buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.photo_library_rounded,
                      label: 'Gallery',
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.camera_alt_rounded,
                      label: 'Camera',
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.accent, size: 22),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
