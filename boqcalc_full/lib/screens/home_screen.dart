import 'package:flutter/material.dart';
import 'new_row_screen.dart';
import 'rows_screen.dart';
import 'summary_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BoQCalc — ведомость работ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Вводите размеры/количество, цену за единицу и получайте итог.'),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Новая позиция'),
              onPressed: () => Navigator.pushNamed(context, NewRowScreen.route),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.list),
              label: const Text('Список позиций'),
              onPressed: () => Navigator.pushNamed(context, RowsScreen.route),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.summarize),
              label: const Text('Итоги и экспорт'),
              onPressed: () => Navigator.pushNamed(context, SummaryScreen.route),
            ),
          ],
        ),
      ),
    );
  }
}
