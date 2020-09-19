import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

class DbService {
  static Database _instance;

  Future<Database> get instance async {
    if (_instance != null) {
      return _instance;
    }

    _instance = await _open();

    return _instance;
  }

  List<String> get _init => [
    '''
      CREATE TABLE posts (
        uuid PRIMARY KEY,
        title TEXT,
        publishedAt TEXT
      )
    ''',
  ];

  List<String> get _migrations => [
    '''
      INSERT INTO posts (uuid, title, publishedat)
      VALUES
        ('042699ac-a3e2-4bff-bac5-6adc05c0aa20', 'Post #1', '2020-09-19 13:54:31.076Z')
    ''',
  ];

  Future<Database> _open() async {
    final databasesPath = await getDatabasesPath();

    final path = join(databasesPath, 'offline_first.db');

    return await openDatabaseWithMigration(
      path,
      MigrationConfig(
        initializationScript: _init,
        migrationScripts: _migrations,
      ),
    );
  }
}