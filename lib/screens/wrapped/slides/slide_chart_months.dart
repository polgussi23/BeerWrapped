// screens/wrapped/slides/slide_chart_months.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SlideChartMonths extends StatefulWidget {
  final Map<String, dynamic> data;

  const SlideChartMonths({Key? key, required this.data}) : super(key: key);

  @override
  _SlideChartMonthsState createState() => _SlideChartMonthsState();
}

class _SlideChartMonthsState extends State<SlideChartMonths>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  static const _monthNames = [
    '',
    'GEN',
    'FEB',
    'MAR',
    'ABR',
    'MAI',
    'JUN',
    'JUL',
    'AGO',
    'SET',
    'OCT',
    'NOV',
    'DES'
  ];

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
    final beersByMonth = widget.data['charts']['beersByMonth'] as List<dynamic>;

    // Construïm un map mes -> count
    final Map<int, int> monthMap = {};
    for (final item in beersByMonth) {
      monthMap[item['month'] as int] = item['count'] as int;
    }

    final maxY = monthMap.values.isEmpty
        ? 10.0
        : monthMap.values.reduce((a, b) => a > b ? a : b).toDouble() + 2;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A2E1A), Color(0xFF0D4A2A)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Birres per mes',
              style: TextStyle(
                fontFamily: 'Kameron',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Quin ha estat el teu mes més productiu?',
              textAlign: TextAlign.center,
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
                            final month = value.toInt() + 1;
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _monthNames[month],
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 10,
                                  fontFamily: 'Kameron',
                                ),
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
                    barGroups: List.generate(12, (index) {
                      final month = index + 1;
                      final count = (monthMap[month] ?? 0).toDouble();
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: count * _anim.value,
                            color: const Color(0xFFB5884C),
                            width: 16,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
