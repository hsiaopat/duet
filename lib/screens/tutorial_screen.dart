import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _tutorialTexts = [
    "Welcome to DUET-HF!\n\nThis app helps monitor your urine electrolytes at home.",
    "Step 1: Collect a urine sample and dip the dual-analyte strip.",
    "Step 2: Place the strip on the guide card and use your phone camera to capture it.",
    "Step 3: Get instant feedback on your chloride/creatinine ratio and alerts."
  ];

  void _nextPage() {
    if (_currentPage < _tutorialTexts.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Finished tutorial → go to home
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _tutorialTexts.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        _tutorialTexts[index],
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _tutorialTexts.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                  width: _currentPage == index ? 12 : 8,
                  height: _currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            // Next / Finish button
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentPage == _tutorialTexts.length - 1 ? "Finish Tutorial" : "Next",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
