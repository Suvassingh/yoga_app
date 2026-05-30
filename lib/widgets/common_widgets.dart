import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

// Gradient Fitness Card

class ExerciseCard extends StatelessWidget {
  final String title;
  final String muscleGroup;
  final String difficulty;
  final Color color;
  final String imagePath;
  final VoidCallback onTap;

  const ExerciseCard({
    super.key,
    required this.title,
    required this.muscleGroup,
    required this.difficulty,
    required this.color,
    required this.imagePath,
    required this.onTap,
  });

  Color get _difficultyColor {
    switch (difficulty) {
      case 'Beginner':
        return AppTheme.goodForm;
      case 'Advanced':
        return AppTheme.badForm;
      default:
        return AppTheme.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.6)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Difficulty badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _difficultyColor.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: _difficultyColor.withOpacity(0.6)),
                          ),
                          child: Text(
                            difficulty,
                            style: TextStyle(
                              color: _difficultyColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          muscleGroup,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Exercise GIF
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/$imagePath',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.fitness_center,
                        color: Colors.white54,
                        size: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  Stat Chip

class StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const StatChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// Feedback Banner

class FeedbackBanner extends StatelessWidget {
  final String message;
  final bool isGood;

  const FeedbackBanner({
    super.key,
    required this.message,
    required this.isGood,
  });

  @override
  Widget build(BuildContext context) {
    final color = isGood ? AppTheme.goodForm : AppTheme.badForm;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isGood ? Icons.check_circle_rounded : Icons.warning_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//  Rep Counter Badge

class RepCounterBadge extends StatelessWidget {
  final int count;
  final int target;
  final String exerciseTitle;
  final Color color;
  final String elapsedTime;

  const RepCounterBadge({
    super.key,
    required this.count,
    required this.target,
    required this.exerciseTitle,
    required this.color,
    required this.elapsedTime,
  });

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (count / target).clamp(0.0, 1.0) : 0.0;
    return Container(
      width: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          if (target > 0) ...[
            const SizedBox(height: 4),
            Text(
              '/ $target',
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation(Colors.white),
                minHeight: 4,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            exerciseTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 8),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer_outlined, color: Colors.white60, size: 10),
              const SizedBox(width: 2),
              Text(
                elapsedTime,
                style:
                    const TextStyle(color: Colors.white60, fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//  Angle Display Overlay

class AngleBadge extends StatelessWidget {
  final String label;
  final double angle;
  final bool isGood;

  const AngleBadge({
    super.key,
    required this.label,
    required this.angle,
    required this.isGood,
  });

  @override
  Widget build(BuildContext context) {
    final color = isGood ? AppTheme.goodForm : AppTheme.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.7)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${angle.toStringAsFixed(0)}°',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 9),
          ),
        ],
      ),
    );
  }
}
