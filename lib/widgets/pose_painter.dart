import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';


class RealtimePosePainter extends CustomPainter {
  RealtimePosePainter(
    this.absoluteImageSize,
    this.poses, {
    this.anglesMap = const {},
  });

  final Size absoluteImageSize;
  final List<Pose> poses;

  final Map<String, double> anglesMap;

  @override
  void paint(Canvas canvas, Size size) {
    if (absoluteImageSize.width == 0 || absoluteImageSize.height == 0) return;

    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xff00C9A7);

    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellowAccent;

    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;

    for (final pose in poses) {
      // Draw landmark dots
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(
          Offset(landmark.x * scaleX, landmark.y * scaleY),
          5,
          dotPaint,
        );
      });

      void drawLine(
          PoseLandmarkType t1, PoseLandmarkType t2, Paint p) {
        final j1 = pose.landmarks[t1];
        final j2 = pose.landmarks[t2];
        if (j1 == null || j2 == null) return;
        canvas.drawLine(
          Offset(j1.x * scaleX, j1.y * scaleY),
          Offset(j2.x * scaleX, j2.y * scaleY),
          p,
        );
      }

      // Arms
      drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
      drawLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
      drawLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, rightPaint);
      drawLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

      // Torso
      drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder, leftPaint);
      drawLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip, leftPaint);
      drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
      drawLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, rightPaint);

      // Legs
      drawLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
      drawLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
      drawLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
      drawLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);

      // Draw angle labels at elbow / knee joints
      _drawAngles(canvas, pose, scaleX, scaleY);
    }
  }

  void _drawAngles(Canvas canvas, Pose pose, double sx, double sy) {
    anglesMap.forEach((label, angle) {
      PoseLandmark? joint;

      // Map label to the relevant joint landmark
      if (label.toLowerCase().contains('elbow')) {
        joint = pose.landmarks[PoseLandmarkType.leftElbow];
      } else if (label.toLowerCase().contains('knee')) {
        joint = pose.landmarks[PoseLandmarkType.leftKnee];
      } else if (label.toLowerCase().contains('hip')) {
        joint = pose.landmarks[PoseLandmarkType.leftHip];
      } else if (label.toLowerCase().contains('shoulder')) {
        joint = pose.landmarks[PoseLandmarkType.leftShoulder];
      }

      if (joint == null) return;

      final offset = Offset(joint.x * sx + 10, joint.y * sy - 20);
      final text = '${angle.toStringAsFixed(0)}°';

      final bgPaint = Paint()..color = Colors.black.withOpacity(0.6);
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$label\n$text',
          style: const TextStyle(
            color: Color(0xff00C9A7),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(offset.dx - 4, offset.dy - 4,
              textPainter.width + 8, textPainter.height + 8),
          const Radius.circular(6),
        ),
        bgPaint,
      );
      textPainter.paint(canvas, offset);
    });
  }

  @override
  bool shouldRepaint(RealtimePosePainter old) =>
      old.absoluteImageSize != absoluteImageSize ||
      old.poses != poses ||
      old.anglesMap != anglesMap;
}

//  Image Pose Painter (static images

class ImagePosePainter extends CustomPainter {
  final dynamic image; // dart:ui Image
  final List<Pose> poses;

  ImagePosePainter(this.image, this.poses);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());

    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final leftPaint = Paint()
      ..color = Colors.yellowAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final rightPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(Offset(landmark.x, landmark.y), 4, paint);
      });

      void drawLine(
          PoseLandmarkType t1, PoseLandmarkType t2, Paint p) {
        final j1 = pose.landmarks[t1];
        final j2 = pose.landmarks[t2];
        if (j1 == null || j2 == null) return;
        canvas.drawLine(Offset(j1.x, j1.y), Offset(j2.x, j2.y), p);
      }

      drawLine(PoseLandmarkType.rightWrist, PoseLandmarkType.rightElbow, rightPaint);
      drawLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightShoulder, rightPaint);
      drawLine(PoseLandmarkType.leftWrist, PoseLandmarkType.leftElbow, leftPaint);
      drawLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder, leftPaint);
      drawLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, rightPaint);
      drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
      drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder, leftPaint);
      drawLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip, leftPaint);
      drawLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
      drawLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);
      drawLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
      drawLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
