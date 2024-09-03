import 'dart:ffi';
import 'dart:math';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';

import "../services/database_service.dart";

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

    print(expenses);

    setState(() {
      _registeredExpenses = expenses
          .map((expense) => Expense(
              title: expense['expenseName'] as String,
              amount: expense['expenseAmount'] as double,
              category: expense['expenseCategory'] as Category,
              date: expense['expenseDate'] as DateTime))
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
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: Column(
        children: [
          Image.asset("assets/images/shopping.png"),
          const Text('No expenses found. Start adding some!'),
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
