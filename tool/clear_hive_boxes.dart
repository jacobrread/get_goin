import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> main() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  var goals = await Hive.openBox('goals');
  await goals.clear();
  var monetary = await Hive.openBox('monetary');
  await monetary.clear();
  print('Cleared goals and monetary boxes.');
}
