import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'db.dart';
import 'package:Yonder/setting.dart';

class SettingsModel {
  Future<void> initializeSettings(String username) async {
    Map<String, dynamic> newSettings = {
      'id': 0,
      'login': 1,
      'notification': 1,
      'filter': 0,
      'lang': 0,
      'username': username,
      'darkMode': 0
    };
    final db = await DataStore.init();
    return await db.insert(
      'settings_table',
      newSettings,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateSettings(Settings settings) async {
    final db = await DataStore.init();
    await db.update(
      'settings_table',
      settings.toMap(),
      where: 'id = ?',
      whereArgs: [0],
    );
  }

  Future<Settings> getSettings() async {
    final db = await DataStore.init();
    final List<Map<String, dynamic>> maps = await db.query(
      'settings_table',
      where: 'id = ?',
      whereArgs: [0],
    );
    return Settings.fromMap(maps[0]);
  }

  Future<bool> isEmptyNull() async {
    final db = await DataStore.init();
    final List<Map<String, dynamic>> maps = await db.query(
      'settings_table',
      where: 'id = ?',
      whereArgs: [0],
    );
    return maps.isEmpty;
  }

}
