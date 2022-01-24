import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'my_home_page.dart';

void main() {
  runApp(const MyApp());
}

void dbConnect() async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "demo_asset_example.db");

  // Check if the database exists
  var exists = await databaseExists(path);

  if (!exists) {
    // Should happen only the first time you launch your application
    print("Creating new copy from asset");

    // Make sure the parent directory exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    // Copy from asset
    ByteData data = await rootBundle.load(join("assets", "database.sqlite"));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes written
    await File(path).writeAsBytes(bytes, flush: true);

  } else {
    print("Opening existing database");
  }
  // open the database
  Database db = await openDatabase(path, readOnly: true);
  var dogs = await db.query("dogs");
  print(dogs);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dbConnect();

    return MaterialApp(
      title: 'BattleItOut',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Turn Order'),
    );
  }
}
