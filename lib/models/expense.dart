import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final monthDateFormatter = DateFormat.MMMd();
final dayFormatter = DateFormat.EEEE();
final timeFormatter = DateFormat().add_jm();

const uuid = Uuid();

enum Category { food, travel, leisure, work, luxury }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
  Category.luxury: Icons.currency_bitcoin_rounded,
};

class Expense {
  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return "${monthDateFormatter.format(date)} ${dayFormatter.format(date).substring(0, 3)}";
  }

  String get formattedTime {
    return timeFormatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}
