import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../features/saved/data/models/saved_job_model.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.instance;
});

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  static const String tableSavedJobs = 'saved_jobs';

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('hustlers_mobile.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const tableActivity = 'activity_stats';
    const colId = 'id';
    const colAppliedJobs = 'no_of_applied_jobs';

    // Create the activity stats table
    await db.execute('''
      CREATE TABLE $tableActivity (
        $colId INTEGER PRIMARY KEY,
        $colAppliedJobs INTEGER NOT NULL
      )
    ''');

    // Create the saved jobs table
    await _createSavedJobsTable(db);

    // Insert 365 rows for activity stats
    final batch = db.batch();
    for (int i = 1; i <= 365; i++) {
      batch.insert(tableActivity, {
        colId: i,
        colAppliedJobs: 0, // Initialize with 0
      });
    }
    await batch.commit(noResult: true);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createSavedJobsTable(db);
    }
  }

  Future<void> _createSavedJobsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableSavedJobs (
        id INTEGER PRIMARY KEY,
        jobname TEXT,
        jobtype TEXT,
        price TEXT,
        deep_link TEXT,
        jobdescrbiton TEXT,
        expierdate TEXT,
        posted_at TEXT,
        status TEXT
      )
    ''');
  }

  // --- Saved Jobs Methods ---

  Future<void> insertSavedJob(SavedJobModel job) async {
    final db = await instance.database;
    await db.insert(
      tableSavedJobs,
      job.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SavedJobModel>> getSavedJobs() async {
    final db = await instance.database;
    final result = await db.query(tableSavedJobs, orderBy: "posted_at DESC");
    return result.map((json) => SavedJobModel.fromMap(json)).toList();
  }

  Future<void> updateSavedJobStatus(int id, String status) async {
    final db = await instance.database;
    await db.update(
      tableSavedJobs,
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteSavedJob(int id) async {
    final db = await instance.database;
    await db.delete(
      tableSavedJobs,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> incrementTodayAppliedJob() async {
    final db = await instance.database;
    // We used 1-365 for ID. Needs mapping from date to ID (day of year).
    // Simple approach: get day of year.
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final dayOfYear = now.difference(startOfYear).inDays + 1;

    // Safety check for leap years or overflow
    if (dayOfYear > 365) return;

    await db.rawUpdate(
      'UPDATE activity_stats SET no_of_applied_jobs = no_of_applied_jobs + 1 WHERE id = ?',
      [dayOfYear],
    );
  }

  Future<int> getAppliedJobsSum(int startId, int endId) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT SUM(no_of_applied_jobs) as total FROM activity_stats WHERE id BETWEEN ? AND ?',
      [startId, endId],
    );
    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    }
    return 0;
  }

  Future<Map<int, int>> getAppliedJobsForRange(int startId, int endId) async {
    final db = await instance.database;
    final result = await db.query(
      'activity_stats',
      columns: ['id', 'no_of_applied_jobs'],
      where: 'id BETWEEN ? AND ?',
      whereArgs: [startId, endId],
    );

    final map = <int, int>{};
    for (final row in result) {
      map[row['id'] as int] = row['no_of_applied_jobs'] as int;
    }
    return map;
  }
}
