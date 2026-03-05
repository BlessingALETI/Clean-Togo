import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../utils/theme.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade, _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fade = Tween<double>(begin: 0, end: 1).animate(_ctrl);
    _scale = Tween<double>(begin: 0.8, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 2), _navigate);
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    final isAuth = await context.read<AuthProvider>().checkAuth();
    if (!mounted) return;
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => isAuth ? const MainScreen() : const LoginScreen()));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenSplash,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: const Icon(Icons.eco_rounded, color: AppColors.primary, size: 60),
              ),
              const SizedBox(height: 24),
              RichText(text: const TextSpan(children: [
                TextSpan(text: 'Clean ', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
                TextSpan(text: 'Togo', style: TextStyle(color: Color(0xFF1B5E20), fontSize: 36, fontWeight: FontWeight.w900)),
              ])),
              const SizedBox(height: 8),
              const Text('Pour un pays plus propre et connecté',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 60),
              const SizedBox(width: 28, height: 28,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 2.5)),
            ]),
          ),
        ),
      ),
    );
  }
}
