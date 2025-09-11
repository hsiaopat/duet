import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'screens/tutorial_screen.dart';
import 'screens/camera_screen.dart';
import 'stores/result_store.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ResultStore()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      initialLocation: '/tutorial',
      routes: [
        // Tutorial flow
        GoRoute(
          path: '/tutorial',
          builder: (context, state) => const TutorialScreen(),
        ),

        // Home + nested routes
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
          routes: [
            // CameraScreen as a nested route of home
            GoRoute(
              path: 'camera',
              builder: (context, state) => const CameraScreen(),
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      title: 'DUET-HF',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
