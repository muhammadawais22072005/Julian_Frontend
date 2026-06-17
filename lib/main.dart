import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:julian_medical_center/presentation/theme/app_theme.dart';
import 'package:julian_medical_center/presentation/screens/landing_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: JulianMedicalApp(),
    ),
  );
}

class JulianMedicalApp extends StatelessWidget {
  const JulianMedicalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Julian Medical Center',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LandingScreen(),
    );
  }