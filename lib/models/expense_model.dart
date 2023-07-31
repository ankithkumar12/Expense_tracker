import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final uniq = const Uuid().v4();
final formatter = DateFormat().add_yMMMMEEEEd();

enum Category { food, travel, study, leisure, luxury }

Map<Category, IconData> maticon = {
  Category.food: Icons.food_bank,
  Category.leisure: Icons.child_care,
  Category.luxury: Icons.currency_bitcoin_sharp,
  Category.study: Icons.book_sharp,
  Category.travel: Icons.flight_takeoff_sharp
};

class Expense {
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uniq;

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  get formattedDate {
    return formatter.format(date);

    //return formatter.format(date);
  }

  get suitIcon {
    return maticon[category];
  }

  get dropdownMenu {
    return List.of(Category.values)
        .map(
          (item) => DropdownMenuItem(
            child: Text(
              item.toString(),
            ),
          ),
        )
        .toList();
  }
}
