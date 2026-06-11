import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Image de fond ──────────────────────────
          Image.asset(
            'assets/images/peche.jpg',
            fit: BoxFit.cover,
          ),

          // ── Overlay gradient ───────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.3),
                  AppColors.primary.withValues(alpha: 0.85),
                ],
              ),
            ),
          ),

          // ── Contenu ────────────────────────────────
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.directions_boat,
                        size: 56,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Titre
                    const Text(
                      'Gestion Peche',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Text(
                      'Artisanale',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Separateur
                    Container(
                      width: 60,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Sous-titre
                    const Text(
                      'ODD 14 - Vie Aquatique',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 80),

                    // Loading
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        color: Colors.white60,
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Nom etudiant en bas ────────────────────
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: const Column(
                children: [
                  Text(
                    'Mouhamed Rassoul NIANG',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ESMT - Dakar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}