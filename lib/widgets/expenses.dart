import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../extensions/stringExtension.dart';
import "../services/database_service.dart";

var mapCategory = {
  'food': Category.food,
  'leisure': Category.leisure,
  'luxury': Category.luxury,
  'travel': Category.travel,
  'work': Category.work,
};

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  List<Expense> _registeredExpenses = [];

  @override
  void initState() {
    super.initState();
    createDatabase();
    checkEmpty();
    getData();
  }

  void getData() async {
    var db = await openDatabase(await getPath());
    final expenses = await db.query(DatabaseService.instance.expensesTable);

    setState(() {
      _registeredExpenses = expenses
          .map((expense) => Expense(
              id: expense['id'] as int,
              title: expense['title'] as String,
              amount: expense['amount'] as double,
              category: mapCategory[expense['category'] as String] as Category,
              date: (expense['date'] as String).stringToDateTime()))
          .toList();
    });
  }

  void createDatabase() async {
    await DatabaseService.instance.database;
  }

  void checkEmpty() async {
    var path = await getPath();
    var db = await openDatabase(path);

    final rows = await db.query('Expenses');

    if (rows.isEmpty) {
      setState(() {
        // child = UserScreen(onSuccess: changeToInitialSync);
      });
    } else {
      // changeToMainScreen();
    }
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) async {
    DatabaseService.instance.insertExpense(expense);
    // setState(() {
    //   _registeredExpenses.add(expense);
    // });
    getData();
  }

  void _removeExpense(Expense expense) {
    // final expenseIndex = _registeredExpenses.indexOf(expense);
    // setState(() {
    // _registeredExpenses.remove(expense);
    DatabaseService.instance.deleteExpense(expense.id!);
    // });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 60),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // setState(() {
            DatabaseService.instance.reinsertExpense(expense);
            getData();
            // });
          },
        ),
      ),
    );
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: Column(
        children: [
          Image.asset("assets/images/shopping.png"),
          Text(
            'No expenses found. Start adding some!',
            style: TextStyle(fontStyle: FontStyle.italic,fontSize: 20),
          ),
        ],
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
