import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _current = 0;

  final List<Widget> pages = [
    _buildText("Welcome to DUET-HF", "This app helps monitor urine chloride/creatinine ratios at home."),
    _buildText("Step 1", "Dip the dual-analyte strip and place it on the calibration card."),
    _buildText("Step 2", "Open Camera → align the card in the overlay → capture the image."),
    _buildText("Step 3", "The app will analyze and show Cl⁻/Cr ratio and guidance."),
  ];

  static Widget _buildText(String title, String body) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(body, style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
        ]),
      );

  void _next() {
    if (_current < pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutorial')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(controller: _pageController, onPageChanged: (i) => setState(() => _current = i), children: pages),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(pages.length, (i) {
              return Container(
                margin: const EdgeInsets.all(6),
                width: _current == i ? 12 : 8,
                height: _current == i ? 12 : 8,
                decoration: BoxDecoration(color: _current == i ? Colors.blue : Colors.grey, shape: BoxShape.circle),
              );
            })),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: _next,
                child: Text(_current == pages.length - 1 ? 'Finish Tutorial' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
