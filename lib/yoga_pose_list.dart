import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

double calculateAngle(PoseLandmark first, PoseLandmark mid, PoseLandmark last) {
  double radians =
      atan2(last.y - mid.y, last.x - mid.x) -
          atan2(first.y - mid.y, first.x - mid.x);

  double angle = (radians * 180) / pi;
  return angle.abs();
}


String validateMountainPose(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];

  if ([
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle,
    leftWrist, rightWrist, leftElbow, rightElbow
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool legsStraight =
      (leftLegAngle > 155 && leftLegAngle < 200) &&
          (rightLegAngle > 155 && rightLegAngle < 200);

  if (!legsStraight) {
    return "Straighten your legs to stand tall.";
  }

  // Shoulders should be roughly level with each other
  double shoulderDiff = (leftShoulder!.y - rightShoulder!.y).abs();
  if (shoulderDiff > 30) {
    return "Level your shoulders.";
  }

  // Hips should be roughly level with each other
  double hipDiff = (leftHip.y - rightHip!.y).abs();
  if (hipDiff > 30) {
    return "Level your hips.";
  }

  return "Perfect Mountain Pose!";
}

/// 2. Tree Pose – Vrksasana
/// Standing on one leg, the other foot pressed to inner thigh/calf.
String validateTreePose(Pose pose) {
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];

  if ([
    leftHip, rightHip, leftKnee, rightKnee,
    leftAnkle, rightAnkle, leftShoulder, rightShoulder
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  // One leg should be straight (standing leg) and the other bent
  bool leftStraight = leftLegAngle > 155 && leftLegAngle < 200;
  bool rightStraight = rightLegAngle > 155 && rightLegAngle < 200;
  bool leftBent = leftLegAngle < 120;
  bool rightBent = rightLegAngle < 120;

  bool validStance = (leftStraight && rightBent) || (rightStraight && leftBent);

  if (!validStance) {
    return "Bend one knee outward and press foot to your inner leg.";
  }

  // Shoulders should be level (balanced torso)
  double shoulderDiff = (leftShoulder!.y - rightShoulder!.y).abs();
  if (shoulderDiff > 30) {
    return "Keep your shoulders level for balance.";
  }

  return "Great Tree Pose!";
}

/// 3. Warrior I – Virabhadrasana I
/// Front knee bent ~90°, back leg straight, arms raised overhead.
String validateWarriorI(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

  if ([
    leftShoulder, rightShoulder, leftElbow, rightElbow,
    leftWrist, rightWrist, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftArmAngle = calculateAngle(leftWrist!, leftElbow!, leftShoulder!);
  double rightArmAngle = calculateAngle(rightWrist!, rightElbow!, rightShoulder!);
  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool armsRaised =
      (leftArmAngle > 150 && leftArmAngle < 200) &&
          (rightArmAngle > 150 && rightArmAngle < 200);

  if (!armsRaised) {
    return "Raise and straighten both arms overhead.";
  }

  // One knee should be bent (~80–110°), other leg straight
  bool leftKneeBent = leftLegAngle > 70 && leftLegAngle < 120;
  bool rightKneeBent = rightLegAngle > 70 && rightLegAngle < 120;
  bool leftLegStraight = leftLegAngle > 155;
  bool rightLegStraight = rightLegAngle > 155;

  bool validLunge = (leftKneeBent && rightLegStraight) || (rightKneeBent && leftLegStraight);

  if (!validLunge) {
    return "Bend your front knee to 90° and keep the back leg straight.";
  }

  return "Excellent Warrior I!";
}

/// 4. Warrior II – Virabhadrasana II
/// Front knee bent ~90°, back leg straight, arms extended to the sides at shoulder height.
String validateWarriorII(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

  if ([
    leftShoulder, rightShoulder, leftElbow, rightElbow,
    leftWrist, rightWrist, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftArmAngle = calculateAngle(leftWrist!, leftElbow!, leftShoulder!);
  double rightArmAngle = calculateAngle(rightWrist!, rightElbow!, rightShoulder!);
  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  // Arms should be straight and extended horizontally (roughly at shoulder level)
  bool armsStraight =
      (leftArmAngle > 150 && leftArmAngle < 210) &&
          (rightArmAngle > 150 && rightArmAngle < 210);

  if (!armsStraight) {
    return "Extend both arms straight out to the sides at shoulder height.";
  }

  // Wrists should be at roughly the same height as shoulders
  bool wristsLevel =
      (leftWrist.y - leftShoulder.y).abs() < 50 &&
          (rightWrist.y - rightShoulder.y).abs() < 50;

  if (!wristsLevel) {
    return "Keep your arms parallel to the ground.";
  }

  // One knee bent, one leg straight
  bool leftKneeBent = leftLegAngle > 70 && leftLegAngle < 120;
  bool rightKneeBent = rightLegAngle > 70 && rightLegAngle < 120;
  bool leftLegStraight = leftLegAngle > 155;
  bool rightLegStraight = rightLegAngle > 155;

  bool validLunge = (leftKneeBent && rightLegStraight) || (rightKneeBent && leftLegStraight);

  if (!validLunge) {
    return "Bend your front knee to 90° and straighten the back leg.";
  }

  return "Excellent Warrior II!";
}

/// 5. Warrior III – Virabhadrasana III
/// Standing on one leg, torso and raised leg parallel to ground, arms extended forward.
String validateWarriorIII(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];

  if ([
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle,
    leftWrist, rightWrist, leftElbow, rightElbow
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  // One leg should be fully extended (raised), the other straight (standing)
  bool leftStraight = leftLegAngle > 155;
  bool rightStraight = rightLegAngle > 155;

  if (!leftStraight && !rightStraight) {
    return "Keep both legs straight — one grounded, one extended behind.";
  }

  // Torso should be roughly parallel to the ground:
  // shoulders should be near the same height as hips
  double torsoTilt = (leftShoulder!.y - leftHip.y).abs();
  if (torsoTilt < 20) {
    return "Lean your torso forward, parallel to the ground.";
  }

  // Arms should be straight (extended forward)
  double leftArmAngle = calculateAngle(leftWrist!, leftElbow!, leftShoulder);
  double rightArmAngle = calculateAngle(rightWrist!, rightElbow!, rightShoulder!);

  bool armsExtended =
      (leftArmAngle > 150 && leftArmAngle < 210) &&
          (rightArmAngle > 150 && rightArmAngle < 210);

  if (!armsExtended) {
    return "Extend your arms straight forward.";
  }

  return "Impressive Warrior III!";
}

/// 6. Triangle Pose – Trikonasana
/// Legs wide apart, torso bent sideways, one arm reaching down, other arm raised up.
String validateTrianglePose(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

  if ([
    leftShoulder, rightShoulder, leftElbow, rightElbow,
    leftWrist, rightWrist, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool legsStraight =
      (leftLegAngle > 155 && leftLegAngle < 200) &&
          (rightLegAngle > 155 && rightLegAngle < 200);

  if (!legsStraight) {
    return "Keep both legs straight.";
  }

  // Arms should be straight and extended (one up, one down — vertically aligned)
  double leftArmAngle = calculateAngle(leftWrist!, leftElbow!, leftShoulder!);
  double rightArmAngle = calculateAngle(rightWrist!, rightElbow!, rightShoulder!);

  bool armsStraight =
      (leftArmAngle > 150 && leftArmAngle < 210) &&
          (rightArmAngle > 150 && rightArmAngle < 210);

  if (!armsStraight) {
    return "Extend both arms fully — one toward the floor, one toward the ceiling.";
  }

  // One wrist should be above the shoulder (raised arm), other below hip (reaching down)
  bool oneArmUp =
      leftWrist.y < leftShoulder.y || rightWrist.y < rightShoulder.y;
  bool oneArmDown =
      leftWrist.y > leftHip.y || rightWrist.y > rightHip.y;

  if (!oneArmUp || !oneArmDown) {
    return "Reach one arm up and the other toward your ankle.";
  }

  return "Beautiful Triangle Pose!";
}

/// 7. Chair Pose – Utkatasana
/// Knees bent as if sitting in a chair, arms raised overhead.
String validateChairPose(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

  if ([
    leftShoulder, rightShoulder, leftElbow, rightElbow,
    leftWrist, rightWrist, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftKneeAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightKneeAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool kneesBent =
      (leftKneeAngle > 70 && leftKneeAngle < 130) &&
          (rightKneeAngle > 70 && rightKneeAngle < 130);

  if (!kneesBent) {
    return "Bend your knees more, as if sitting into a chair.";
  }

  double leftArmAngle = calculateAngle(leftWrist!, leftElbow!, leftShoulder!);
  double rightArmAngle = calculateAngle(rightWrist!, rightElbow!, rightShoulder!);

  bool armsRaised =
      (leftArmAngle > 150 && leftArmAngle < 210) &&
          (rightArmAngle > 150 && rightArmAngle < 210);

  if (!armsRaised) {
    return "Raise both arms straight overhead.";
  }

  // Wrists should be above shoulders
  if (leftWrist.y > leftShoulder.y || rightWrist.y > rightShoulder.y) {
    return "Lift your arms higher, above your head.";
  }

  return "Great Chair Pose!";
}

/// 8. Extended Side Angle Pose – Utthita Parsvakonasana
/// Front knee bent ~90°, back leg straight, one arm extended over ear, other touching the floor.
String validateExtendedSideAngle(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

  if ([
    leftShoulder, rightShoulder, leftElbow, rightElbow,
    leftWrist, rightWrist, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool leftKneeBent = leftLegAngle > 70 && leftLegAngle < 120;
  bool rightKneeBent = rightLegAngle > 70 && rightLegAngle < 120;
  bool leftLegStraight = leftLegAngle > 155;
  bool rightLegStraight = rightLegAngle > 155;

  bool validLunge = (leftKneeBent && rightLegStraight) || (rightKneeBent && leftLegStraight);

  if (!validLunge) {
    return "Bend your front knee to 90° and extend the back leg straight.";
  }

  // One arm should be extended overhead (wrist above shoulder)
  bool oneArmUp =
      leftWrist!.y < leftShoulder!.y || rightWrist!.y < rightShoulder!.y;

  if (!oneArmUp) {
    return "Extend your top arm straight overhead, alongside your ear.";
  }

  double leftArmAngle = calculateAngle(leftWrist, leftElbow!, leftShoulder);
  double rightArmAngle = calculateAngle(rightWrist!, rightElbow!, rightShoulder!);

  bool topArmStraight =
      (leftArmAngle > 150 && leftArmAngle < 210) ||
          (rightArmAngle > 150 && rightArmAngle < 210);

  if (!topArmStraight) {
    return "Straighten your top arm fully.";
  }

  return "Wonderful Extended Side Angle Pose!";
}



/// 9. Standing Forward Fold – Uttanasana
/// Legs straight, torso folded forward, hands reaching toward feet.
String validateStandingForwardFold(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];

  if ([
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle,
    leftWrist, rightWrist
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool legsStraight =
      (leftLegAngle > 145 && leftLegAngle < 200) &&
          (rightLegAngle > 145 && rightLegAngle < 200);

  if (!legsStraight) {
    return "Try to straighten your legs more.";
  }

  // Shoulders should be below the hips (torso folded forward/down)
  if (leftShoulder!.y < leftHip.y || rightShoulder!.y < rightHip.y) {
    return "Fold deeper — bring your torso closer to your legs.";
  }

  // Wrists should be at or below knee level
  if (leftWrist!.y < leftKnee!.y || rightWrist!.y < rightKnee!.y) {
    return "Reach your hands further toward the floor.";
  }

  return "Great Standing Forward Fold!";
}

/// 10. Seated Forward Bend – Paschimottanasana
/// Seated with legs straight, torso folded forward over legs.
String validateSeatedForwardBend(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];

  if ([
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle,
    leftWrist, rightWrist
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool legsStraight =
      (leftLegAngle > 145 && leftLegAngle < 200) &&
          (rightLegAngle > 145 && rightLegAngle < 200);

  if (!legsStraight) {
    return "Keep your legs straight and extended in front.";
  }

  // Shoulders should be forward of/at hips level (torso leaning forward)
  bool torsoForward =
      leftShoulder!.x > leftHip.x || rightShoulder!.x > rightHip.x;

  if (!torsoForward) {
    return "Lean your torso forward over your legs.";
  }

  // Wrists reaching toward feet
  bool handsReaching =
      leftWrist!.x > leftKnee!.x || rightWrist!.x > rightKnee!.x;

  if (!handsReaching) {
    return "Reach your hands toward your feet.";
  }

  return "Excellent Seated Forward Bend!";
}

/// 11. Wide-Legged Forward Bend – Prasarita Padottanasana
/// Legs wide apart, torso folded forward, hands on ground.
String validateWideLeggedForwardBend(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];

  if ([
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle,
    leftWrist, rightWrist
  ].contains(null)) {
    return "Body not fully visible";
  }

  // Feet should be wide apart (ankles far from each other)
  double ankleSpread = (leftAnkle!.x - rightAnkle!.x).abs();
  double hipWidth = (leftHip!.x - rightHip!.x).abs();

  if (ankleSpread < hipWidth * 1.5) {
    return "Widen your stance — spread your feet further apart.";
  }

  double leftLegAngle = calculateAngle(leftHip, leftKnee!, leftAnkle);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle);

  bool legsStraight =
      (leftLegAngle > 145 && leftLegAngle < 200) &&
          (rightLegAngle > 145 && rightLegAngle < 200);

  if (!legsStraight) {
    return "Keep your legs straight.";
  }

  // Shoulders should be below hips (torso folded down)
  if (leftShoulder!.y < leftHip.y || rightShoulder!.y < rightHip.y) {
    return "Fold your torso further toward the ground.";
  }

  return "Fantastic Wide-Legged Forward Bend!";
}



/// 12. Upward Dog Pose – Urdhva Mukha Svanasana
String validateUpwardDog(Pose pose) {
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

  if ([
    leftWrist, rightWrist, leftElbow, rightElbow,
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftArmAngle = calculateAngle(leftWrist!, leftElbow!, leftShoulder!);
  double rightArmAngle = calculateAngle(rightWrist!, rightElbow!, rightShoulder!);

  bool armsStraight =
      (leftArmAngle > 150 && leftArmAngle < 200) &&
          (rightArmAngle > 150 && rightArmAngle < 200);

  if (!armsStraight) {
    return "Straighten your arms more.";
  }

  if (leftShoulder.y > leftHip!.y || rightShoulder.y > rightHip!.y) {
    return "Lift your chest higher.";
  }

  return "Great Upward Dog pose!";
}

/// 13. Cobra Pose – Bhujangasana
/// Lying prone, arms partially bent, chest lifted, hips on the ground.
String validateCobraPose(Pose pose) {
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

  if ([
    leftWrist, rightWrist, leftElbow, rightElbow,
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftArmAngle = calculateAngle(leftWrist!, leftElbow!, leftShoulder!);
  double rightArmAngle = calculateAngle(rightWrist!, rightElbow!, rightShoulder!);

  // Cobra has partially bent elbows (unlike Upward Dog which is straight)
  bool armsPartiallyBent =
      (leftArmAngle > 70 && leftArmAngle < 160) &&
          (rightArmAngle > 70 && rightArmAngle < 160);

  if (!armsPartiallyBent) {
    return "Bend your elbows slightly — keep them close to your sides.";
  }

  // Shoulders should be above hips (chest lifted)
  if (leftShoulder.y > leftHip!.y || rightShoulder.y > rightHip!.y) {
    return "Lift your chest higher off the ground.";
  }

  // Legs should be relatively straight (on the ground behind)
  double leftLegAngle = calculateAngle(leftHip, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip, rightKnee!, rightAnkle!);

  bool legsFlat =
      (leftLegAngle > 145 && leftLegAngle < 200) &&
          (rightLegAngle > 145 && rightLegAngle < 200);

  if (!legsFlat) {
    return "Keep your legs straight and flat on the ground.";
  }

  return "Beautiful Cobra Pose!";
}

/// 14. Bridge Pose – Setu Bandha Sarvangasana
/// Lying on back, knees bent, hips lifted, shoulders on ground.
String validateBridgePose(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

  if ([
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftKneeAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightKneeAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool kneesBent =
      (leftKneeAngle > 70 && leftKneeAngle < 120) &&
          (rightKneeAngle > 70 && rightKneeAngle < 120);

  if (!kneesBent) {
    return "Bend your knees to about 90° with feet flat on the ground.";
  }

  // Hips should be above shoulders (lifted)
  if (leftHip.y > leftShoulder!.y || rightHip.y > rightShoulder!.y) {
    return "Lift your hips higher toward the ceiling.";
  }

  return "Excellent Bridge Pose!";
}

/// 15. Camel Pose – Ustrasana
/// Kneeling, torso arched backward, hands reaching for heels.
String validateCamelPose(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

  if ([
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftWrist, rightWrist,
    leftAnkle, rightAnkle
  ].contains(null)) {
    return "Body not fully visible";
  }

  // Hips should be above knees (kneeling position)
  if (leftHip!.y > leftKnee!.y || rightHip!.y > rightKnee!.y) {
    return "Keep your hips stacked over your knees.";
  }

  // Shoulders should be behind hips (backward arch)
  if (leftShoulder!.x > leftHip.x || rightShoulder!.x > rightHip.x) {
    return "Arch your back and lean your shoulders behind your hips.";
  }

  // Wrists should be near ankle level (reaching for heels)
  bool handsReachingHeels =
      (leftWrist!.y - leftAnkle!.y).abs() < 60 ||
          (rightWrist!.y - rightAnkle!.y).abs() < 60;

  if (!handsReachingHeels) {
    return "Reach your hands back toward your heels.";
  }

  return "Impressive Camel Pose!";
}

/// 16. Wheel Pose – Urdhva Dhanurasana
/// Full backbend — hands and feet on ground, hips and chest lifted high.
String validateWheelPose(Pose pose) {
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

  if ([
    leftWrist, rightWrist, leftElbow, rightElbow,
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftArmAngle = calculateAngle(leftWrist!, leftElbow!, leftShoulder!);
  double rightArmAngle = calculateAngle(rightWrist!, rightElbow!, rightShoulder!);

  bool armsStraight =
      (leftArmAngle > 150 && leftArmAngle < 210) &&
          (rightArmAngle > 150 && rightArmAngle < 210);

  if (!armsStraight) {
    return "Straighten your arms fully to push your chest up.";
  }

  // Hips should be above shoulders (high arc)
  if (leftHip!.y > leftShoulder.y || rightHip!.y > rightShoulder.y) {
    return "Push your hips higher to form a full arch.";
  }

  // Knees bent (feet on ground)
  double leftKneeAngle = calculateAngle(leftHip, leftKnee!, leftAnkle!);
  double rightKneeAngle = calculateAngle(rightHip, rightKnee!, rightAnkle!);

  bool kneesBent =
      (leftKneeAngle > 60 && leftKneeAngle < 130) &&
          (rightKneeAngle > 60 && rightKneeAngle < 130);

  if (!kneesBent) {
    return "Bend your knees and plant your feet flat on the ground.";
  }

  return "Amazing Wheel Pose!";
}



/// 17. Eagle Pose – Garudasana
/// Arms and legs crossed/wrapped, slight forward lean.
String validateEaglePose(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

  if ([
    leftShoulder, rightShoulder, leftElbow, rightElbow,
    leftWrist, rightWrist, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle
  ].contains(null)) {
    return "Body not fully visible";
  }

  // Arms should be crossed in front of the body — elbows at similar height, wrists close together
  double wristDistance = (leftWrist!.x - rightWrist!.x).abs();
  double elbowDistance = (leftElbow!.x - rightElbow!.x).abs();

  if (wristDistance > 60 || elbowDistance > 80) {
    return "Wrap your arms — cross one elbow under the other and bring palms together.";
  }

  // One knee should be bent more than the other (legs crossed)
  double leftKneeAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightKneeAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool kneesBent =
      (leftKneeAngle > 70 && leftKneeAngle < 140) ||
          (rightKneeAngle > 70 && rightKneeAngle < 140);

  if (!kneesBent) {
    return "Bend your standing knee and wrap the other leg around it.";
  }

  return "Excellent Eagle Pose!";
}

/// 18. Half Moon Pose – Ardha Chandrasana
/// Balancing on one leg and one hand, body parallel to the ground, top leg and arm extended.
String validateHalfMoonPose(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];

  if ([
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle,
    leftWrist, rightWrist, leftElbow, rightElbow
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool legsStraight =
      (leftLegAngle > 150) || (rightLegAngle > 150);

  if (!legsStraight) {
    return "Extend the raised leg fully straight.";
  }

  // One arm should be raised (wrist above shoulder)
  bool oneArmUp =
      leftWrist!.y < leftShoulder!.y || rightWrist!.y < rightShoulder!.y;

  if (!oneArmUp) {
    return "Raise your top arm straight toward the ceiling.";
  }

  // Arms should form a vertical line (one up, one down/on ground)
  double leftArmAngle = calculateAngle(leftWrist, leftElbow!, leftShoulder);
  double rightArmAngle = calculateAngle(rightWrist!, rightElbow!, rightShoulder!);

  bool armsStraight =
      (leftArmAngle > 150 && leftArmAngle < 210) ||
          (rightArmAngle > 150 && rightArmAngle < 210);

  if (!armsStraight) {
    return "Straighten your raised arm fully.";
  }

  return "Beautiful Half Moon Pose!";
}

/// 19. Dancer Pose – Natarajasana
/// Standing on one leg, other leg kicked back and held, torso leaning forward, free arm extended.
String validateDancerPose(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];

  if ([
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle,
    leftWrist, rightWrist, leftElbow, rightElbow
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  // One leg should be straight (standing) and the other bent behind (kicked back)
  bool leftStraight = leftLegAngle > 155;
  bool rightStraight = rightLegAngle > 155;
  bool leftBent = leftLegAngle < 120;
  bool rightBent = rightLegAngle < 120;

  bool validStance = (leftStraight && rightBent) || (rightStraight && leftBent);

  if (!validStance) {
    return "Stand on one leg and kick the other back, bending the knee.";
  }

  // One arm should be extended forward (wrist above/at shoulder level)
  bool oneArmForward =
      leftWrist!.y < leftShoulder!.y || rightWrist!.y < rightShoulder!.y;

  if (!oneArmForward) {
    return "Extend your free arm forward and upward.";
  }

  return "Graceful Dancer Pose!";
}



/// 20. Lotus Pose – Padmasana
/// Seated with legs crossed and each foot resting on the opposite thigh.
String validateLotusPose(Pose pose) {
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];

  if ([
    leftHip, rightHip, leftKnee, rightKnee,
    leftAnkle, rightAnkle, leftShoulder, rightShoulder
  ].contains(null)) {
    return "Body not fully visible";
  }

  // Knees should be wide apart (externally rotated)
  double kneeSpread = (leftKnee!.x - rightKnee!.x).abs();
  double hipWidth = (leftHip!.x - rightHip!.x).abs();

  if (kneeSpread < hipWidth) {
    return "Open your knees wider to the sides.";
  }

  // Knees should be below hip level (seated)
  if (leftKnee.y < leftHip.y || rightKnee.y < rightHip.y) {
    return "Lower your knees toward the ground.";
  }

  // Ankles should be near the opposite knee (crossed in lap)
  bool anklesCrossed =
      (leftAnkle!.x - rightKnee.x).abs() < 80 ||
          (rightAnkle!.x - leftKnee.x).abs() < 80;

  if (!anklesCrossed) {
    return "Place each foot on the opposite thigh.";
  }

  // Torso should be upright — shoulders above hips
  if (leftShoulder!.y > leftHip.y || rightShoulder!.y > rightHip.y) {
    return "Sit up tall with your spine straight.";
  }

  return "Perfect Lotus Pose!";
}

/// 21. Easy Pose – Sukhasana
/// Simple cross-legged seated pose with upright spine.
String validateEasyPose(Pose pose) {
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];

  if ([
    leftHip, rightHip, leftKnee, rightKnee,
    leftAnkle, rightAnkle, leftShoulder, rightShoulder
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  // Both legs should be bent (cross-legged)
  bool legsCrossed =
      (leftLegAngle > 40 && leftLegAngle < 110) &&
          (rightLegAngle > 40 && rightLegAngle < 110);

  if (!legsCrossed) {
    return "Cross your legs and sit comfortably on the ground.";
  }

  // Spine upright — shoulders above hips
  if (leftShoulder!.y > leftHip.y || rightShoulder!.y > rightHip.y) {
    return "Sit up straight and lengthen your spine.";
  }

  return "Peaceful Easy Pose!";
}

/// 22. Hero Pose – Virasana
/// Kneeling with shins on the ground, sitting between heels, upright spine.
String validateHeroPose(Pose pose) {
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];

  if ([
    leftHip, rightHip, leftKnee, rightKnee,
    leftAnkle, rightAnkle, leftShoulder, rightShoulder
  ].contains(null)) {
    return "Body not fully visible";
  }

  // Knees should be bent tightly (kneeling)
  double leftKneeAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightKneeAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool kneesBent =
      (leftKneeAngle > 30 && leftKneeAngle < 90) &&
          (rightKneeAngle > 30 && rightKneeAngle < 90);

  if (!kneesBent) {
    return "Kneel and sit between your heels with knees together.";
  }

  // Hips should be at or below knee level
  if (leftHip.y < leftKnee!.y || rightHip.y < rightKnee!.y) {
    return "Lower your hips toward the floor between your heels.";
  }

  // Spine upright
  if (leftShoulder!.y > leftHip.y || rightShoulder!.y > rightHip.y) {
    return "Sit up tall with your spine straight.";
  }

  return "Excellent Hero Pose!";
}


/// 23. Boat Pose – Navasana
/// Seated, legs lifted and straight, torso leaning back at ~45°, arms extended forward.
String validateBoatPose(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];

  if ([
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle,
    leftWrist, rightWrist, leftElbow, rightElbow
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool legsStraight =
      (leftLegAngle > 140 && leftLegAngle < 200) &&
          (rightLegAngle > 140 && rightLegAngle < 200);

  if (!legsStraight) {
    return "Straighten your legs so they form a diagonal line.";
  }

  // Feet should be above hip level (legs lifted)
  if (leftAnkle.y > leftHip.y || rightAnkle.y > rightHip.y) {
    return "Lift your legs higher — keep them above hip level.";
  }

  // Arms should be extended parallel to the legs
  double leftArmAngle = calculateAngle(leftWrist!, leftElbow!, leftShoulder!);
  double rightArmAngle = calculateAngle(rightWrist!, rightElbow!, rightShoulder!);

  bool armsExtended =
      (leftArmAngle > 140 && leftArmAngle < 210) &&
          (rightArmAngle > 140 && rightArmAngle < 210);

  if (!armsExtended) {
    return "Extend your arms straight out, parallel to the floor.";
  }

  return "Strong Boat Pose!";
}

/// 24. Plank Pose
/// Body in a straight line from head to heels, arms straight, on hands and toes.
String validatePlankPose(Pose pose) {
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

  if ([
    leftWrist, rightWrist, leftElbow, rightElbow,
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftArmAngle = calculateAngle(leftWrist!, leftElbow!, leftShoulder!);
  double rightArmAngle = calculateAngle(rightWrist!, rightElbow!, rightShoulder!);

  bool armsStraight =
      (leftArmAngle > 150 && leftArmAngle < 210) &&
          (rightArmAngle > 150 && rightArmAngle < 210);

  if (!armsStraight) {
    return "Straighten your arms fully.";
  }

  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool legsStraight =
      (leftLegAngle > 155 && leftLegAngle < 210) &&
          (rightLegAngle > 155 && rightLegAngle < 210);

  if (!legsStraight) {
    return "Keep your legs straight — don't bend your knees.";
  }

  // Hips should be roughly in line with shoulders (no sagging or piking)
  double hipShoulderDiff = (leftHip.y - leftShoulder.y).abs();
  if (hipShoulderDiff > 40) {
    return "Keep your hips level — don't let them sag or rise too high.";
  }

  return "Perfect Plank Pose!";
}

/// 25. Side Plank – Vasisthasana
/// Balancing on one hand and the outer edge of one foot, body in a straight lateral line.
String validateSidePlank(Pose pose) {
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

  if ([
    leftWrist, rightWrist, leftElbow, rightElbow,
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle
  ].contains(null)) {
    return "Body not fully visible";
  }

  // The grounding arm should be straight
  double leftArmAngle = calculateAngle(leftWrist!, leftElbow!, leftShoulder!);
  double rightArmAngle = calculateAngle(rightWrist!, rightElbow!, rightShoulder!);

  bool oneArmStraight =
      (leftArmAngle > 150 && leftArmAngle < 210) ||
          (rightArmAngle > 150 && rightArmAngle < 210);

  if (!oneArmStraight) {
    return "Straighten your supporting arm fully.";
  }

  // Legs should be straight
  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool legsStraight =
      (leftLegAngle > 150 && leftLegAngle < 210) &&
          (rightLegAngle > 150 && rightLegAngle < 210);

  if (!legsStraight) {
    return "Keep both legs straight in a strong lateral line.";
  }

  // Hips should not be sagging — roughly level with shoulders
  double hipShoulderDiff = (leftHip.y - leftShoulder.y).abs();
  if (hipShoulderDiff > 60) {
    return "Lift your hips — don't let them sag toward the ground.";
  }

  return "Strong Side Plank!";
}



/// 26. Downward Dog Pose – Adho Mukha Svanasana
String validateDownwardDog(Pose pose) {
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

  if ([
    leftWrist, rightWrist, leftElbow, rightElbow,
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle
  ].contains(null)) {
    return "Body not fully visible";
  }

  double leftArmAngle = calculateAngle(leftWrist!, leftElbow!, leftShoulder!);
  double rightArmAngle = calculateAngle(rightWrist!, rightElbow!, rightShoulder!);
  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool armsStraight =
      (leftArmAngle > 130 && leftArmAngle < 200) &&
          (rightArmAngle > 130 && rightArmAngle < 200);

  bool legsStraight =
      (leftLegAngle > 130 && leftLegAngle < 190) &&
          (rightLegAngle > 130 && rightLegAngle < 190);

  if (!armsStraight) {
    return "Try straightening your arms.";
  }

  if (!legsStraight) {
    return "Straighten your legs more.";
  }

  if (leftHip.y > leftShoulder.y || rightHip.y > rightShoulder.y) {
    return "Lift your hips higher.";
  }

  return "Perfect Downward Dog pose!";
}

/// 27. Child's Pose – Balasana
/// Kneeling, torso folded forward onto thighs, arms extended or by the sides.
String validateChildPose(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];

  if ([
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle,
    leftWrist, rightWrist, leftElbow, rightElbow
  ].contains(null)) {
    return "Body not fully visible";
  }

  // Knees should be tightly bent (kneeling, sitting back on heels)
  double leftKneeAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightKneeAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool kneesBent =
      (leftKneeAngle > 30 && leftKneeAngle < 90) &&
          (rightKneeAngle > 30 && rightKneeAngle < 90);

  if (!kneesBent) {
    return "Sit your hips back toward your heels.";
  }

  // Shoulders should be below hip level (torso folded forward and down)
  if (leftShoulder!.y < leftHip.y || rightShoulder!.y < rightHip.y) {
    return "Lower your forehead toward the ground and relax your torso forward.";
  }

  // Arms should be extended forward (wrists in front of shoulders)
  bool armsExtended =
      leftWrist!.x < leftShoulder.x || rightWrist!.x < rightShoulder.x;

  if (!armsExtended) {
    return "Extend your arms forward on the ground or rest them by your sides.";
  }

  return "Restful Child's Pose!";
}

/// 28. Cat-Cow Pose – Marjaryasana / Bitilasana
/// On hands and knees; Cat = spine rounded up, Cow = spine arched down.
String validateCatCowPose(Pose pose) {
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];

  if ([
    leftWrist, rightWrist, leftElbow, rightElbow,
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle
  ].contains(null)) {
    return "Body not fully visible";
  }

  // Arms should be straight (hands directly under shoulders)
  double leftArmAngle = calculateAngle(leftWrist!, leftElbow!, leftShoulder!);
  double rightArmAngle = calculateAngle(rightWrist!, rightElbow!, rightShoulder!);

  bool armsStraight =
      (leftArmAngle > 150 && leftArmAngle < 210) &&
          (rightArmAngle > 150 && rightArmAngle < 210);

  if (!armsStraight) {
    return "Place your hands directly under your shoulders with arms straight.";
  }

  // Knees bent at ~90° (kneeling on all fours)
  double leftKneeAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightKneeAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool kneesRight =
      (leftKneeAngle > 70 && leftKneeAngle < 120) &&
          (rightKneeAngle > 70 && rightKneeAngle < 120);

  if (!kneesRight) {
    return "Position yourself on all fours with knees under your hips.";
  }

  // Detect Cat or Cow based on spine curve
  // Cat: hips below shoulders (spine rounded up, back arched)
  // Cow: hips above shoulders (belly drops, back arched the other way)
  bool isCat = leftHip.y > leftShoulder.y && rightHip.y > rightShoulder.y;
  bool isCow = leftHip.y < leftShoulder.y && rightHip.y < rightShoulder.y;

  if (!isCat && !isCow) {
    return "Round your spine up for Cat, or drop your belly for Cow.";
  }

  if (isCat) {
    return "Good Cat Pose — keep rounding your spine toward the ceiling!";
  }

  return "Good Cow Pose — let your belly drop and lift your head gently!";
}

/// 29. Shoulder Stand – Salamba Sarvangasana
/// Body inverted and vertical, weight on shoulders, legs straight up, hands supporting lower back.
String validateShoulderStand(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];

  if ([
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle,
    leftWrist, rightWrist, leftElbow, rightElbow
  ].contains(null)) {
    return "Body not fully visible";
  }

  // In shoulder stand, ankles should be above hips (inverted)
  if (leftAnkle!.y > leftHip!.y || rightAnkle!.y > rightHip!.y) {
    return "Lift your legs straight up toward the ceiling.";
  }

  // Hips should be above shoulders (fully inverted)
  if (leftHip.y > leftShoulder!.y || rightHip.y > rightShoulder!.y) {
    return "Lift your hips higher so your body is fully vertical.";
  }

  // Legs should be straight
  double leftLegAngle = calculateAngle(leftHip, leftKnee!, leftAnkle);
  double rightLegAngle = calculateAngle(rightHip, rightKnee!, rightAnkle);

  bool legsStraight =
      (leftLegAngle > 155 && leftLegAngle < 210) &&
          (rightLegAngle > 155 && rightLegAngle < 210);

  if (!legsStraight) {
    return "Straighten your legs fully toward the ceiling.";
  }

  return "Excellent Shoulder Stand!";
}

/// 30. Corpse Pose – Savasana
/// Lying flat on the back, arms and legs relaxed and slightly apart.
String validateCorpsePose(Pose pose) {
  PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
  PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
  PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
  PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
  PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
  PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  PoseLandmark? rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
  PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];

  if ([
    leftShoulder, rightShoulder, leftHip, rightHip,
    leftKnee, rightKnee, leftAnkle, rightAnkle,
    leftWrist, rightWrist, leftElbow, rightElbow
  ].contains(null)) {
    return "Body not fully visible";
  }

  // Legs should be straight and relaxed
  double leftLegAngle = calculateAngle(leftHip!, leftKnee!, leftAnkle!);
  double rightLegAngle = calculateAngle(rightHip!, rightKnee!, rightAnkle!);

  bool legsStraight =
      (leftLegAngle > 150 && leftLegAngle < 210) &&
          (rightLegAngle > 150 && rightLegAngle < 210);

  if (!legsStraight) {
    return "Extend your legs fully and let them relax outward.";
  }

  // Arms should be at sides, roughly straight
  double leftArmAngle = calculateAngle(leftWrist!, leftElbow!, leftShoulder!);
  double rightArmAngle = calculateAngle(rightWrist!, rightElbow!, rightShoulder!);

  bool armsStraight =
      (leftArmAngle > 140 && leftArmAngle < 210) &&
          (rightArmAngle > 140 && rightArmAngle < 210);

  if (!armsStraight) {
    return "Let your arms rest straight by your sides, palms facing up.";
  }

  double shoulderHipDiff = (leftShoulder.y - leftHip.y).abs();
  if (shoulderHipDiff > 60) {
    return "Lie completely flat — your whole body should be on the ground.";
  }

  return "Perfect Corpse Pose. Relax and breathe.";
}