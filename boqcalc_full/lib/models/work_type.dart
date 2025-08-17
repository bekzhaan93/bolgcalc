import 'enums.dart';

class WorkType {
  final String id;
  final String name;
  final Unit unit;
  final List<Field> fields;

  const WorkType({required this.id, required this.name, required this.unit, required this.fields});
}
