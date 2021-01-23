import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DataStore {
  static Future<Database> init() async {
    return openDatabase(
      path.join(await getDatabasesPath(), 'settingDB.db'),
      onCreate: (db, version) {
        if (version > 1) {}
        db.execute(
            'CREATE TABLE settings_table(id INTEGER PRIMARY KEY, login INTEGER, notification INTEGER, filter INTEGER, username TEXT, lang INTEGER, darkMode INTEGER)');
      },
      version: 1,
    );
  }
}
