import 'package:flutter/material.dart';
import 'package:imani/core/constants/app_colors.dart';
import 'package:imani/features/home/presentation/home_screen.dart';

class SplashScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  const SplashScreen({super.key, required this.onLocaleChange});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInIcon;
  late Animation<double> _rotateIcon;
  late Animation<double> _scaleIcon;
  late Animation<double> _fadeInTitle;
  late Animation<double> _fadeInAyah;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // أنيميشن الأيقونة: تظهر مع تكبير ودوران
    _fadeInIcon = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _scaleIcon = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    _rotateIcon = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // أنيميشن العنوان: يظهر بعد الأيقونة بقليل
    _fadeInTitle = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    // أنيميشن الآية: يظهر متأخراً
    _fadeInAyah = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // الانتقال إلى الصفحة الرئيسية بعد 4 ثوانٍ
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            onLocaleChange: widget.onLocaleChange,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, AppColors.secondary],
              ),
            ),
            child: Stack(
              children: [
                // دوائر متحركة في الخلف
                ..._buildBackgroundCircles(),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // الأيقونة مع التأثيرات
                      Opacity(
                        opacity: _fadeInIcon.value,
                        child: Transform.scale(
                          scale: _scaleIcon.value,
                          child: Transform.rotate(
                            angle: _rotateIcon.value * 3.14, // نصف دورة كحد أقصى
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.nights_stay, // أيقونة هلال
                                size: 100,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // اسم التطبيق
                      Opacity(
                        opacity: _fadeInTitle.value,
                        child: const Text(
                          'إيماني',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2.0,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // الآية
                      Opacity(
                        opacity: _fadeInAyah.value,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'إِنَّمَا الْمُؤْمِنُونَ إِخْوَةٌ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Scheherazade',
                              fontSize: 28,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Opacity(
                        opacity: _fadeInAyah.value,
                        child: const Text(
                          'الحجرات: ١٠',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // دوائر خلفية متحركة
  List<Widget> _buildBackgroundCircles() {
    return List.generate(5, (index) {
      final delay = index * 0.2;
      final size = 100.0 + (index * 50);
      final opacity = 0.1 - (index * 0.02);
      return Positioned(
        left: (index * 30) % MediaQuery.of(context).size.width,
        top: (index * 40) % MediaQuery.of(context).size.height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: opacity * (0.5 + 0.5 * _controller.value),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}