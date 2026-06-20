import 'package:birrawrapped/models/wrapped_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SlideRecords extends StatefulWidget {
  final WrappedData data;
  const SlideRecords({Key? key, required this.data}) : super(key: key);

  @override
  _SlideRecordsState createState() => _SlideRecordsState();
}

class _SlideRecordsState extends State<SlideRecords>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final dt = DateTime.parse(isoDate);
      return DateFormat('d MMMM yyyy', 'ca').format(dt);
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A1A2E), Color(0xFF1F3D6E)],
        ),
      ),
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🏆', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                const Text(
                  'Els teus rècords',
                  style: TextStyle(
                    fontFamily: 'Kameron',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                if (d.peakDay != null)
                  _record('🗓️', 'Dia més èpic',
                      '${d.peakDayCount} birres el ${_formatDate(d.peakDay)}'),
                if (d.earliestBeer != null)
                  _record('🌅', 'La més matinera', 'Les ${d.earliestBeer}h'),
                if (d.latestBeer != null)
                  _record('🌙', 'La més tardana', 'Les ${d.latestBeer}h'),
                if (d.bestWeekStart != null)
                  _record('🔥', 'Setmana més intensa',
                      '${d.bestWeekCount} birres — setmana del ${_formatDate(d.bestWeekStart)}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _record(String emoji, String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB5884C).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontFamily: 'Kameron',
                        fontSize: 13,
                        color: Color(0xFFB5884C))),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontFamily: 'Kameron',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
