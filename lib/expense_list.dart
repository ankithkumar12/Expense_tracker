import "package:expense_tracker/models/expense_model.dart";
import "package:flutter/material.dart";

class ExpenseList extends StatelessWidget {
  const ExpenseList(this.expenses, {required this.onDissmissed,super.key});
  final List<Expense> expenses;

  final Function(Expense expense) onDissmissed;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: ValueKey(expenses[index]),
            onDismissed: (direction) => {
              onDissmissed(expenses[index])
            },
            child: Card(
              child: Column(
                children: [
                  Text(expenses[index].title),
                  const Padding(padding: EdgeInsets.all(8)),
                  Row(
                    children: [
                      Text(expenses[index].amount.toStringAsFixed(2)),
                      const Spacer(),
                      Icon(expenses[index].suitIcon),
                      Text(expenses[index].formattedDate),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
