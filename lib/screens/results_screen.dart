import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder values — later, these can come from your CV model or backend
    final double chloride = 85.0;    // mmol/L
    final double creatinine = 1.2;   // g/L
    final double ratio = chloride / creatinine;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Results"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Latest Analysis",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Results card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildResultRow("Urine Chloride", "$chloride mmol/L"),
                      const Divider(),
                      _buildResultRow("Urine Creatinine", "$creatinine g/L"),
                      const Divider(),
                      _buildResultRow("Cl-/Cr Ratio", ratio.toStringAsFixed(2)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Interpretation
              Text(
                ratio > 80
                    ? "⚠️ Elevated ratio — may need diuretic adjustment."
                    : "✅ Ratio in safe range.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: ratio > 80 ? Colors.red : Colors.green,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Button to go back home
              ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Back to Home", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
