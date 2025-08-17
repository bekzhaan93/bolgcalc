import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/boq_provider.dart';
import '../utils/formulas.dart';

class RowsScreen extends StatelessWidget {
  static const route = '/rows';
  const RowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<BoqProvider>();
    final rows = prov.rows;
    return Scaffold(
      appBar: AppBar(title: const Text('Список позиций')),
      body: rows.isEmpty
          ? const Center(child: Text('Пока нет позиций'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemBuilder: (_, i) {
                final it = rows[i];
                final df = DateFormat('dd.MM.yyyy HH:mm');
                final qty = Formulas.qty(it);
                final sum = Formulas.lineTotal(it);
                final unit = Formulas.unitLabel(it.unit, it.manualUnitText);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(child: Text(it.workTypeName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                          Text(df.format(it.createdAt), style: const TextStyle(color: Colors.black54)),
                        ]),
                        if (it.objectName.isNotEmpty) Text(it.objectName),
                        const SizedBox(height: 6),
                        Text('Кол-во: ${qty.toStringAsFixed(3)} $unit × Цена: ${it.unitPrice.toStringAsFixed(2)} = ${sum.toStringAsFixed(2)}'),
                        if (it.note.isNotEmpty) ...[const SizedBox(height: 6), Text(it.note)],
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: rows.length,
            ),
    );
  }
}
