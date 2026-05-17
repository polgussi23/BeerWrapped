// screens/wrapped/slides/slide_final.dart
import 'dart:io';
import 'dart:ui' as ui;
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SlideFinal extends StatefulWidget {
  final Map<String, dynamic> data;

  const SlideFinal({Key? key, required this.data}) : super(key: key);

  @override
  _SlideFinalState createState() => _SlideFinalState();
}

class _SlideFinalState extends State<SlideFinal>
    with SingleTickerProviderStateMixin {
  final GlobalKey _shareKey = GlobalKey();
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _shareWrapped() async {
    setState(() => _isSharing = true);

    try {
      // Capturem el widget com a imatge
      final boundary =
          _shareKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      // Guardem la imatge temporalment
      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/birrawrapped_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'El meu BirraWrapped 🍺 #BirraWrapped',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al compartir')),
      );
    } finally {
      setState(() => _isSharing = false);
    }
  }

  String _whereToGo() {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    final up = context.read<UserProvider>();

    final DateTime startDay = up.getStartDay()!;
    final DateTime finalDay =
        DateTime(startDay.year + 1, startDay.month, startDay.day);

    if (startDay.isAfter(today)) {
      return "/waittostart";
    } else if (finalDay.isBefore(today)) {
      return "/chooseDay";
    } else {
      return "/home";
    }
  }

  @override
  Widget build(BuildContext context) {
    final totals = widget.data['totals'];
    final favBeer = widget.data['favBeer'];
    final bestDay = widget.data['bestDayOfWeek'];
    final maxStreak = widget.data['maxStreak'];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A0A00), Color(0xFF3D1F00)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Text(
                'El teu resum 🍺',
                style: TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Targeta per compartir — amb els colors de l'app
              Expanded(
                child: RepaintBoundary(
                  key: _shareKey,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE4D3),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo / títol
                          const Text(
                            '🍺',
                            style: TextStyle(fontSize: 48),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'BirraWrapped',
                            style: TextStyle(
                              fontFamily: 'Kameron',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3D1F00),
                            ),
                          ),
                          const Divider(
                            color: Color(0xFFB5884C),
                            thickness: 2,
                            height: 24,
                          ),
                          // Estadístiques
                          _StatRow(
                            emoji: '🍺',
                            label: 'Total birres',
                            value: '${totals['totalBeers']}',
                          ),
                          _StatRow(
                            emoji: '💧',
                            label: 'Total litres',
                            value: '${totals['totalLiters']}L',
                          ),
                          if (favBeer != null)
                            _StatRow(
                              emoji: '🏆',
                              label: 'Preferida',
                              value:
                                  '${(favBeer['name'] as String).substring(0, 1).toUpperCase()}${(favBeer['name'] as String).substring(1)} (${favBeer['percentage']}%)',
                            ),
                          if (bestDay != null)
                            _StatRow(
                              emoji: '📅',
                              label: 'Dia preferit',
                              value: bestDay['day'],
                            ),
                          _StatRow(
                            emoji: '🔥',
                            label: 'Ratxa màxima',
                            value: '$maxStreak dies',
                          ),
                          const Divider(
                            color: Color(0xFFB5884C),
                            thickness: 1,
                            height: 24,
                          ),
                          const Text(
                            '#BirraWrapped',
                            style: TextStyle(
                              fontFamily: 'Kameron',
                              fontSize: 16,
                              color: Color(0xFFB5884C),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Botó de compartir
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSharing ? null : _shareWrapped,
                  icon: _isSharing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.share, color: Colors.white),
                  label: Text(
                    _isSharing ? 'Compartint...' : 'Compartir a Instagram 📸',
                    style: const TextStyle(
                      fontFamily: 'Kameron',
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB5884C),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  // Guardem que ha vist el wrapped
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString(
                    'wrappedSeenDate',
                    DateTime.now().toIso8601String(),
                  );
                  if (!mounted) return;
                  //Navigator.pushReplacementNamed(context, _whereToGo());
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: const Text(
                  'Tornar a l\'app',
                  style: TextStyle(
                    fontFamily: 'Kameron',
                    color: Colors.white54,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _StatRow({
    required this.emoji,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Kameron',
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Kameron',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3D1F00),
            ),
          ),
        ],
      ),
    );
  }
}
