import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:money_goal_application/core/animated_navigation.dart';
import 'package:money_goal_application/db_functions/db_helper.dart';
import 'package:money_goal_application/model/goal_model.dart';
import 'package:money_goal_application/model/saving_model.dart';
import 'package:money_goal_application/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:money_goal_application/view/edit_screen/edit_screen.dart';

class LossesScreen extends StatefulWidget {
  final GoalModel goal;
  const LossesScreen({
    Key? key,
    required this.goal,
  }) : super(key: key);

  @override
  State<LossesScreen> createState() => _LossesScreenState();
}

class _LossesScreenState extends State<LossesScreen> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _amountCont = TextEditingController();
  final TextEditingController _descCont = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late ValueNotifier<List<SavingModel>> savingNotifier;

  @override
  void initState() {
    super.initState();
    savingNotifier = _dbHelper.getSavingsNotifier(widget.goal.id!);
  }

  void showDeleteDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this goal?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onConfirm(); // Call the delete function
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = 0.0;
    try {
      double targetAmount = double.parse(widget.goal.amount);
      double bal = double.parse(widget.goal.currentBalance);
      progress = (bal / targetAmount) * 100;
      progress = double.parse(progress.toStringAsFixed(2));
      print(progress);
    } catch (e) {
      print("Error parsing values: $e");
    }

    final _icon = widget.goal.toIconData();

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
          widget.goal.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            iconColor: Colors.white,
            position: PopupMenuPosition.under,
            onSelected: (value) async {
              if (value == 'edit') {
                Navigator.push(
                    context,
                    AnimatedNavigation().fadeAnimation(EditScreen(
                      goal: widget.goal,
                    )));
              } else if (value == 'delete') {
                //
                showDeleteDialog(context, () {
                  _dbHelper.deleteGoal(widget.goal, context);
                  Navigator.pop(context);
                });
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Amount Display
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '₹${widget.goal.currentBalance}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' / ₹${widget.goal.amount}',
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
                    child: Icon(
                      _icon,
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
              _buildActionButton('Add Saving', Icons.add, Colors.white, true,
                  action: () {
                _showAddSavingSheet(context, isWithdraw: false);
              }),
              _buildActionButton(
                  'Withdrawal', Icons.remove, Colors.grey[800]!, false,
                  action: () {
                _showAddSavingSheet(context, isWithdraw: true);
              }),
              _buildActionButton(action: () {
                // _showGraphBottomSheet(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNav(
                              index: 1,
                            )),
                    (Route<dynamic> route) => false);
              }, 'Progress', Icons.show_chart, Colors.grey[800]!, false),
              // _buildActionButton(
              //     'Invite+', Icons.refresh, Colors.grey[800]!, false),
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
                    // ValueListenableBuilder<List<SavingModel>>(
                    //   valueListenable: savingNotifier,
                    //   builder: (context, savings, child) {
                    //     return Column(
                    //       children: List.generate(savings.length, (index) {
                    //         final saving = savings[index];
                    //         return ListTile(
                    //           title: Text("Saved: ${saving.savingAmount}"),
                    //           subtitle: Text("Date: ${saving.transactionDate}"),
                    //         );
                    //       }),
                    //     );
                    //   },
                    // ),
                    ValueListenableBuilder<List<SavingModel>>(
                      valueListenable: savingNotifier,
                      builder: (context, savingList, child) {
                        return SingleChildScrollView(
                          child: Column(
                            children: List.generate(savingList.length, (index) {
                              final savings = savingList[index];
                              print(savings.transactionDate);
                              return _buildTransactionItem(savings: savings);
                            }),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSavingSheet(BuildContext context, {required bool isWithdraw}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.grey[900],
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModelState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16, // Handles keyboard padding
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isWithdraw == true ? "Withdrawal" : "Add Saving",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideX(begin: -0.2, end: 0),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountCont,
                    style: TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Amount",
                      hintText: "0",
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: -0.4, end: 0),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descCont,
                    style: TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Description",
                      hintText: "Additional noted",
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
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
                          color: Colors.white,
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
                            setModelState(() => selectedDate = picked);
                          }
                        },
                        child: Icon(Icons.calendar_today, color: Colors.white),
                      ),
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
                          setModelState(() {
                            _amountCont.clear();
                            _descCont.clear();
                            selectedDate = DateTime.now();
                          });
                          Navigator.of(context).pop(); // Close the BottomSheet
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (isWithdraw == true) {
                              final saving = SavingModel(
                                savingAmount: _amountCont.text,
                                transactionDate: selectedDate.toString(),
                                isWithdraw: true,
                              );

                             double d = double.parse(_amountCont.text);
                              double currentBal =
                                  double.parse(widget.goal.currentBalance);
                              double goalAmount =
                                  double.parse(widget.goal.amount);

                              if (d > currentBal) {
                                Navigator.pop(context);
                                setModelState(() {
                                  _amountCont.clear();
                                  _descCont.clear();
                                  selectedDate = DateTime.now();
                                });

                                Fluttertoast.showToast(
                                  msg: "You can't withdraw more than your current balance",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.black54,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              } else {
                                _dbHelper.addSaving(widget.goal.id!, saving);
                                double a = double.parse(widget.goal.amount);
                                double b = double.parse(_amountCont.text);

                                setState(() {
                                  // final c = a - b;
                                   final c = currentBal - d;
                                  widget.goal.currentBalance = c.toString();
                                });

                                setModelState(() {
                                  _amountCont.clear();
                                  _descCont.clear();
                                  selectedDate = DateTime.now();
                                });

                                Navigator.pop(context);
                              }
                            } else {
                              final saving = SavingModel(
                                savingAmount: _amountCont.text,
                                transactionDate: selectedDate.toString(),
                                isWithdraw: false,
                              );

                              double d = double.parse(_amountCont.text);
                              double currentBal =
                                  double.parse(widget.goal.currentBalance);
                              double goalAmount =
                                  double.parse(widget.goal.amount);

                              if (currentBal >= goalAmount) {
                                Fluttertoast.showToast(
                                  msg: "You have already reached your goal amount!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.black54,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                Navigator.pop(context);
                                return;
                              }

                              if (d > (goalAmount - currentBal)) {
                                Fluttertoast.showToast(
                                  msg: "You can't save more than your goal amount",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.black54,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                Navigator.pop(context);
                                return;
                              }

                              _dbHelper.addSaving(widget.goal.id!, saving);
                              setState(() {
                                final c = currentBal + d;
                                widget.goal.currentBalance = c.toString();
                              });

                              setModelState(() {
                                _amountCont.clear();
                                _descCont.clear();
                                selectedDate = DateTime.now();
                              });

                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text(isWithdraw == true ? "Withdraw" : "Add"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

//  void _showAddSavingSheet(BuildContext context, {required bool isWithdraw}) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.grey[900],
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setModelSatate) {
//           return Padding(
//             padding: EdgeInsets.only(
//               left: 16,
//               right: 16,
//               top: 16,
//               bottom: MediaQuery.of(context).viewInsets.bottom + 16, // Handles keyboard padding
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     isWithdraw == true ? "Withdrawal" : "Add Saving",
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   )
//                       .animate()
//                       .fadeIn(duration: 500.ms)
//                       .slideX(begin: -0.2, end: 0),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _amountCont,
//                     style: TextStyle(color: Colors.white),
//                     decoration: const InputDecoration(
//                         labelText: "Amount",
//                         hintText: "0",
//                         labelStyle: TextStyle(color: Colors.grey),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(15),
//                             ),
//                             borderSide: BorderSide(color: Colors.grey)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(15),
//                             ),
//                             borderSide: BorderSide(color: Colors.grey)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(15),
//                             ),
//                             borderSide: BorderSide(color: Colors.grey))),
//                     keyboardType: TextInputType.number,
//                   )
//                       .animate()
//                       .fadeIn(duration: 600.ms)
//                       .slideX(begin: -0.4, end: 0),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _descCont,
//                     style: TextStyle(color: Colors.white),
//                     decoration: const InputDecoration(
//                         labelText: "Description",
//                         hintText: "Additional noted",
//                         labelStyle: TextStyle(color: Colors.grey),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(15),
//                             ),
//                             borderSide: BorderSide(color: Colors.grey)),
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(15),
//                             ),
//                             borderSide: BorderSide(color: Colors.grey)),
//                         focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(15),
//                             ),
//                             borderSide: BorderSide(color: Colors.grey))),
//                   )
//                       .animate()
//                       .fadeIn(duration: 700.ms)
//                       .slideX(begin: -0.6, end: 0),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         DateFormat('MMM dd, yyyy')
//                             .format(selectedDate ?? DateTime.now()),
//                         style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white),
//                       ),
//                       InkWell(
//                           onTap: () async {
//                             final DateTime? picked = await showDatePicker(
//                               context: context,
//                               initialDate: selectedDate,
//                               firstDate: DateTime.now(),
//                               lastDate: DateTime(2030),
//                             );
//                             if (picked != null) {
//                               setModelSatate(() => selectedDate = picked);
//                             }
//                           },
//                           child:
//                               Icon(Icons.calendar_today, color: Colors.white)),
//                     ],
//                   )
//                       .animate()
//                       .fadeIn(duration: 900.ms)
//                       .slideX(begin: -0.8, end: 0),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       TextButton(
//                         onPressed: () {
//                           setModelSatate(() {
//                             _amountCont.clear();
//                             _descCont.clear();
//                             selectedDate = DateTime.now();
//                           });
//                           Navigator.of(context).pop(); // Close the BottomSheet
//                         },
//                         child: const Text("Cancel"),
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           if (_formKey.currentState!.validate()) {
//                             if (isWithdraw == true) {
//                               final saving = SavingModel(
//                                 savingAmount: _amountCont.text,
//                                 transactionDate: selectedDate.toString(),
//                                 isWithdraw: true,
//                               );

//                               double d = double.parse(_amountCont.text);
//                               double cuurentBal =
//                                   double.parse(widget.goal.currentBalance);
//                               if (d > cuurentBal) {
//                                 Navigator.pop(context);
//                                 setModelSatate(() {
//                                   _amountCont.clear();
//                                   _descCont.clear();
//                                   selectedDate = DateTime.now();
//                                 });

//                                 Fluttertoast.showToast(
//                                   msg: "You can't withdraw more than your current balance",
//                                   toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
//                                   gravity: ToastGravity.BOTTOM, // Position of the toast
//                                   backgroundColor: Colors.black54,
//                                   textColor: Colors.white,
//                                   fontSize: 16.0,
//                                 );

//                               } else {
//                                 _dbHelper.addSaving(widget.goal.id!, saving);
//                                 double a = double.parse(widget.goal.amount);
//                                 double b = double.parse(_amountCont.text);

//                                 setState(() {
//                                   final c = a - b;
//                                   widget.goal.currentBalance = c.toString();
//                                 });

//                                 setModelSatate(() {
//                                   _amountCont.clear();
//                                   _descCont.clear();
//                                   selectedDate = DateTime.now();
//                                 });

//                                 Navigator.pop(context);
//                               }
//                             } else {
//                               final saving = SavingModel(
//                                 savingAmount: _amountCont.text,
//                                 transactionDate: selectedDate.toString(),
//                                 isWithdraw: false,
//                               );

//                               double d = double.parse(_amountCont.text);
//                               double cuurentBal =
//                                   double.parse(widget.goal.amount);
//                               if (d > cuurentBal) {
//                                 Navigator.pop(context);

//                                 setModelSatate(() {
//                                   _amountCont.clear();
//                                   _descCont.clear();
//                                   selectedDate = DateTime.now();
//                                 });
//                                 Fluttertoast.showToast(
//                                   msg: "You can't save more than your current balance",
//                                   toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
//                                   gravity: ToastGravity.BOTTOM, // Position of the toast
//                                   backgroundColor: Colors.black54,
//                                   textColor: Colors.white,
//                                   fontSize: 16.0,
//                                 );

//                               } else {
//                                 _dbHelper.addSaving(widget.goal.id!, saving);
//                                 double a =
//                                     double.parse(widget.goal.currentBalance);
//                                 double b = double.parse(_amountCont.text);

//                                 setState(() {
//                                   final c = a + b; // Corrected calculation
//                                   widget.goal.currentBalance = c.toString();
//                                 });
//                                 setModelSatate(() {
//                                   _amountCont.clear();
//                                   _descCont.clear();
//                                   selectedDate = DateTime.now();
//                                 });
//                                 Navigator.pop(context);
//                               }
//                             }
//                           }
//                         },
//                         child: Text(isWithdraw == true ? "Withdraw" : "Add"),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//     },
//   );
// }


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
    final String dateString =
        savings.transactionDate ?? DateTime.now().toString();

// Remove microseconds from the date string
    final String cleanedDateString = dateString.split('.').first;

// Parse and format the date
    final DateTime parsedDate = DateTime.parse(cleanedDateString);
    final String formattedDate = DateFormat("MMM dd, yyyy").format(parsedDate);

    print(formattedDate); // Output: "Feb 16, 2025"

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: savings.isWithdraw == true
                  ? Colors.red.withValues(alpha: 0.2)
                  : Colors.green.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              savings.isWithdraw == true ? Icons.remove : Icons.add,
              color: savings.isWithdraw == true ? Colors.red : Colors.green,
            ),
          ),
          const SizedBox(width: 15),
          Text(
            formattedDate.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          savings.isWithdraw == true
              ? Text(
                  '- ₹${savings.savingAmount}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Text(
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
