import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/boq_provider.dart';
import '../utils/formulas.dart';
import '../utils/csv_saver.dart';

class SummaryScreen extends StatelessWidget {
  static const route = '/summary';
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<BoqProvider>();
    final grand = prov.grandTotal;
    return Scaffold(
      appBar: AppBar(title: const Text('Итоги и экспорт')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(leading: const Icon(Icons.calculate), title: const Text('Общий итог'), trailing: Text(grand.toStringAsFixed(2))),
            const SizedBox(height: 12),
            FilledButton.icon(
              icon: const Icon(Icons.file_download),
              label: const Text('Экспорт CSV'),
              onPressed: () async {
                final path = await _exportCsv(context);
                if (path == null) return;
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Экспорт выполнен')));
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.delete_sweep),
              label: const Text('Очистить все позиции'),
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Очистить ведомость?'),
                    content: const Text('Это удалит все сохранённые позиции.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
                      FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Очистить')),
                    ],
                  ),
                ) ?? false;
                if (ok) {
                  await prov.clear();
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Данные удалены')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _exportCsv(BuildContext context) async {
    final prov = context.read<BoqProvider>();
    try {
      final df = DateFormat('dd.MM.yyyy HH:mm');
      final rows = <List<String>>[];
      rows.add(['Дата/время','Объект','Вид работ','Ед.','Кол-во','Цена','Сумма','L','B','H','T','D','Проёмы','Шт','Примечание']);
      for (final it in prov.rows) {
        final qty = Formulas.qty(it);
        final sum = Formulas.lineTotal(it);
        final unit = Formulas.unitLabel(it.unit, it.manualUnitText);
        rows.add([
          df.format(it.createdAt),
          it.objectName,
          it.workTypeName,
          unit,
          qty.toStringAsFixed(3),
          it.unitPrice.toStringAsFixed(2),
          sum.toStringAsFixed(2),
          it.length.toStringAsFixed(3),
          it.width.toStringAsFixed(3),
          it.height.toStringAsFixed(3),
          it.thickness.toStringAsFixed(3),
          it.diameter.toStringAsFixed(3),
          it.openings.toStringAsFixed(2),
          it.count.toString(),
          it.note,
        ]);
      }
      rows.add([]);
      rows.add(['ИТОГО','','','', '', '', prov.grandTotal.toStringAsFixed(2), '', '', '', '', '', '', '', '']);
      final csv = rows.map((r) => r.map(_esc).join(';')).join('\n');
      final saved = await saveCsv(csv, filename: 'boqcalc_export.csv');
      return saved;
    } catch (_) { return null; }
  }

  String _esc(String s) {
    if (s.contains(';') || s.contains('"')) { return '"${s.replaceAll('"', '""')}"'; }
    return s;
  }
}
