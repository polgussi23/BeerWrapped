// screens/wrapped/slides/slide_chart_moments.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SlideChartMoments extends StatefulWidget {
  final Map<String, dynamic> data;

  const SlideChartMoments({Key? key, required this.data}) : super(key: key);

  @override
  _SlideChartMomentsState createState() => _SlideChartMomentsState();
}

class _SlideChartMomentsState extends State<SlideChartMoments>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  static const _momentOrder = [
    'Matí',
    'Migdia',
    'Tarda',
    'Vespre',
    'Nit',
    'Matinada'
  ];
  static const _momentEmojis = {
    'Matí': '🌅',
    'Migdia': '☀️',
    'Tarda': '🌤️',
    'Vespre': '🌇',
    'Nit': '🌙',
    'Matinada': '🌃',
  };
  static const _momentColors = {
    'Matí': Color(0xFFFFB347),
    'Migdia': Color(0xFFFFD700),
    'Tarda': Color(0xFFFF8C00),
    'Vespre': Color.fromARGB(255, 105, 5, 136),
    'Nit': Color(0xFF4169E1),
    'Matinada': Color(0xFF191970),
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final beersByMoment =
        widget.data['charts']['beersByMoment'] as List<dynamic>;

    final Map<String, int> momentMap = {};
    for (final item in beersByMoment) {
      momentMap[item['moment'] as String] = item['count'] as int;
    }

    final maxY = momentMap.values.isEmpty
        ? 10.0
        : momentMap.values.reduce((a, b) => a > b ? a : b).toDouble() + 2;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A0A2E), Color(0xFF1A1A4A)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Quan beus més?',
              style: TextStyle(
                fontFamily: 'Kameron',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'El teu moment del dia preferit',
              style: TextStyle(
                fontFamily: 'Kameron',
                fontSize: 16,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: AnimatedBuilder(
                animation: _anim,
                builder: (context, child) => BarChart(
                  BarChartData(
                    maxY: maxY,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final moment = _momentOrder[value.toInt()];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                _momentEmojis[moment] ?? '',
                                style: const TextStyle(fontSize: 20),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.white12,
                        strokeWidth: 1,
                      ),
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(
                      _momentOrder.length,
                      (index) {
                        final moment = _momentOrder[index];
                        final count = (momentMap[moment] ?? 0).toDouble();
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: count * _anim.value,
                              color: _momentColors[moment],
                              width: 32,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Llegenda
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _momentOrder.map((moment) {
                final count = momentMap[moment] ?? 0;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _momentColors[moment],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$moment ($count)',
                      style: const TextStyle(
                        fontFamily: 'Kameron',
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
