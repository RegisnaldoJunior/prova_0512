import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  static var instance;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'series_comparison.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // Criar a tabela de séries
        db.execute('''
          CREATE TABLE series(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            genero TEXT,
            descricao TEXT,
            foto TEXT
          );
        ''');

        // Criar a tabela de comparações
        db.execute('''
          CREATE TABLE comparacoes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            serie1_id INTEGER,
            serie2_id INTEGER,
            melhor_serie_id INTEGER,
            data_comparacao TEXT,
            FOREIGN KEY(serie1_id) REFERENCES series(id),
            FOREIGN KEY(serie2_id) REFERENCES series(id),
            FOREIGN KEY(melhor_serie_id) REFERENCES series(id)
          );
        ''');
      },
    );
  }

  // Função para inserir uma série
  Future<int> insertSerie(Map<String, dynamic> serie) async {
    final db = await database;
    return await db.insert('series', serie);
  }

  // Função para pegar todas as séries
  Future<List<Map<String, dynamic>>> getSeries() async {
    final db = await database;
    return await db.query('series');
  }

  // Função para inserir uma comparação
  Future<int> insertComparacao(Map<String, dynamic> comparacao) async {
    final db = await database;
    return await db.insert('comparacoes', comparacao);
  }

  // Função para pegar todas as comparações
  Future<List<Map<String, dynamic>>> getComparacoes() async {
    final db = await database;
    return await db.query('comparacoes');
  }
}
