import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_goal_application/db_functions/db_helper.dart';
import 'package:money_goal_application/model/goal_model.dart';
import 'package:money_goal_application/services/goal_services.dart';
import 'package:money_goal_application/view/home_screen/add_goal/add_goal_name.dart';
import 'dart:ui';

import 'package:money_goal_application/view/home_screen/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String selectedSortOption = 'Progress'; // Default sorting option

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0, end: 0.08).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  List<GoalModel> _sortGoals(List<GoalModel> goals) {
    switch (selectedSortOption) {
      case 'Date':
        return _sortByDate(goals);
      case 'Alphabet':
        return _sortByAlphabet(goals);
      case 'Progress':
        return _sortByProgress(goals);
      default:
        return goals;
    }
  }

  List<GoalModel> _sortByDate(List<GoalModel> goals) {
    return goals
      ..sort((a, b) => b.targetDate.compareTo(a.targetDate)); // Newest first
  }

  List<GoalModel> _sortByAlphabet(List<GoalModel> goals) {
    return goals..sort((a, b) => a.name.compareTo(b.name)); // A-Z
  }

  List<GoalModel> _sortByProgress(List<GoalModel> goals) {
    return goals
      ..sort((a, b) {
        double progressA =
            double.parse(a.currentBalance) / double.parse(a.amount);
        double progressB =
            double.parse(b.currentBalance) / double.parse(b.amount);
        return progressB.compareTo(progressA); // Highest progress first
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[50]!,
              Colors.white,
              Colors.grey[100]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main Content
              CustomScrollView(
                slivers: [
                  // App Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Animated Logo
                          TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 800),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, double value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.orange, Colors.green],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.savings_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              );
                            },
                          ),

                          TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 800),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, double value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black,
                                        Colors.black.withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: const [
                                      // Icon(
                                      //   Icons.star,
                                      //   color: Colors.amber,
                                      //   size: 16,
                                      // ),
                                      // SizedBox(width: 8),
                                      Text(
                                        'Money Goal',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                       
                       
                          // Premium Button
                          // TweenAnimationBuilder(
                          //   duration: const Duration(milliseconds: 800),
                          //   tween: Tween<double>(begin: 0, end: 1),
                          //   builder: (context, double value, child) {
                          //     return Transform.scale(
                          //       scale: value,
                          //       child: Container(
                          //         padding: const EdgeInsets.symmetric(
                          //           horizontal: 16,
                          //           vertical: 12,
                          //         ),
                          //         decoration: BoxDecoration(
                          //           gradient: LinearGradient(
                          //             colors: [
                          //               Colors.black,
                          //               Colors.black.withOpacity(0.8),
                          //             ],
                          //           ),
                          //           borderRadius: BorderRadius.circular(20),
                          //           boxShadow: [
                          //             BoxShadow(
                          //               color: Colors.black.withOpacity(0.2),
                          //               blurRadius: 10,
                          //               offset: const Offset(0, 4),
                          //             ),
                          //           ],
                          //         ),
                          //         child: Row(
                          //           children: const [
                          //             Icon(
                          //               Icons.star,
                          //               color: Colors.amber,
                          //               size: 16,
                          //             ),
                          //             SizedBox(width: 8),
                          //             Text(
                          //               'Mani Premium',
                          //               style: TextStyle(
                          //                 color: Colors.white,
                          //                 fontWeight: FontWeight.w600,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),
                       
                       
                       
                        ],
                      ),
                    ),
                  ),

                  // Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 800),
                            tween: Tween<double>(begin: -50, end: 0),
                            builder: (context, double value, child) {
                              return Transform.translate(
                                offset: Offset(value, 0),
                                child: const Text(
                                  'My Savings',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildSortButton(),
                        ],
                      ),
                    ),
                  ),

                  // Savings Card
                  SliverToBoxAdapter(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ValueListenableBuilder(
                            valueListenable: _dbHelper.goalsBox.listenable(),
                            builder: (context, Box<GoalModel> box, _) {
                              final items = box.values.toList();
                              final sortedItems = _sortGoals(items);

                              return Column(
                                children: List.generate(items.length, (index) {
                                  final item = items[index];
                                  final goalKey = box.keyAt(index);
                                  return _buildSavingsCard(context,
                                      goal: item, index: goalKey);
                                }),
                              );
                            })),
                  ),

                  
                ],
              ),

             

              // Add Goal Button
              Positioned(
                left: 0,
                right: 0,
                bottom: 16,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildAddGoalButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 350,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Column(
                      children: [
                        Row(
                         children: [
                            Text(
                              'Sort by',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                 setState(() {
                              selectedSortOption = 'Date';
                            });
                            Navigator.pop(context);
                              },
                              icon: Icon(Icons.close),
                            ),
                         ],
                        ),
                        ListTile(
                          title: const Text('Progress',
                           style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),),
                          trailing: selectedSortOption == 'Progress'
                              ? Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : const SizedBox.shrink(),
                          onTap: () {
                            setState(() {
                              selectedSortOption = 'Progress';
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Date',
                           style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),),
                          trailing: selectedSortOption == 'Date'
                              ? Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : const SizedBox.shrink(),
                          onTap: () {
                            setState(() {
                              selectedSortOption = 'Date';
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Alphabet',
                           style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),),
                          trailing: selectedSortOption == 'Alphabet'
                              ? Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : const SizedBox.shrink(),
                          onTap: () {
                            setState(() {
                              selectedSortOption = 'Alphabet';
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: const [
              Icon(
                Icons.sort,
                color: Colors.black87,
              ),
              SizedBox(width: 4),
              Text(
                'Sort',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavingsCard(BuildContext context,
      {required GoalModel goal, required int index}) {
    // Calculate the progress as a fraction
    double progress = 0.0;
    final _icon = goal.toIconData();

    try {
      double currentBalance = double.parse(goal.currentBalance);
      double targetAmount = double.parse(goal.amount);
      progress = currentBalance / targetAmount;
      print(progress);
      // progress = targetAmount > 0 ? currentBalance / targetAmount : 0.0;
    } catch (e) {
      print("Error parsing values: $e");
    }

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 50, end: 0),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LossesScreen(
                          goal: goal,
                        )),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green.shade400,
                                  Colors.green.shade600,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              _icon,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            goal.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '₹${goal.currentBalance}',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: ' / ₹${goal.amount}',
                              style: TextStyle(
                                color: Colors.green.shade600,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: progress, //_progressAnimation.value,
                                  backgroundColor: Colors.grey[100],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.green.shade400,
                                  ),
                                  minHeight: 8,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${(progress * 100).toStringAsFixed(0)}%',
                                  // '${(_progressAnimation.value * 100).toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    color: Colors.green.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddGoalButton() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 100, end: 0),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.black.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddSavingGoalScreen(),
                      ));
                },
                borderRadius: BorderRadius.circular(30),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Add Goal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
