import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/boq_item.dart';
import '../models/enums.dart';
import '../providers/boq_provider.dart';
import '../utils/catalog.dart';
import '../utils/formulas.dart';

class NewRowScreen extends StatefulWidget {
  static const route = '/new';
  const NewRowScreen({super.key});

  @override
  State<NewRowScreen> createState() => _NewRowScreenState();
}

class _NewRowScreenState extends State<NewRowScreen> {
  final _formKey = GlobalKey<FormState>();
  String _typeId = Catalog.types.first.id;
  Unit _unit = Catalog.types.first.unit;

  final _objectCtrl = TextEditingController();
  final _lengthCtrl = TextEditingController();
  final _widthCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _thicknessCtrl = TextEditingController(text: '0.12');
  final _diameterCtrl = TextEditingController();
  final _openingsCtrl = TextEditingController(text: '0');
  final _countCtrl = TextEditingController(text: '1');
  final _manualQtyCtrl = TextEditingController();
  final _manualUnitCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  double _parse(TextEditingController c) => double.tryParse(c.text.replaceAll(',', '.')) ?? 0.0;
  int _parseInt(TextEditingController c) => int.tryParse(c.text) ?? 1;

  @override
  void dispose() {
    for (final c in [
      _objectCtrl,_lengthCtrl,_widthCtrl,_heightCtrl,_thicknessCtrl,_diameterCtrl,
      _openingsCtrl,_countCtrl,_manualQtyCtrl,_manualUnitCtrl,_priceCtrl,_noteCtrl
    ]) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Catalog.types.firstWhere((e) => e.id == _typeId);
    _unit = t.unit;
    final fields = t.fields;

    String unitLabel = Formulas.unitLabel(_unit, _manualUnitCtrl.text);
    final previewItem = BoqItem(
      id: 'x',
      createdAt: DateTime.now(),
      objectName: _objectCtrl.text.trim(),
      workTypeId: _typeId,
      workTypeName: t.name,
      unit: _unit,
      length: _parse(_lengthCtrl),
      width: _parse(_widthCtrl),
      height: _parse(_heightCtrl),
      thickness: _parse(_thicknessCtrl),
      diameter: _parse(_diameterCtrl),
      openings: _parse(_openingsCtrl),
      count: _parseInt(_countCtrl),
      manualQty: _parse(_manualQtyCtrl),
      manualUnitText: _manualUnitCtrl.text.trim(),
      unitPrice: _parse(_priceCtrl),
      note: _noteCtrl.text.trim(),
    );

    final qty = Formulas.qty(previewItem);
    final sum = Formulas.lineTotal(previewItem);

    return Scaffold(
      appBar: AppBar(title: const Text('Новая позиция')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _objectCtrl, decoration: const InputDecoration(labelText: 'Объект/участок')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Вид работ'),
              value: _typeId,
              items: Catalog.types.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
              onChanged: (v) => setState(() => _typeId = v ?? Catalog.types.first.id),
            ),
            const SizedBox(height: 12),
            Wrap(runSpacing: 12, spacing: 12, children: [
              if (fields.contains(Field.length)) SizedBox(width: 180, child: _field('Длина L', _lengthCtrl, 'м')),
              if (fields.contains(Field.width)) SizedBox(width: 180, child: _field('Ширина B', _widthCtrl, 'м')),
              if (fields.contains(Field.height)) SizedBox(width: 180, child: _field('Высота H', _heightCtrl, 'м')),
              if (fields.contains(Field.thickness)) SizedBox(width: 180, child: _field('Толщина T', _thicknessCtrl, 'м')),
              if (fields.contains(Field.diameter)) SizedBox(width: 180, child: _field('Диаметр D', _diameterCtrl, 'м')),
              if (fields.contains(Field.openings)) SizedBox(width: 180, child: _field('Проёмы', _openingsCtrl, 'м²')),
              SizedBox(width: 180, child: _int('Кол-во одинаковых', _countCtrl)),
              if (fields.contains(Field.manualQty)) SizedBox(width: 180, child: _field('Кол-во', _manualQtyCtrl, 'ед.')),
              if (fields.contains(Field.manualUnit)) SizedBox(width: 180, child: TextFormField(controller: _manualUnitCtrl, decoration: const InputDecoration(labelText: 'Ед. изм. (текст)'))),
            ]),
            const SizedBox(height: 12),
            TextFormField(controller: _priceCtrl, decoration: InputDecoration(labelText: 'Цена за 1 $unitLabel'), keyboardType: const TextInputType.numberWithOptions(decimal: true)),
            const SizedBox(height: 12),
            TextFormField(controller: _noteCtrl, decoration: const InputDecoration(labelText: 'Примечание'), maxLines: 2),
            const SizedBox(height: 16),
            Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Предпросмотр', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text('Кол-во: ${qty.toStringAsFixed(3)} $unitLabel'),
              Text('Сумма: ${sum.toStringAsFixed(2)}'),
            ]))),
            const SizedBox(height: 16),
            FilledButton.icon(icon: const Icon(Icons.save), label: const Text('Сохранить'), onPressed: () async {
              final item = BoqItem(
                id: const Uuid().v4(),
                createdAt: DateTime.now(),
                objectName: _objectCtrl.text.trim(),
                workTypeId: t.id,
                workTypeName: t.name,
                unit: _unit,
                length: _parse(_lengthCtrl),
                width: _parse(_widthCtrl),
                height: _parse(_heightCtrl),
                thickness: _parse(_thicknessCtrl),
                diameter: _parse(_diameterCtrl),
                openings: _parse(_openingsCtrl),
                count: _parseInt(_countCtrl),
                manualQty: _parse(_manualQtyCtrl),
                manualUnitText: _manualUnitCtrl.text.trim(),
                unitPrice: _parse(_priceCtrl),
                note: _noteCtrl.text.trim(),
              );
              await context.read<BoqProvider>().add(item);
              if (!mounted) return;
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  TextFormField _field(String label, TextEditingController c, String suffix) =>
      TextFormField(controller: c, decoration: InputDecoration(labelText: label, suffixText: suffix), keyboardType: const TextInputType.numberWithOptions(decimal: true));
  TextFormField _int(String label, TextEditingController c) =>
      TextFormField(controller: c, decoration: InputDecoration(labelText: label), keyboardType: TextInputType.number);
}
