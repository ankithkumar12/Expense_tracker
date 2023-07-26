import "package:expense_tracker/models/expense_model.dart";
import "package:flutter/material.dart";

class ExpenseList extends StatelessWidget {
  const ExpenseList(this.expenses, {required this.onDissmissed, super.key});
  final List<Expense> expenses;

  final Function(Expense expense) onDissmissed;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: ValueKey(expenses[index]),
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.5),
              margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal,
              ),
            ),
            onDismissed: (direction) => {onDissmissed(expenses[index])},
            child: Card(
              child: Column(
                
                children: [
                  Text(
                        expenses[index].amount.toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                  
                  Text(expenses[index].title,style:const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700), ),
                  const Padding(padding: EdgeInsets.all(6)),
                  Row(
                    children: [
                      // Text(
                      //   expenses[index].amount.toStringAsFixed(2),
                      //   style: const TextStyle(
                      //       fontSize: 20, fontWeight: FontWeight.bold),
                      // ),
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
