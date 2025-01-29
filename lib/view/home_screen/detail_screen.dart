import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:money_goal_application/db_functions/db_functions.dart';
import 'package:money_goal_application/model/goal_model.dart';
import 'package:money_goal_application/model/saving_model.dart';

class LossesScreen extends StatefulWidget {
  final GoalModel goalData;
  final ValueNotifier<GoalModel> goalNotifier;
  const LossesScreen(
      {Key? key, required this.goalData, required this.goalNotifier})
      : super(key: key);

  @override
  State<LossesScreen> createState() => _LossesScreenState();
}

class _LossesScreenState extends State<LossesScreen> {
  DateTime? selectedDate;
  final TextEditingController _amountCont = TextEditingController();
  final TextEditingController _descCont = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    getSavingsForGoal(widget.goalData.id.toString());
    getAllGoalBox(widget.goalData.id.toString());
    getAllSavings();
  }

  @override
  Widget build(BuildContext context) {
    double progress = 0.0;
    try {
      double currentBalance = double.parse(widget.goalData.currentBalance);
      double targetAmount = double.parse(widget.goalData.amount);
      progress = currentBalance / targetAmount;
      // Limit progress to 2 decimal places
      progress = double.parse(progress.toStringAsFixed(2));
      print(progress);
    } catch (e) {
      print("Error parsing values: $e");
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.goalData.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: widget.goalNotifier,
          builder: (context, goalData, child) {
            return Column(
              children: [
                const SizedBox(height: 20),
                // Amount Display
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '₹${goalData.currentBalance}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' / ₹${widget.goalData.amount}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Circular Progress
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.show_chart,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      child: Text(
                        '%${progress}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                        'Add Saving', Icons.add, Colors.white, true,
                        action: () {
                      _showAddSavingSheet(context);
                    }),
                    _buildActionButton(
                        'Withdrawal', Icons.remove, Colors.grey[800]!, false),
                    _buildActionButton(
                        'Progress', Icons.show_chart, Colors.grey[800]!, false),
                    _buildActionButton(
                        'Invite+', Icons.refresh, Colors.grey[800]!, false),
                  ],
                ),
                const SizedBox(height: 40),
                // Transactions Section
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Transactions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
const SizedBox(height: 20),
                         

                          ValueListenableBuilder<List<SavingModel>>(
                            valueListenable: savingListsNotifier,
                            builder: (context, savingList, child) {
                              final lists = savingList
                                  .where((item) =>
                                      item.goalId == widget.goalData.id)
                                  .toList();
                              if (lists.isEmpty) {
                                return Center(child: Text("No savings found"));
                              }

                              return SingleChildScrollView(
                                child: Column(
                                  children:
                                      List.generate(lists.length, (index) {
                                    final savings = lists[index];
                                    print(savings.transactionDate);
                                    return _buildTransactionItem(
                                        savings: savings);
                                  }),
                                ),
                              );
                            },
                          ),

                          
                          // ValueListenableBuilder<List<SavingModel>>(
                          //   valueListenable: savingListsNotifier,
                          //   builder: (context, savingList, child) {
                          //     if (savingList.isEmpty) {
                          //       return Center(child: Text("No savings found"));
                          //     }

                          //     return Column(
                          //       children: List.generate(savingList.length, (index) {
                          //         final savings = savingList[index];
                          //         return _buildTransactionItem(savings: savings);
                          //       }),
                          //     );
                          //   },
                          // )

                          // : Text(
                          //     "Empty transactions",
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  void _showAddSavingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModelSatate) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  16, // Handles keyboard padding
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Saving",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideX(begin: -0.2, end: 0),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountCont,
                    decoration: const InputDecoration(
                        labelText: "Amount",
                        hintText: "0",
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            borderSide: BorderSide(color: Colors.grey))),
                    keyboardType: TextInputType.number,
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: -0.4, end: 0),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descCont,
                    decoration: const InputDecoration(
                        labelText: "Description",
                        hintText: "Additional noted",
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            borderSide: BorderSide(color: Colors.grey))),
                  )
                      .animate()
                      .fadeIn(duration: 700.ms)
                      .slideX(begin: -0.6, end: 0),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMM dd, yyyy')
                            .format(selectedDate ?? DateTime.now()),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setModelSatate(() => selectedDate = picked);
                            }
                          },
                          child: Icon(Icons.calendar_today)),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 900.ms)
                      .slideX(begin: -0.8, end: 0),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the BottomSheet
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (selectedDate != null) {
                              try {
                                print(_amountCont.text);
                                print(_descCont.text);

                                final saving = SavingModel(
                                  savingAmount: _amountCont.text,
                                  description: _descCont.text,
                                  transactionDate: DateFormat('yyyy-MM-dd')
                                      .format(selectedDate!),
                                  id: widget.goalData.id,
                                );
                                print(
                                    "gggggggggggg  ${widget.goalData.id.toString()}");
                                // await addSaving(saving);
                                // await updateGoalBox(
                                //     id: widget.goalData.id.toString(),
                                //     updatedGoal: GoalModel(
                                //         name: widget.goalData.name,
                                //         currency: widget.goalData.currency,
                                //         amount: widget.goalData.amount,
                                //         currentBalance:
                                //             widget.goalData.currentBalance,
                                //         targetDate: widget.goalData.targetDate,
                                //         iconCodePoint:
                                //             widget.goalData.iconCodePoint,
                                //         iconFontFamily:
                                //             widget.goalData.iconFontFamily,
                                //         savings: [
                                //           ...(widget.goalData.savings ?? []),
                                //           saving
                                //         ]));

                                await addSavings(
                                    goalId: widget.goalData.id.toString(),
                                    saving: saving).then((_) async{
                                      final amt = int.parse(widget.goalData.amount) + int.parse(_amountCont.text);
                                       final goalBox = await Hive.openBox<GoalModel>("goalBox");
                                       goalBox.put(widget.goalData.id, GoalModel(
                                        name: widget.goalData.name, 
                                        currency: widget.goalData.currency, 
                                        amount: amt.toString(), 
                                        currentBalance: widget.goalData.currentBalance, 
                                        targetDate: widget.goalData.targetDate, iconCodePoint: widget.goalData.iconCodePoint,
                                        iconFontFamily: widget.goalData.iconFontFamily, ));

                                    });
                                Navigator.pop(context);
                              } catch (e) {
                                // Show error to user
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Failed to add saving: ${e.toString()}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: Text("Update Goal"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, bool isActive,
      {VoidCallback? action}) {
    return Column(
      children: [
        InkWell(
          radius: 50,
          borderRadius: BorderRadius.circular(50),
          onTap: action ?? () {},
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.black : Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem({required SavingModel savings}) {
    final _format =
        DateTime.parse(savings.transactionDate ?? DateTime.now().toString());
    final date = DateFormat("MMM dd, yyyy").format(_format);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 15),
          Text(
            date,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Text(
            '+ ₹${savings.savingAmount}',
            style: const TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
