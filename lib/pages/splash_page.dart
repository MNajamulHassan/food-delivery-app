import 'package:flutter/material.dart';

import '../models/app_store.dart';
import '../routes.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';

/// Splash screen with a staggered animation driven by one AnimationController:
///   0.0 - 0.4  logo pops in (scale, elastic)
///   0.35 - 0.65 app name fades in
///   0.6 - 0.9  tagline slides up and fades in
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _taglineOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _logoScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.65, curve: Curves.easeIn),
      ),
    );

    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
      ),
    );

    _taglineOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.9, curve: Curves.easeIn),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goNext();
      }
    });

    _controller.forward();
  }

  /// After the animation: go to Home if already logged in, else to Login.
  Future<void> _goNext() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final loggedIn = await AuthService.isLoggedIn();
    if (loggedIn) {
      AppStore().setUser(await AuthService.currentUser());
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(
      loggedIn ? AppRoutes.home : AppRoutes.login,
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // always dispose controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: _logoScale.value,
                    child: Container(
                      width: 130,
                      height: 130,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Text('🛵', style: TextStyle(fontSize: 64)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Opacity(
                    opacity: _titleOpacity.value,
                    child: const Text(
                      'Foodie Express',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SlideTransition(
                    position: _taglineSlide,
                    child: Opacity(
                      opacity: _taglineOpacity.value,
                      child: const Text(
                        'Hot food, delivered fast',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
