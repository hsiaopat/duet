import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/tutorial_screen.dart';
import 'screens/home_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/results_screen.dart';

void main() {
  runApp(DuetHFApp());
}

class DuetHFApp extends StatelessWidget {
  DuetHFApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(
    initialLocation: '/tutorial',
    routes: [
      GoRoute(
        path: '/tutorial',
        builder: (context, state) => const TutorialScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/camera',
        builder: (context, state) => const CameraScreen(),
      ),
      GoRoute(
        path: '/results',
        builder: (context, state) => const ResultsScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DUET-HF',
      routerConfig: _router,
    );
  }
}
