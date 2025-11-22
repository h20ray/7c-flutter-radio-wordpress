import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class StorageHelper {
  static Future<String> getDatabasePath() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    return path.join(documentsDirectory.path, 'tujuhcahaya_wprs.db');
  }

  static Future<Database> initDatabase() async {
    final dbPath = await getDatabasePath();
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        // Database tables will be created here as needed
      },
    );
  }
}

