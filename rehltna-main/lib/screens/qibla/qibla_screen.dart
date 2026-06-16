import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class QiblaScreen extends StatefulWidget {
  final Position? initialPosition;
  const QiblaScreen({super.key, this.initialPosition});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with SingleTickerProviderStateMixin {
  static const double _meccaLat = 21.4225;
  static const double _meccaLon = 39.8262;

  bool _loadingLocation = true;
  bool _locationDenied = false;
  double _qiblaAngle = 0; // bearing from user to Mecca (0–360°)

  late AnimationController _animController;
  late Animation<double> _animation;
  double _lastAngle = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _initLocation();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    // Use position passed from profile page if already available
    if (widget.initialPosition != null) {
      if (mounted) setState(() {
        _qiblaAngle = _calcQibla(widget.initialPosition!.latitude, widget.initialPosition!.longitude);
        _loadingLocation = false;
      });
      return;
    }
    // Otherwise request permission and get position
    final status = await Permission.location.request();
    if (!status.isGranted) {
      if (mounted) setState(() { _loadingLocation = false; _locationDenied = true; });
      return;
    }
    try {
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      if (mounted) {
        setState(() {
          _qiblaAngle = _calcQibla(pos.latitude, pos.longitude);
          _loadingLocation = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() { _loadingLocation = false; _locationDenied = true; });
    }
  }

  double _calcQibla(double lat, double lon) {
    final lat1 = lat * math.pi / 180;
    final lat2 = _meccaLat * math.pi / 180;
    final dLon = (_meccaLon - lon) * math.pi / 180;
    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
  }

  void _updateArrow(double targetRad) {
    double diff = targetRad - _lastAngle;
    if (diff > math.pi) diff -= 2 * math.pi;
    if (diff < -math.pi) diff += 2 * math.pi;
    _animation = Tween<double>(begin: _lastAngle, end: _lastAngle + diff).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward(from: 0);
    _lastAngle += diff;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0d1117) : const Color(0xFFF0F2F5);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text('اتجاه القبلة', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loadingLocation
          ? _buildLoading()
          : _locationDenied
              ? _buildPermissionDenied()
              : _buildMain(isDark),
    );
  }

  Widget _buildLoading() => const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CircularProgressIndicator(),
          SizedBox(height: 14),
          Text('جارٍ تحديد موقعك...', style: TextStyle(color: Colors.grey)),
        ]),
      );

  Widget _buildMain(bool isDark) {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.heading == null) {
          return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.sensors_off_rounded, size: 56, color: Colors.grey),
            SizedBox(height: 12),
            Text('جهازك لا يدعم البوصلة', style: TextStyle(color: Colors.grey)),
          ]));
        }

        final heading = snapshot.data!.heading!;
        // Arrow must point toward Mecca: rotate the needle by (qibla - heading)
        final arrowRad = (_qiblaAngle - heading) * math.pi / 180;
        _updateArrow(arrowRad);

        final diff = ((_qiblaAngle - heading) % 360 + 360) % 360;
        final isAligned = diff < 5 || diff > 355;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            const SizedBox(height: 24),

            // Instruction
            Text(
              isAligned ? 'أنت تواجه القبلة الآن' : 'وجّه هاتفك حتى يشير السهم نحو الكعبة 🕋',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isAligned ? Colors.green : (isDark ? Colors.white70 : Colors.black54),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            // ── COMPASS ──
            SizedBox(
              width: 280,
              height: 280,
              child: Stack(alignment: Alignment.center, children: [

                // Outer compass ring
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? const Color(0xFF1c2333) : Colors.white,
                    boxShadow: [BoxShadow(
                      color: isAligned ? Colors.green.withOpacity(0.3) : Colors.black.withOpacity(0.1),
                      blurRadius: 24, spreadRadius: 2,
                    )],
                    border: Border.all(
                      color: isAligned ? Colors.green.withOpacity(0.6) : Colors.grey.withOpacity(0.2),
                      width: 2.5,
                    ),
                  ),
                ),

                // Tick marks
                CustomPaint(size: const Size(280, 280), painter: _CompassTickPainter(isDark)),

                // N / S / E / W labels (fixed — they don't rotate)
                ..._compassLabels(isDark),

                // ── ROTATING ARROW (points toward Mecca) ──
                AnimatedBuilder(
                  animation: _animation,
                  builder: (_, child) => Transform.rotate(angle: _animation.value, child: child),
                  child: CustomPaint(
                    size: const Size(280, 280),
                    painter: _ArrowPainter(isAligned: isAligned),
                  ),
                ),

                // ── FIXED KAABA at top (target) ──
                Transform.translate(
                  offset: const Offset(0, -112),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isAligned ? Colors.green : const Color(0xFF1a3a5c),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(
                        color: (isAligned ? Colors.green : const Color(0xFF1a3a5c)).withOpacity(0.5),
                        blurRadius: 10, spreadRadius: 1,
                      )],
                    ),
                    child: const Center(child: Text('🕋', style: TextStyle(fontSize: 18))),
                  ),
                ),

                // Center circle
                Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(
                    color: isAligned ? Colors.green : const Color(0xFF1a3a5c),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [BoxShadow(
                      color: (isAligned ? Colors.green : const Color(0xFF1a3a5c)).withOpacity(0.5),
                      blurRadius: 8,
                    )],
                  ),
                ),
              ]),
            ),

            const SizedBox(height: 30),

            // Kaaba decoration — fixed, not on needle
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              decoration: BoxDecoration(
                color: isAligned ? Colors.green.withOpacity(0.1) : (isDark ? const Color(0xFF1c2333) : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isAligned ? Colors.green.withOpacity(0.4) : Colors.transparent,
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Row(children: [
                const Text('🕋', style: TextStyle(fontSize: 34)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    isAligned ? 'مواجه القبلة ✓' : 'مكة المكرمة',
                    style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold,
                      color: isAligned ? Colors.green : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'المسجد الحرام — قبلة المسلمين',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ])),
              ]),
            ),

            const SizedBox(height: 14),

            // Angle info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1c2333) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _chip(Icons.explore_rounded, '${_qiblaAngle.toStringAsFixed(0)}°', 'اتجاه القبلة', isDark),
                Container(width: 1, height: 36, color: Colors.grey.withOpacity(0.2)),
                _chip(Icons.navigation_rounded, '${heading.toStringAsFixed(0)}°', 'البوصلة', isDark),
                Container(width: 1, height: 36, color: Colors.grey.withOpacity(0.2)),
                _chip(Icons.sync_alt_rounded, '${diff.toStringAsFixed(0)}°', 'الفرق', isDark),
              ]),
            ),

            const SizedBox(height: 30),
          ]),
        );
      },
    );
  }

  List<Widget> _compassLabels(bool isDark) {
    const dirs = [
      {'l': 'ش', 'a': 0.0, 'red': true},
      {'l': 'ق', 'a': math.pi / 2, 'red': false},
      {'l': 'ج', 'a': math.pi, 'red': false},
      {'l': 'غ', 'a': -math.pi / 2, 'red': false},
    ];
    return dirs.map((d) {
      final a = d['a'] as double;
      final isRed = d['red'] as bool;
      return Transform.translate(
        offset: Offset(108 * math.sin(a), -108 * math.cos(a)),
        child: Text(d['l'] as String, style: TextStyle(
          fontSize: 13, fontWeight: FontWeight.bold,
          color: isRed ? Colors.red : (isDark ? Colors.white38 : Colors.black38),
        )),
      );
    }).toList();
  }

  Widget _chip(IconData icon, String value, String label, bool isDark) {
    return Column(children: [
      Icon(icon, size: 18, color: const Color(0xFF1a3a5c)),
      const SizedBox(height: 5),
      Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87)),
      Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
    ]);
  }

  Widget _buildPermissionDenied() => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.location_off_rounded, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            const Text('يلزم إذن الموقع',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('لتحديد اتجاه القبلة بدقة يحتاج التطبيق إلى موقعك',
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: openAppSettings,
              icon: const Icon(Icons.settings_rounded),
              label: const Text('فتح الإعدادات'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ]),
        ),
      );
}

// ── Arrow painter — clean teardrop/chevron pointing UP = toward Mecca ──
class _ArrowPainter extends CustomPainter {
  final bool isAligned;
  _ArrowPainter({required this.isAligned});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final color = isAligned ? Colors.green : const Color(0xFF1a3a5c);
    final colorLight = isAligned ? Colors.green.shade300 : const Color(0xFF5b8db8);

    final paintFill = Paint()..style = PaintingStyle.fill;
    final paintStroke = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = Colors.white.withOpacity(0.6);

    // Upper half — points toward Mecca (gold/blue tip)
    final upperPath = Path()
      ..moveTo(cx, cy - 100)          // tip
      ..lineTo(cx + 14, cy - 10)      // right shoulder
      ..quadraticBezierTo(cx, cy - 5, cx - 14, cy - 10) // smooth base
      ..close();

    paintFill.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [color, colorLight],
    ).createShader(Rect.fromLTWH(cx - 14, cy - 100, 28, 95));

    canvas.drawPath(upperPath, paintFill);
    canvas.drawPath(upperPath, paintStroke);

    // Lower half — opposite tail (lighter/grey)
    final lowerPath = Path()
      ..moveTo(cx - 10, cy + 5)
      ..lineTo(cx + 10, cy + 5)
      ..lineTo(cx, cy + 70)
      ..close();

    paintFill.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.grey.shade400, Colors.grey.shade200],
    ).createShader(Rect.fromLTWH(cx - 10, cy + 5, 20, 65));

    canvas.drawPath(lowerPath, paintFill);
    canvas.drawPath(lowerPath, paintStroke);
  }

  @override
  bool shouldRepaint(_ArrowPainter old) => old.isAligned != isAligned;
}

// ── Compass tick marks ──
class _CompassTickPainter extends CustomPainter {
  final bool isDark;
  _CompassTickPainter(this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 8;

    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = isDark ? Colors.white24 : Colors.black12;

    for (int i = 0; i < 72; i++) {
      final angle = i * 5 * math.pi / 180;
      final isMajor = i % 9 == 0; // every 45°
      final isMid = i % 3 == 0;   // every 15°
      final len = isMajor ? 12.0 : (isMid ? 7.0 : 4.0);
      paint.strokeWidth = isMajor ? 2.0 : 1.0;

      final x1 = cx + r * math.sin(angle);
      final y1 = cy - r * math.cos(angle);
      final x2 = cx + (r - len) * math.sin(angle);
      final y2 = cy - (r - len) * math.cos(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(_CompassTickPainter old) => old.isDark != isDark;
}
