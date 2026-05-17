// screens/wrapped/slides/slide_chart_types.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SlideChartTypes extends StatefulWidget {
  final Map<String, dynamic> data;

  const SlideChartTypes({Key? key, required this.data}) : super(key: key);

  @override
  _SlideChartTypesState createState() => _SlideChartTypesState();
}

class _SlideChartTypesState extends State<SlideChartTypes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;
  int _touchedIndex = -1;

  static const _colors = [
    Color(0xFFB5884C),
    Color(0xFF4C8FB5),
    Color(0xFF4CB574),
    Color(0xFFB54C4C),
    Color(0xFF9B4CB5),
    Color(0xFFB5A94C),
    Color(0xFF5C6BC0),
    Color(0xFF26A69A),
    Color(0xFFEF5350),
    Color(0xFFFF7043),
    Color(0xFF8D6E63),
    Color(0xFF78909C),
    Color(0xFF66BB6A),
    Color(0xFFAB47BC),
    Color(0xFFFFCA28),
    Color(0xFF42A5F5),
    Color(0xFFD4E157),
    Color(0xFFEC407A),
    Color(0xFF7E57C2),
    Color(0xFFFFA726),
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
    final beersByType = widget.data['charts']['beersByType'] as List<dynamic>;
    final total =
        beersByType.fold<int>(0, (sum, item) => sum + (item['count'] as int));

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A0A2E), Color(0xFF2E1A4A)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Les teves birres',
              style: TextStyle(
                fontFamily: 'Kameron',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Quina varietat has tingut?',
              style: TextStyle(
                fontFamily: 'Kameron',
                fontSize: 16,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _anim,
              builder: (context, child) => SizedBox(
                height: 220,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          _touchedIndex =
                              response?.touchedSection?.touchedSectionIndex ??
                                  -1;
                        });
                      },
                    ),
                    sections: List.generate(beersByType.length, (index) {
                      final item = beersByType[index];
                      final count = item['count'] as int;
                      final percentage = (count / total * 100);
                      final isTouched = index == _touchedIndex;

                      return PieChartSectionData(
                        value: count.toDouble() * _anim.value,
                        color: _colors[index % _colors.length],
                        radius: isTouched ? 90 : 75,
                        title: '${percentage.toStringAsFixed(1)}%',
                        titleStyle: TextStyle(
                          fontFamily: 'Kameron',
                          fontSize: isTouched ? 14 : 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Llegenda
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(beersByType.length, (index) {
                final item = beersByType[index];
                final name = item['name'] as String;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _colors[index % _colors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      name.substring(0, 1).toUpperCase() + name.substring(1),
                      style: const TextStyle(
                        fontFamily: 'Kameron',
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
