import 'package:flutter/material.dart';
import 'package:prone/feature/auth/presentation/screens/login_screen.dart';
import 'package:prone/feature/auth/presentation/screens/register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isShowLoginScreen = true;
  void toggleScreens() {
    setState(() {
      isShowLoginScreen = !isShowLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isShowLoginScreen
        ? LoginScreen(onRegister: toggleScreens)
        : RegisterScreen(onLogin: toggleScreens);
  }
}
