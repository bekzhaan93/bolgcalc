import 'dart:convert';
import 'enums.dart';

class BoqItem {
  final String id;
  final DateTime createdAt;
  final String objectName;
  final String workTypeId;
  final String workTypeName;
  final Unit unit;

  final double length;
  final double width;
  final double height;
  final double thickness;
  final double diameter;
  final double openings;
  final int count;
  final double manualQty;
  final String manualUnitText;
  final double unitPrice;
  final String note;

  BoqItem({
    required this.id,
    required this.createdAt,
    required this.objectName,
    required this.workTypeId,
    required this.workTypeName,
    required this.unit,
    required this.length,
    required this.width,
    required this.height,
    required this.thickness,
    required this.diameter,
    required this.openings,
    required this.count,
    required this.manualQty,
    required this.manualUnitText,
    required this.unitPrice,
    required this.note,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'objectName': objectName,
    'workTypeId': workTypeId,
    'workTypeName': workTypeName,
    'unit': unit.index,
    'length': length,
    'width': width,
    'height': height,
    'thickness': thickness,
    'diameter': diameter,
    'openings': openings,
    'count': count,
    'manualQty': manualQty,
    'manualUnitText': manualUnitText,
    'unitPrice': unitPrice,
    'note': note,
  };

  factory BoqItem.fromMap(Map<String, dynamic> map) => BoqItem(
    id: map['id'] as String,
    createdAt: DateTime.parse(map['createdAt'] as String),
    objectName: map['objectName'] as String? ?? '',
    workTypeId: map['workTypeId'] as String,
    workTypeName: map['workTypeName'] as String,
    unit: Unit.values[(map['unit'] as num).toInt()],
    length: (map['length'] as num?)?.toDouble() ?? 0,
    width: (map['width'] as num?)?.toDouble() ?? 0,
    height: (map['height'] as num?)?.toDouble() ?? 0,
    thickness: (map['thickness'] as num?)?.toDouble() ?? 0,
    diameter: (map['diameter'] as num?)?.toDouble() ?? 0,
    openings: (map['openings'] as num?)?.toDouble() ?? 0,
    count: (map['count'] as num?)?.toInt() ?? 1,
    manualQty: (map['manualQty'] as num?)?.toDouble() ?? 0,
    manualUnitText: map['manualUnitText'] as String? ?? '',
    unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0,
    note: map['note'] as String? ?? '',
  );

  String toJson() => json.encode(toMap());
  factory BoqItem.fromJson(String source) => BoqItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
