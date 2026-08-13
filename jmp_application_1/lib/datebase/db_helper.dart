import 'package:sqflite/sqflite.dart'; // El motor de base de datos
import 'package:path/path.dart';
import 'dart:async';

class RanchosRepository {
  RanchosRepository._internal() {
    _init();
  }
  static final RanchosRepository instance = RanchosRepository._internal();

  final _controller = StreamController<List<Map<String, dynamic>>>.broadcast();
  final List<Map<String, dynamic>> _items = [];

  Stream<List<Map<String, dynamic>>> get stream => _controller.stream;

  Future<void> _init() async => await _emitAll();

  Future<void> _emitAll() async {
    try {
      final rows = await DBHelper().getAllRanchos(); // usa tu DBHelper
      _items
        ..clear()
        ..addAll(rows);
      _controller.add(List.unmodifiable(_items));
    } catch (e) {
      _controller.addError(e);
    }
  }

  Future<void> addRancho(Map<String, dynamic> rancho) async {
    await DBHelper().insertRancho(rancho);
    await _emitAll();
  }

  Future<void> removeById(int id) async {
    await DBHelper().deleteRancho(id);
    await _emitAll();
  }

  Future<void> refresh() => _emitAll();

  void dispose() => _controller.close();
}

// Para encontrar la ruta en el celular
class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Future<List<Map<String, dynamic>>> getGanado() async {
    Database db = await database;
    return await db.query('ganado');
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'jmp_ganadera.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB, // Aquí llamamos a la función que crea las tablas
    );
  }

  Future _createDB(Database db, int version) async {
    // Tabla GANADO
    await db.execute('''
      CREATE TABLE ganado (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        arete TEXT,
        raza TEXT,
        fecha_nacimiento TEXT,
        peso_actual REAL,
        estado TEXT
      )
    ''');

    // Tabla ALIMENTOS
    await db.execute('''
      CREATE TABLE alimentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        cantidad REAL,
        costo_kilo REAL
      )
    ''');

    // Tabla TRASLADOS (Logística)
    await db.execute('''
      CREATE TABLE traslados (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        arete_animal TEXT,
        origen TEXT,
        destino TEXT,
        chofer TEXT,
        fecha TEXT
      )
    ''');

    // Tabla VENTAS
    await db.execute('''
      CREATE TABLE ventas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        arete_animal TEXT,
        peso_final REAL,
        precio_total REAL,
        comprador TEXT,
        fecha TEXT
      )
    ''');

    // Tabla RANCHOS
    await db.execute('''
      CREATE TABLE ranchos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        ubicacion TEXT,
        hectareas INTEGER
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getAllRanchos() async {
    final db = await database;
    return await db.query('ranchos', orderBy: 'id DESC');
  }

  Future<int> insertRancho(Map<String, dynamic> rancho) async {
    final db = await database;
    return await db.insert('ranchos', rancho);
  }

  Future<int> deleteRancho(int id) async {
    final db = await database;
    return await db.delete('ranchos', where: 'id = ?', whereArgs: [id]);
  }
}
