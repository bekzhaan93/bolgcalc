import '../models/enums.dart';
import '../models/work_type.dart';

class Catalog {
  static const types = <WorkType>[
    // Бетон/земляные/отделка (сокращённый каталог для примера)
    WorkType(id: 'beton_slab', name: 'Бетон — плита (м³)', unit: Unit.m3,
      fields: [Field.length, Field.width, Field.thickness, Field.count]),
    WorkType(id: 'plaster_wall', name: 'Штукатурка стен (м²)', unit: Unit.m2,
      fields: [Field.length, Field.height, Field.openings, Field.count]),
    WorkType(id: 'tile_floor', name: 'Плитка — пол (м²)', unit: Unit.m2,
      fields: [Field.length, Field.width, Field.count]),

    // Монтаж/демонтаж окон/дверей
    WorkType(id: 'door_install', name: 'Монтаж двери (шт)', unit: Unit.pcs,
      fields: [Field.count]),
    WorkType(id: 'door_dismantle', name: 'Демонтаж двери (шт)', unit: Unit.pcs,
      fields: [Field.count]),

    // Инженерка и покрытия
    WorkType(id: 'plumb_point_install', name: 'Сантехническая точка — монтаж (шт)', unit: Unit.pcs,
      fields: [Field.count]),
    WorkType(id: 'elec_point_install', name: 'Электроточка — монтаж (шт)', unit: Unit.pcs,
      fields: [Field.count]),
    WorkType(id: 'floor_laminate', name: 'Покрытие пола — ламинат (м²)', unit: Unit.m2,
      fields: [Field.length, Field.width, Field.count]),

    // Ручная позиция
    WorkType(id: 'custom', name: 'Произвольная позиция', unit: Unit.m2,
      fields: [Field.manualQty, Field.manualUnit, Field.count]),
  ];
}
