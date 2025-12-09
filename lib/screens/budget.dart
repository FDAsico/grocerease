import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final budgetController = TextEditingController(text: "20000.00");
  final FocusNode budgetFocus = FocusNode();
  bool isEditing = false;

  int currentMonthIndex = DateTime.now().month - 1;
  final List<String> months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  final Map<String, double> monthlyBudgets = {
      "January": 20500.00,
      "February": 18750.00,
      "March": 22300.00,
      "April": 19900.00,
      "May": 21400.00,
      "June": 20000.00,
      "July": 23150.00,
      "August": 19750.00,
      "September": 22600.00,
      "October": 20900.00,
      "November": 21800.00,
      "December": 24200.00,
    };

  final Map<String, List<Map<String, dynamic>>> monthlyExpenses = {
    "January": [
      {"date": "Jan 28", "amount": -2000.00},
      {"date": "Jan 22", "amount": -2000.00},
    ],
    "February": [
      {"date": "Feb 15", "amount": -1500.00},
      {"date": "Feb 10", "amount": -500.00},
    ],
    "March": [
      {"date": "Mar 5", "amount": -2500.00},
    ],
    "April": [
      {"date": "Apr 3", "amount": -3100.00},
      {"date": "Apr 17", "amount": -2200.00},
      {"date": "Apr 8", "amount": -4500.00},
      {"date": "Apr 25", "amount": -1900.00}
    ],
    "May": [
      {"date": "May 6", "amount": -2800.00},
      {"date": "May 18", "amount": -500.00},
      {"date": "May 12", "amount": -3300.00},
      {"date": "May 21", "amount": -4700.00},
      {"date": "May 28", "amount": -1500.00}
    ],
    "June": [
      {"date": "Jun 2", "amount": -2200.00},
      {"date": "Jun 11", "amount": -3800.00},
      {"date": "Jun 20", "amount": -3100.00},
      {"date": "Jun 25", "amount": -4500.00}
    ],
    "July": [
      {"date": "Jul 5", "amount": -2700.00},
      {"date": "Jul 14", "amount": -3500.00},
      {"date": "Jul 18", "amount": -1900.00},
      {"date": "Jul 23", "amount": -4200.00},
      {"date": "Jul 27", "amount": -1500.00}
    ],
    "August": [
      {"date": "Aug 1", "amount": -500.00},
      {"date": "Aug 7", "amount": -3100.00},
      {"date": "Aug 15", "amount": -4500.00},
      {"date": "Aug 22", "amount": -2500.00}
    ],
    "September": [
      {"date": "Sep 4", "amount": -3700.00},
      {"date": "Sep 10", "amount": -2800.00},
      {"date": "Sep 19", "amount": -2200.00},
      {"date": "Sep 25", "amount": -4000.00},
      {"date": "Sep 28", "amount": -1500.00}
    ],
    "October": [
      {"date": "Oct 28", "amount": -2000.00},
      {"date": "Oct 22", "amount": -2000.00},
      {"date": "Oct 15", "amount": -5000.00},
      {"date": "Oct 12", "amount": -3500.00},
      {"date": "Oct 8", "amount": -2130.00},
      {"date": "Oct 1", "amount": -5030.00},
    ],
    "November": [
      {"date": "Nov 6", "amount": -2800.00},
      {"date": "Nov 13", "amount": -1500.00},
      {"date": "Nov 18", "amount": -4200.00},
      {"date": "Nov 24", "amount": -3100.00},
      {"date": "Nov 27", "amount": -2000.00}
    ],
    "December": [
      {"date": "Dec 2", "amount": -3500.00},
      {"date": "Dec 9", "amount": -2700.00},
      {"date": "Dec 15", "amount": -4500.00},
      {"date": "Dec 20", "amount": -1800.00}
    ],
  };

  final commaMoney = NumberFormat("#,##0.00", "en_US");
  @override
  void initState() {
    super.initState();
    // Set budget
    budgetController.text = commaMoney.format(monthlyBudgets[months[currentMonthIndex]]);
  }

  void updateBudgetForMonth() {
    double budget = monthlyBudgets[months[currentMonthIndex]] ?? 0;
    budgetController.text = commaMoney.format(budget);
  }

  void startEditing() {
    setState(() => isEditing = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(budgetFocus);
      budgetController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: budgetController.text.length,
      );
    });
  }

  void finishEditing() {
    setState(() => isEditing = false);
    budgetFocus.unfocus();
    double val = double.tryParse(budgetController.text.replaceAll(",", "")) ?? 0;
    budgetController.text = commaMoney.format(val);
    monthlyBudgets[months[currentMonthIndex]] = val;
  }

  @override
  Widget build(BuildContext context) {
    final currentMonthExpenses = monthlyExpenses[months[currentMonthIndex]] ?? [];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Monthly Budget",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            // Monthly Budget
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "₱",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),

                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: budgetController,
                    focusNode: budgetFocus,
                    enabled: isEditing,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.orange[700],
                      fontWeight: FontWeight.bold,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      String clean = value.replaceAll(",", "");
                      if (clean.isEmpty) return;

                      double? val = double.tryParse(clean);
                      if (val != null) {
                        String formatted = commaMoney.format(val);
                        budgetController.value = TextEditingValue(
                          text: formatted,
                          selection: TextSelection.collapsed(offset: formatted.length),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 5),

                Material(
                  color: isEditing ? Colors.green[300] : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () {
                      if (isEditing) {
                        finishEditing();
                      } else {
                        startEditing();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: isEditing ? Colors.white : Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Month Picker < Month >
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 20),
                  onPressed: () {
                    setState(() {
                      currentMonthIndex = (currentMonthIndex - 1 + 12) % 12;
                      updateBudgetForMonth();
                    });
                  },
                ),
                Text(
                  months[currentMonthIndex],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  onPressed: () {
                    setState(() {
                      currentMonthIndex = (currentMonthIndex + 1) % 12;
                      updateBudgetForMonth();
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Expenses List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: currentMonthExpenses.length,
                itemBuilder: (context, index) {
                  final item = currentMonthExpenses[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2EFE8),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item["date"] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "-₱${commaMoney.format((item["amount"] as double).abs())}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
