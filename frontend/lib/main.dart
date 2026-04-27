import 'package:flutter/material.dart';
import 'package:frontend/screens/main_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/bienvenida_screen.dart';
import 'services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool logged = await UserService.cargarSesion();

  runApp(MyApp(logged: logged));
}

class MyApp extends StatelessWidget {
  final bool logged;

  const MyApp({super.key, required this.logged});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingWrapper(logged: logged),
    );
  }
}

// 🔥 CONTROL TOTAL AQUÍ
class OnboardingWrapper extends StatefulWidget {
  final bool logged;

  const OnboardingWrapper({super.key, required this.logged});

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {

  bool mostrarOnboarding = true;

  void terminarOnboarding() {
    setState(() {
      mostrarOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (mostrarOnboarding) {
      return OnboardingScreen(
        onFinish: terminarOnboarding, // 🔥 AQUÍ SE SOLUCIONA TU ERROR
      );
    }

    return widget.logged
        ? const MainScreen()
        : const BienvenidaScreen();
  }
}