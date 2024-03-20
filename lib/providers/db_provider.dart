import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider{

  static Database? _database;

  //Es un singleton
  //Sempre accedim a la mateixa instància
  static final DBProvider db = DBProvider._();

  //Constructor Privat
  DBProvider._();

  Future<Database> get database async {
    if(_database == null) _database = await initDB();

    return _database!;
  }

  //Inicialitzam la Base de Dades
  Future<Database> initDB() async{
    //Obtenir el path
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Scans.db');
    print(path);

    //Crear la BBDD
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async{
        await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipus TEXT,
            valor TEXT
          )
        ''');
      }
    );

  }

  //Mètodes per les diferents operacions de SQL
  Future<int> insertRawScan(ScanModel nouScan) async {
    final id = nouScan.id;
    final tipus = nouScan.tipus;
    final valor = nouScan.valor;

    final db = await database;

    final res = await db.rawInsert(''' 
      INSERT INTO Scans(id, tipus, valor)
        VALUES ($id, $tipus, $valor)
    ''');

    return res;
  }

  Future<int> insertScan(ScanModel nouScan) async {
    final db = await database;

    final res = await db.insert('Scans', nouScan.toMap());

    print(res);
    return res;
  }

  //Select de tota la taula
  Future<List<ScanModel>> getAllScans() async{
    final db = await database;
    final res = await db.query('Scans');

    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  //Select per id
  Future<ScanModel?> getScanById(int id) async{
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    if(res.isNotEmpty){
      return ScanModel.fromMap(res.first);
    }
    return null;
  }

  //Select per tipus
  Future<List<ScanModel>> getScanByTipus(String tipus) async{
    final db = await database;
    final res = await db.query('Scans', where: 'tipus = ?', whereArgs: [tipus]);

    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  //Update
  Future<int> updateScan(ScanModel nouScan) async {
    final db =await database;
    final res = db.update('Scans', nouScan.toMap(), where: 'id = ?', whereArgs: [nouScan.id]);

    return res;
  }

  //Delete ALL
  Future<int> deleteAllScans() async{
    final db = await database;
    final res = await db.rawDelete('''
      DELETE FROM Scans
    ''');

    return res;
  }

  //TODO : Delete by id
}