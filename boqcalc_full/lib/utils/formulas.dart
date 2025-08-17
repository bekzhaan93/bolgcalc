import 'dart:math' as m;
import '../models/boq_item.dart';
import '../models/enums.dart';

class Formulas {
  static String unitLabel(Unit u, String manual) {
    switch (u) {
      case Unit.m3: return 'м³';
      case Unit.m2: return 'м²';
      case Unit.m: return 'м';
      case Unit.pcs: return 'шт';
    }
  }

  static double qty(BoqItem it) {
    switch (it.workTypeId) {
      case 'beton_slab':
        return _nn(it.length * it.width * it.thickness) * it.count;
      case 'plaster_wall':
        return _nn((it.length * it.height - it.openings)) * it.count;
      case 'tile_floor':
      case 'floor_laminate':
        return _nn(it.length * it.width) * it.count;
      case 'door_install':
      case 'door_dismantle':
      case 'plumb_point_install':
      case 'elec_point_install':
        return _nn(it.count.toDouble());
      case 'custom':
        return _nn(it.manualQty) * it.count;
      default:
        return 0;
    }
  }

  static double lineTotal(BoqItem it) => qty(it) * it.unitPrice;

  static double _nn(double v) => v.isNaN ? 0 : (v < 0 ? 0 : v);
}
