
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../yoga_pose_list.dart';
typedef PoseValidator = String Function(Pose pose);

Map<String, PoseValidator> getAllYogaValidators() => {
      'Mountain Pose': validateMountainPose,
      'Tree Pose': validateTreePose,
      'Warrior I': validateWarriorI,
      'Warrior II': validateWarriorII,
      'Warrior III': validateWarriorIII,
      'Triangle Pose': validateTrianglePose,
      'Chair Pose': validateChairPose,
      'Extended Side Angle': validateExtendedSideAngle,
      'Standing Forward Fold': validateStandingForwardFold,
      'Seated Forward Bend': validateSeatedForwardBend,
      'Wide-Legged Forward Bend': validateWideLeggedForwardBend,
      'Upward Dog': validateUpwardDog,
      'Cobra Pose': validateCobraPose,
      'Bridge Pose': validateBridgePose,
      'Camel Pose': validateCamelPose,
      'Wheel Pose': validateWheelPose,
      'Eagle Pose': validateEaglePose,
      'Half Moon Pose': validateHalfMoonPose,
      'Dancer Pose': validateDancerPose,
      'Lotus Pose': validateLotusPose,
      'Easy Pose': validateEasyPose,
      'Hero Pose': validateHeroPose,
      'Boat Pose': validateBoatPose,
      'Plank Pose': validatePlankPose,
      'Side Plank': validateSidePlank,
      'Downward Dog': validateDownwardDog,
      "Child's Pose": validateChildPose,
      'Cat-Cow Pose': validateCatCowPose,
      'Shoulder Stand': validateShoulderStand,
      'Corpse Pose': validateCorpsePose,
    };
