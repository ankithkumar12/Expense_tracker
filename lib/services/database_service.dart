import 'package:expense_tracker/models/expense.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<String> getPath() async {
  var databasePath = join(await getDatabasesPath(), 'expenses.db');
  return databasePath;
}

class DatabaseService {
  final _databaseName = 'expenses.db';
  final _databaseVersion = 1;

  final expensesTable = 'Expenses';
  final expenseID = 'id';
  final expenseName = 'title';
  final expenseAmount = 'amount';
  final expenseDate = 'date';
  final expenseCategory = 'category';

  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) {
        db.execute(
          '''CREATE TABLE $expensesTable($expenseID INTEGER PRIMARY KEY, $expenseName TEXT NOT NULL,$expenseAmount REAL NOT NULL,$expenseDate TEXT NOT NULL,$expenseCategory TEXT NOT NULL)''',
        );
      },
    );
  }

  void insertExpense(Expense expense) async {
    var db = await openDatabase(await getPath());
    await db.execute(
        // '''INSERT INTO $expensesTable($expenseName,$expenseAmount,$expenseDate,$expenseCategory) VALUES(${expense.title},${expense.amount},${expense.date.toString()},${expense.category.name})'''
        '''INSERT INTO $expensesTable($expenseName,$expenseAmount,$expenseDate,$expenseCategory) 
       VALUES(?, ?, ?, ?)''',
        [
          expense.title,
          expense.amount,
          expense.date.toString(),
          expense.category.name
        ]);
  }

  void reinsertExpense(Expense expense) async {
    print("In resert function");
    var db = await openDatabase(await getPath());
    await db.execute(
        // '''INSERT INTO $expensesTable($expenseName,$expenseAmount,$expenseDate,$expenseCategory) VALUES(${expense.title},${expense.amount},${expense.date.toString()},${expense.category.name})'''
        '''INSERT INTO $expensesTable($expenseID,$expenseName,$expenseAmount,$expenseDate,$expenseCategory) 
       VALUES(?,?, ?, ?, ?)''',
        [
          expense.id,
          expense.title,
          expense.amount,
          expense.date.toString(),
          expense.category.name
        ]);
  }

  void deleteExpense(int expenseID) async {
    var db = await openDatabase(await getPath());
    await db
        .rawDelete('''DELETE FROM $expensesTable WHERE id = ?''', [expenseID]);
  }
}
