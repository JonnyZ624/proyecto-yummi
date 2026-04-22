import 'package:flutter/material.dart';
import 'package:frontend/screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
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
      home: logged
          ? const MainScreen()
          : const LoginScreen(),
    );
  }
}