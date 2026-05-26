import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/views/initial/cubit/theme_cubit.dart';

class ThemeModeSwitch extends StatefulWidget {
  const ThemeModeSwitch({super.key});

  @override
  State<ThemeModeSwitch> createState() => _ThemeModeSwitchState();
}

class _ThemeModeSwitchState extends State<ThemeModeSwitch>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  late final Animation<double> _slideAnim = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutBack,
  );

  late final ThemeCubit _cubit = getItInstance.get<ThemeCubit>();

  @override
  void initState() {
    super.initState();
    if (_cubit.state == ThemeMode.dark) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle(bool isDark) {
    final ThemeMode target = isDark ? ThemeMode.light : ThemeMode.dark;
    _cubit.toggleTheme(target);
    if (target == ThemeMode.dark) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ThemeCubit, ThemeMode>(
      bloc: _cubit,
      listener: (BuildContext context, ThemeMode state) {
        if (state == ThemeMode.dark && !_controller.isAnimating) {
          _controller.forward();
        } else if (state == ThemeMode.light && !_controller.isAnimating) {
          _controller.reverse();
        }
      },
      child: GestureDetector(
        onTap: () => _toggle(_cubit.state == ThemeMode.dark),
        child: AnimatedBuilder(
          animation: _slideAnim,
          builder: (BuildContext context, Widget? child) {
            final double t = _slideAnim.value;
            return CustomPaint(
              size: const Size(58.0, 28.0),
              painter: _DayNightPainter(t),
            );
          },
        ),
      ),
    );
  }
}

class _DayNightPainter extends CustomPainter {
  final double t;
  _DayNightPainter(this.t);

  static const Color _dayTop = Color(0xFF87CEEB);
  static const Color _dayBottom = Color(0xFFB8E4F9);
  static const Color _nightTop = Color(0xFF0D1B2A);
  static const Color _nightBottom = Color(0xFF1B2838);
  static const Color _sunColor = Color(0xFFFDB813);
  static const Color _moonColor = Color(0xFFF0E68C);

  @override
  void paint(Canvas canvas, Size size) {
    final double r = size.height / 2;

    // Track
    final RRect track = RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(r));
    final Color topColor = Color.lerp(_dayTop, _nightTop, t)!;
    final Color bottomColor = Color.lerp(_dayBottom, _nightBottom, t)!;
    final Paint trackPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[topColor, bottomColor],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRRect(track, trackPaint);

    // Stars (fade in during night)
    if (t > 0.3) {
      final double starAlpha = ((t - 0.3) / 0.7).clamp(0.0, 1.0);
      final Paint starPaint = Paint()..color = Colors.white.withValues(alpha: starAlpha * 0.9);
      const List<Offset> starPositions = [
        Offset(10, 7), Offset(18, 17), Offset(12, 20),
        Offset(22, 8), Offset(7, 14), Offset(26, 19),
      ];
      for (final Offset pos in starPositions) {
        canvas.drawCircle(pos, 1.0, starPaint);
      }
    }

    // Clouds (fade in during day)
    if (t < 0.7) {
      final double cloudAlpha = (1.0 - t / 0.7).clamp(0.0, 1.0);
      final Paint cloudPaint = Paint()..color = Colors.white.withValues(alpha: cloudAlpha * 0.35);
      canvas.drawRRect(
        RRect.fromLTRBR(30, 18, 44, 23, const Radius.circular(3)),
        cloudPaint,
      );
      canvas.drawRRect(
        RRect.fromLTRBR(36, 14, 48, 19, const Radius.circular(3)),
        cloudPaint,
      );
    }

    // Thumb
    final double thumbPadding = 3.0;
    final double thumbDiameter = size.height - thumbPadding * 2;
    final double thumbR = thumbDiameter / 2;
    final double minX = thumbPadding + thumbR;
    final double maxX = size.width - thumbPadding - thumbR;
    final double cx = minX + (maxX - minX) * t;
    final double cy = size.height / 2;

    // Thumb glow
    final Color glowColor = Color.lerp(
      _sunColor.withValues(alpha: 0.3),
      _moonColor.withValues(alpha: 0.2),
      t,
    )!;
    canvas.drawCircle(
      Offset(cx, cy),
      thumbR + 3,
      Paint()
        ..color = glowColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Thumb circle
    final Color thumbColor = Color.lerp(_sunColor, _moonColor, t)!;
    canvas.drawCircle(
      Offset(cx, cy),
      thumbR,
      Paint()..color = thumbColor,
    );

    // Sun rays (fade out) / Moon crescent (fade in)
    if (t < 0.5) {
      final double rayAlpha = (1.0 - t * 2).clamp(0.0, 1.0);
      final Paint rayPaint = Paint()
        ..color = Colors.white.withValues(alpha: rayAlpha * 0.8)
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round;
      for (int j = 0; j < 8; j++) {
        final double angle = j * math.pi / 4;
        final double inner = thumbR + 1.5;
        final double outer = thumbR + 4.0;
        canvas.drawLine(
          Offset(cx + inner * math.cos(angle), cy + inner * math.sin(angle)),
          Offset(cx + outer * math.cos(angle), cy + outer * math.sin(angle)),
          rayPaint,
        );
      }
    }

    if (t > 0.5) {
      final double craterAlpha = ((t - 0.5) * 2).clamp(0.0, 1.0);
      final Paint craterPaint = Paint()
        ..color = Color.lerp(_moonColor, const Color(0xFFD4C85E), 0.5)!
            .withValues(alpha: craterAlpha);
      canvas.drawCircle(Offset(cx - 3, cy - 3), thumbR * 0.7, craterPaint);
    }
  }

  @override
  bool shouldRepaint(_DayNightPainter old) => old.t != t;
}
