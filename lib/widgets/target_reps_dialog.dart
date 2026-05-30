import 'package:flutter/material.dart';
import '../utils/app_theme.dart';


Future<int?> showTargetRepsDialog(
    BuildContext context, String exerciseName) async {
  int selected = 10;
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: AppTheme.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setModalState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Set Your Goal',
                  textAlign: TextAlign.center,
                  style: Theme.of(ctx).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  exerciseName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppTheme.accent, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 24),

                // Quick presets
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [5, 10, 15, 20, 25, 30].map((v) {
                    final isSelected = selected == v;
                    return GestureDetector(
                      onTap: () => setModalState(() => selected = v),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.accent
                              : AppTheme.cardLight,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? null
                              : Border.all(color: Colors.white12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$v',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.black
                                : Colors.white70,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),
                // Slider for custom value
                SliderTheme(
                  data: SliderTheme.of(ctx).copyWith(
                    activeTrackColor: AppTheme.accent,
                    thumbColor: AppTheme.accent,
                    inactiveTrackColor: Colors.white12,
                    overlayColor: AppTheme.accent.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: selected.toDouble(),
                    min: 1,
                    max: 100,
                    divisions: 99,
                    label: '$selected reps',
                    onChanged: (v) =>
                        setModalState(() => selected = v.round()),
                  ),
                ),

                const SizedBox(height: 24),
                Row(
                  children: [
                    // Skip — no target
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white24),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () => Navigator.pop(ctx, 0),
                        child: const Text('No Goal',
                            style: TextStyle(color: Colors.white60)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Start
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () => Navigator.pop(ctx, selected),
                        child: Text(
                          'Start — $selected Reps',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
