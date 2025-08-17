// lib/utils/csv_saver_io.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<String?> saveCsv(String csv, {String filename = 'export.csv'}) async {
  try {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsString(csv);
    await Share.shareXFiles([XFile(file.path)], text: 'BoQCalc — экспорт');
    return file.path;
  } catch (_) { return null; }
}
