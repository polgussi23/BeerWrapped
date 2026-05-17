// screens/wrapped/wrapped_screen.dart
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/services/user_service.dart';
import 'package:birrawrapped/screens/wrapped/slides/slide_intro.dart';
import 'package:birrawrapped/screens/wrapped/slides/slide_total_beers.dart';
import 'package:birrawrapped/screens/wrapped/slides/slide_fav_beer.dart';
import 'package:birrawrapped/screens/wrapped/slides/slide_best_day.dart';
import 'package:birrawrapped/screens/wrapped/slides/slide_best_month.dart';
import 'package:birrawrapped/screens/wrapped/slides/slide_avg_time.dart';
import 'package:birrawrapped/screens/wrapped/slides/slide_streak.dart';
import 'package:birrawrapped/screens/wrapped/slides/slide_chart_months.dart';
import 'package:birrawrapped/screens/wrapped/slides/slide_chart_types.dart';
import 'package:birrawrapped/screens/wrapped/slides/slide_chart_moments.dart';
import 'package:birrawrapped/screens/wrapped/slides/slide_best_group.dart';
import 'package:birrawrapped/screens/wrapped/slides/slide_final.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WrappedScreen extends StatefulWidget {
  const WrappedScreen({Key? key}) : super(key: key);

  @override
  _WrappedScreenState createState() => _WrappedScreenState();
}

class _WrappedScreenState extends State<WrappedScreen>
    with TickerProviderStateMixin {
  int _currentSlide = 0;
  Map<String, dynamic>? _wrappedData;
  bool _isLoading = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _loadData();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final userId = context.read<UserProvider>().getUserId();

    final data = await UserService().getWrappedData(userId.toString());

    // Guardem que ha vist el wrapped quan el carrega per primera vegada
    final prefs = await SharedPreferences.getInstance();
    final wrappedSeenDate = prefs.getString('wrappedSeenDate');
    if (wrappedSeenDate == null) {
      await prefs.setString(
          'wrappedSeenDate', DateTime.now().toIso8601String());
    }

    setState(() {
      _wrappedData = data;
      _isLoading = false;
    });
    _animController.forward();
  }

  void _nextSlide() {
    if (_currentSlide < _slides.length - 1) {
      _animController.reverse().then((_) {
        setState(() => _currentSlide++);
        _animController.forward();
      });
    }
  }

  void _prevSlide() {
    if (_currentSlide > 0) {
      _animController.reverse().then((_) {
        setState(() => _currentSlide--);
        _animController.forward();
      });
    }
  }

  List<Widget> get _slides => [
        SlideIntro(onStart: _nextSlide),
        SlideTotalBeers(data: _wrappedData!),
        SlideFavBeer(data: _wrappedData!),
        SlideBestDay(data: _wrappedData!),
        SlideBestMonth(data: _wrappedData!),
        SlideAvgTime(data: _wrappedData!),
        SlideStreak(data: _wrappedData!),
        SlideChartMonths(data: _wrappedData!),
        SlideChartTypes(data: _wrappedData!),
        SlideChartMoments(data: _wrappedData!),
        SlideBestGroup(data: _wrappedData!),
        SlideFinal(data: _wrappedData!),
      ];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFFB5884C)),
              SizedBox(height: 16),
              Text(
                'Preparant el teu wrapped... 🍺',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Kameron',
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx > screenWidth / 2) {
            _nextSlide();
          } else {
            _prevSlide();
          }
        },
        child: Stack(
          children: [
            // Slide actual amb fade
            FadeTransition(
              opacity: _fadeAnim,
              child: _slides[_currentSlide],
            ),
            // Indicador de progrés a dalt
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              child: Row(
                children: List.generate(
                  _slides.length,
                  (index) => Expanded(
                    child: Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index <= _currentSlide
                            ? Colors.white
                            : Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
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
