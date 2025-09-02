import 'package:sqflite/sqflite.dart';
import '../models/event.dart';
import 'database.dart';

class EventDao {
  final dbProvider = DatabaseProvider.instance;

  Future<int> createEvent(Event event) async {
    final db = await dbProvider.database;

    return await db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Event>> getAllEvents() async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query('events');

    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
  }

  Future<int> updateEvent(Event event) async {
    final db = await dbProvider.database;
    return await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> deleteEvent(int id) async {
    final db = await dbProvider.database;
    return await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }
}
