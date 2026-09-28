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

  //Reinicio de BDD
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'jmp_ganadera_v8.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      final columns = await db.rawQuery("PRAGMA table_info(ranchos)");

      final existingColumns = columns
          .map((column) => column['name'] as String)
          .toList();

      if (!existingColumns.contains('propietario')) {
        await db.execute('ALTER TABLE ranchos ADD COLUMN propietario TEXT');
      }

      if (!existingColumns.contains('numero_animales')) {
        await db.execute(
          'ALTER TABLE ranchos ADD COLUMN numero_animales INTEGER',
        );
      }
    }

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS vacunas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          arete_animal TEXT,
          nombre_vacuna TEXT,
          fecha_aplicacion TEXT,
          es_caballo INTEGER DEFAULT 0
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS gestacion (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          arete_nombre TEXT,
          fecha_gestacion TEXT,
          fecha_nacimiento TEXT,
          estado TEXT
        )
      ''');
    }
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
        estado TEXT,
        rancho_id INTEGER,
        FOREIGN KEY (rancho_id) REFERENCES ranchos (id) ON DELETE CASCADE
      )
    ''');

    // Tabla ALIMENTOS
    await db.execute('''
      CREATE TABLE alimentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        cantidad REAL,
        costo_kilo REAL,
        rancho_id INTEGER,
        FOREIGN KEY (rancho_id) REFERENCES ranchos (id) ON DELETE CASCADE
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
        fecha TEXT,
        cantidad_animales INTEGER
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
        clave_upp TEXT,
        ubicacion TEXT,
        localidad TEX,
        hectareas INTEGER,
        propietario TEXT,
        numero_animales INTEGER
      )
    ''');
    //TABLA VACUNAS
    await db.execute('''
     CREATE TABLE vacunas(       
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        arete_animal TEXT,
        nombre_vacuna TEXT,
        fecha_aplicacion TEXT,
        es_caballo INTEGER DEFAULT 0
      )  
    ''');

    //TABLA GESTACIÓN
    await db.execute('''
      CREATE TABLE gestacion(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
        arete_nombre TEXT,
        fecha_gestacion TEXT,
        fecha_nacimiento TEXT,
        estado TEXT
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

  Future<int> updateRancho(int id, Map<String, dynamic> rancho) async {
    final db = await database;
    return await db.update('ranchos', rancho, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertGanado(Map<String, dynamic> animal) async {
    final db = await database;
    return await db.insert('ganado', animal);
  }

  Future<List<Map<String, dynamic>>> getGanadoPorRancho(int ranchoId) async {
    final db = await database;
    return await db.query(
      'ganado',
      where: 'rancho_id = ?',
      whereArgs: [ranchoId],
    );
  }

  // ================= CRUD VACUNAS =================
  Future<int> insertVacuna(Map<String, dynamic> vacuna) async {
    final db = await database;
    return await db.insert('vacunas', vacuna);
  }

  Future<List<Map<String, dynamic>>> getHistorialMedico(String arete) async {
    final db = await database;
    return await db.query(
      'vacunas',
      where: 'arete_animal = ?',
      whereArgs: [arete],
      orderBy: 'fecha_aplicacion DESC',
    );
  }

  // ================= CRUD GESTACIÓN =================
  Future<int> insertGestacion(Map<String, dynamic> gestacion) async {
    final db = await database;
    return await db.insert('gestacion', gestacion);
  }

  // ================= CRUD ALIMENTOS =================
  Future<int> insertAlimento(Map<String, dynamic> alimento) async {
    final db = await database;
    return await db.insert('alimentos', alimento);
  }
}
