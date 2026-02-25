import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:imani/core/models/quran_models.dart';

class QuranDatabase {
  static final QuranDatabase _instance = QuranDatabase._internal();
  factory QuranDatabase() => _instance;
  QuranDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'quran_uthmani.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE surahs(
        number INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        englishName TEXT NOT NULL,
        englishNameTranslation TEXT NOT NULL,
        revelationType TEXT NOT NULL,
        numberOfAyahs INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ayahs(
        number INTEGER PRIMARY KEY,
        text TEXT NOT NULL,
        numberInSurah INTEGER NOT NULL,
        juz INTEGER NOT NULL,
        page INTEGER NOT NULL,
        surahNumber INTEGER NOT NULL,
        FOREIGN KEY (surahNumber) REFERENCES surahs (number) ON DELETE CASCADE
      )
    ''');

    // إنشاء فهرس على page لتسريع الاستعلامات
    await db.execute('CREATE INDEX idx_page ON ayahs(page)');
  }

  Future<void> insertFullQuran(List<Surah> surahs) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('ayahs');
      await txn.delete('surahs');

      for (var surah in surahs) {
        await txn.insert('surahs', surah.toMap());
      }

      for (var surah in surahs) {
        for (var ayah in surah.ayahs) {
          await txn.insert('ayahs', ayah.toMap());
        }
      }
    });
  }

  Future<List<Surah>> getSurahs() async {
    final db = await database;
    final List<Map<String, dynamic>> surahMaps = await db.query('surahs', orderBy: 'number ASC');
    return surahMaps.map((map) => Surah(
      number: map['number'],
      name: map['name'],
      englishName: map['englishName'],
      englishNameTranslation: map['englishNameTranslation'],
      revelationType: map['revelationType'],
      numberOfAyahs: map['numberOfAyahs'],
      ayahs: [],
    )).toList();
  }

  Future<List<Ayah>> getAyahsForSurah(int surahNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> ayahMaps = await db.query(
      'ayahs',
      where: 'surahNumber = ?',
      whereArgs: [surahNumber],
      orderBy: 'numberInSurah ASC',
    );
    return ayahMaps.map((map) => Ayah(
      number: map['number'],
      text: map['text'],
      numberInSurah: map['numberInSurah'],
      juz: map['juz'],
      page: map['page'],
      surahNumber: map['surahNumber'],
    )).toList();
  }

  // جلب جميع الآيات مرتبة (للبناء المبدئي للخريطة)
  Future<List<Ayah>> getAllAyahs() async {
    final db = await database;
    final List<Map<String, dynamic>> ayahMaps = await db.query('ayahs', orderBy: 'number ASC');
    return ayahMaps.map((map) => Ayah(
      number: map['number'],
      text: map['text'],
      numberInSurah: map['numberInSurah'],
      juz: map['juz'],
      page: map['page'],
      surahNumber: map['surahNumber'],
    )).toList();
  }

  // جلب آيات صفحة محددة
  Future<List<Ayah>> getAyahsByPage(int page) async {
    final db = await database;
    final List<Map<String, dynamic>> ayahMaps = await db.query(
      'ayahs',
      where: 'page = ?',
      whereArgs: [page],
      orderBy: 'number ASC',
    );
    return ayahMaps.map((map) => Ayah(
      number: map['number'],
      text: map['text'],
      numberInSurah: map['numberInSurah'],
      juz: map['juz'],
      page: map['page'],
      surahNumber: map['surahNumber'],
    )).toList();
  }

  Future<bool> isDataLoaded() async {
    final db = await database;
    final result = await db.query('surahs', limit: 1);
    return result.isNotEmpty;
  }
}