import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/todo_model.dart';

class DatabaseHelper {
  late Database _database;

  Future<void> initdb() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'tododb'),
      version: 1,
      onCreate: (db, version) {
        db.execute('''CREATE TABLE todo_table(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT,isCompleted BOOLEAN)''');
      },
    );
  }

  Future<int> insertTask(TodoModel todo) async {
    await initdb();
    return _database.insert("todo_table", todo.toMap());
  }
  Future<int> updateTask(TodoModel todo) async {
    await initdb();
    return _database.update("todo_table", todo.toMap(),where: 'id=?',whereArgs: [todo.id]);
  }

 Future<List<Map<String, dynamic>>> getAllTodos() async {
    await initdb();
    return await _database.query("todo_table");
  }
  Future<int> deleteTask(int id) async {
    await initdb();
    return _database.delete("todo_table", where: 'id=?',whereArgs: [id]);
  }


}
