import 'package:flutter/material.dart';
import 'package:imani/core/constants/app_colors.dart';
import 'package:imani/features/home/presentation/home_screen.dart';
import 'package:imani/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
    _navigateToHome();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // أنيميشن اللوجو: تظهر مع تكبير ودوران بسيط
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
    _rotateIcon = Tween<double>(begin: -0.2, end: 0.0).animate( // دوران بسيط هادئ
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // أنيميشن العنوان
    _fadeInTitle = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    // أنيميشن الآية
    _fadeInAyah = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
            const HomeScreen(), // بدون onLocaleChange
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, Color(0xFF143F24)], // تدرج إسلامي عميق
              ),
            ),
            child: Stack(
              children: [
                ..._buildBackgroundCircles(),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // اللوجو الجديد مع التأثيرات
                      Opacity(
                        opacity: _fadeInIcon.value,
                        child: Transform.scale(
                          scale: _scaleIcon.value,
                          child: Transform.rotate(
                            angle: _rotateIcon.value * 3.14,
                            child: Container(
                              width: 180, // حجم مناسب للوجو
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.2),
                                    blurRadius: 40,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                               child: Image.asset(
  'assets/images/Splash.png',
  width: 100,   // عشان تصغر العرض
  height: 100,  // عشان تصغر الطول
  fit: BoxFit.cover,
),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // اسم التطبيق
                      Opacity(
                        opacity: _fadeInTitle.value,
                        child: Text(
                          t.appName,
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2.0,
                            shadows: [
                              Shadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // الآية الكريمة
                      Opacity(
                        opacity: _fadeInAyah.value,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'إِنَّمَا الْمُؤْمِنُونَ إِخْوَةٌ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Scheherazade',
                              fontSize: 26,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
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

  List<Widget> _buildBackgroundCircles() {
    return List.generate(5, (index) {
      final size = 100.0 + (index * 60);
      final opacity = 0.08 - (index * 0.01);
      return Positioned(
        left: (index * 50) % 300,
        top: (index * 100) % 600,
        child: Opacity(
          opacity: opacity * _controller.value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
      );
    });
  }
}