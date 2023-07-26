import 'package:expense_tracker/models/expense_model.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({required this.onPressedSave, super.key});

  final void Function(Expense expense) onPressedSave;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  DateTime? selectedDate;
  var selectedCategory = Category.leisure;

  void openDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: now,
    );
    setState(() {
      selectedDate = pickedDate;
      //print(selectedDate);
    });
  }

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void saveExpense() {
    var enteredAmount = double.tryParse(_amountController.text);
    var amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim() == "" ||
        amountIsInvalid ||
        selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      return;
                    },
                    child: const Text("Okay"))
              ],
              title: const Text("Invalid Input"),
              content: const Text(
                  "Please enter the correct title or amount or date!"),
            );
          });
    }
    widget.onPressedSave(Expense(
        title: _titleController.text,
        amount: enteredAmount!,
        date: selectedDate!,
        category: selectedCategory));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              label: Text("Title"),
            ),
            maxLength: 30,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    prefixText: "₹",
                    label: Text(
                      "Amount",
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Text(selectedDate == null
                  ? "No date selected!"
                  : formatter.format(selectedDate!)),
              const SizedBox(width: 10),
              IconButton(
                  onPressed: openDatePicker, icon: const Icon(Icons.date_range))
            ],
          ),
          Row(
            children: [
              DropdownButton(
                  value: selectedCategory,
                  items: Category.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      selectedCategory = value;
                      //print(selectedCategory);
                    });
                  }),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  saveExpense();
                },
                child: const Text("Save Expense"),
              )
            ],
          ),
        ],
      ),
    );
  }
}
