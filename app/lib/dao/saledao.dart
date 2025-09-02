import 'package:sqflite/sqflite.dart';
import '../models/sale.dart';
import 'database.dart';

class SaleDao {
  final dbProvider = DatabaseProvider.instance;

  Future<int> createSale(Sale sale) async {
    final db = await dbProvider.database;
    return await db.insert(
      'sales',
      sale.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
