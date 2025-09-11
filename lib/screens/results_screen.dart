import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../stores/result_store.dart';

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final results = Provider.of<ResultStore>(context).results;

    return Scaffold(
      appBar: AppBar(title: Text('Results')),
      body: results.isEmpty
          ? Center(child: Text('No results yet'))
          : ListView(
              padding: EdgeInsets.all(16),
              children: results.entries.map((entry) {
                return ListTile(
                  title: Text('${entry.key}: ${entry.value}'),
                );
              }).toList(),
            ),
    );
  }
}
