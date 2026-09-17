import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

/// A custom loading indicator where grade letters (A+, B, C, D) orbit
/// around a central glowing nucleus — like electrons around an atom.
///
/// Usage:
/// ```dart
/// const OrbitalLoadingIndicator()          // default 100px
/// const OrbitalLoadingIndicator(size: 60)  // compact
/// ```
class OrbitalLoadingIndicator extends StatefulWidget {
  final double size;

  const OrbitalLoadingIndicator({super.key, this.size = 100});

  @override
  State<OrbitalLoadingIndicator> createState() =>
      _OrbitalLoadingIndicatorState();
}

class _OrbitalLoadingIndicatorState extends State<OrbitalLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Each grade has: label, orbit radius factor, speed multiplier, phase offset
  static const _grades = [
    _GradeOrbit('A+', 0.38, 1.0, 0),
    _GradeOrbit('B', 0.34, -0.75, math.pi * 0.6),
    _GradeOrbit('C', 0.30, 0.55, math.pi * 1.2),
    _GradeOrbit('D', 0.26, -0.40, math.pi * 1.8),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _OrbitTrailPainter(
              progress: _controller.value,
              size: widget.size,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ── Central glowing nucleus ──
                _buildNucleus(),
                // ── Orbiting grade letters ──
                for (int i = 0; i < _grades.length; i++)
                  _buildOrbitingLetter(_grades[i], i),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNucleus() {
    // Pulse the glow radius subtly
    final pulse = 0.8 + 0.2 * math.sin(_controller.value * 2 * math.pi);
    final dotSize = widget.size * 0.10;

    return Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.brandPurple,
        boxShadow: [
          BoxShadow(
            color: AppColors.brandPurple.withValues(alpha: 0.7 * pulse),
            blurRadius: 16 * pulse,
            spreadRadius: 4 * pulse,
          ),
          BoxShadow(
            color: AppColors.brandAccent.withValues(alpha: 0.3 * pulse),
            blurRadius: 24 * pulse,
            spreadRadius: 2 * pulse,
          ),
        ],
      ),
    );
  }

  Widget _buildOrbitingLetter(_GradeOrbit grade, int index) {
    final angle =
        _controller.value * 2 * math.pi * grade.speed + grade.phaseOffset;
    final radius = widget.size * grade.radiusFactor;
    final center = widget.size / 2;

    final x = center + radius * math.cos(angle);
    final y = center + radius * math.sin(angle);

    // Simulate depth: letters "behind" the nucleus appear smaller & dimmer
    final depth = math.sin(angle); // -1 (back) → +1 (front)
    final scale = 0.7 + 0.3 * ((depth + 1) / 2); // 0.7 → 1.0
    final opacity = 0.35 + 0.65 * ((depth + 1) / 2); // 0.35 → 1.0

    // A+ gets the accent color, others get white
    final color = index == 0
        ? AppColors.brandAccent
        : Color.lerp(AppColors.gradeMid, Colors.white, (depth + 1) / 2)!;

    final fontSize = widget.size * 0.13;

    return Positioned(
      left: x - fontSize * 0.6,
      top: y - fontSize * 0.7,
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: Text(
            grade.label,
            style: AppTextStyles.h1.copyWith(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              shadows: [
                Shadow(
                  color: color.withValues(alpha: 0.6),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints faint circular orbit trails behind the letters.
class _OrbitTrailPainter extends CustomPainter {
  final double progress;
  final double size;

  _OrbitTrailPainter({required this.progress, required this.size});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(size / 2, size / 2);

    for (final grade in _OrbitalLoadingIndicatorState._grades) {
      final radius = size * grade.radiusFactor;
      final paint = Paint()
        ..color = AppColors.brandPurple.withValues(alpha: 0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_OrbitTrailPainter oldDelegate) => false;
}

/// Data class for each orbiting grade letter.
class _GradeOrbit {
  final String label;
  final double radiusFactor; // fraction of total widget size
  final double speed; // multiplier (negative = reverse direction)
  final double phaseOffset; // radians

  const _GradeOrbit(this.label, this.radiusFactor, this.speed, this.phaseOffset);
}
