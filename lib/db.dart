import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sockapp/clothing_item.dart';

class ClothingItemDatabase {
  static final ClothingItemDatabase instance = ClothingItemDatabase._internal();

  static Database? _database;

  ClothingItemDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'items.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, _) async {
    return await db.execute('''
        CREATE TABLE ${ClothesField.tableName} (
          ${ClothesField.id} ${ClothesField.idType},
          ${ClothesField.clothingType} ${ClothesField.textType},
          ${ClothesField.owner} ${ClothesField.textType},
          ${ClothesField.color} ${ClothesField.textType},
          ${ClothesField.description} ${ClothesField.textType}
        )
      ''');
  }

  Future<ClothesModel> create(ClothesModel item) async {
    final db = await instance.database;
    final id = await db.insert(ClothesField.tableName, item.toJson());
    return item.copy(id: id);
  }

  Future<ClothesModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      ClothesField.tableName,
      columns: ClothesField.values,
      where: '${ClothesField.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ClothesModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<ClothesModel>> readAll() async {
    final db = await instance.database;
    const orderBy = '${ClothesField.id} DESC';
    final result = await db.query(ClothesField.tableName, orderBy: orderBy);
    return result.map((json) => ClothesModel.fromJson(json)).toList();
  }

  Future<int> update(ClothesModel item) async {
    final db = await instance.database;
    return db.update(
      ClothesField.tableName,
      item.toJson(),
      where: '${ClothesField.id} = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      ClothesField.tableName,
      where: '${ClothesField.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
