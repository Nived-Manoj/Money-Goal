import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_goal_application/core/animated_navigation.dart';
import 'package:money_goal_application/core/custom_functions.dart';
import 'package:money_goal_application/db_functions/db_helper.dart';
import 'package:money_goal_application/model/goal_model.dart';
import 'package:money_goal_application/model/saving_model.dart';
import 'package:money_goal_application/view/home_screen/add_goal/add_goal_name.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _progressController;
  late AnimationController _slideController;
  late Animation<double> _progressAnimation;
  late Animation<double> _slideAnimation;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 1, vsync: this);

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0, end: 0.08).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<double>(begin: -30, end: 0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _progressController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _slideController.dispose();
    super.dispose();
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
          child: Column(
            children: [
              _buildAppBar(),
              // const SizedBox(height: 16),
              // _buildTabBar(),
              // const SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    _buildTotalSavingsCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              _buildSavingGoalsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.withValues(alpha: 0.8),
                              Colors.green
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
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

                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'Progress',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                // const Spacer(),
                // Container(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 16,
                //     vertical: 12,
                //   ),
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       colors: [Colors.green.shade400, Colors.green.shade600],
                //     ),
                //     borderRadius: BorderRadius.circular(12),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.green.withOpacity(0.3),
                //         blurRadius: 8,
                //         offset: const Offset(0, 4),
                //       ),
                //     ],
                //   ),
                //   child: Row(
                //     children: const [
                //       Icon(Icons.signal_cellular_alt,
                //           size: 16, color: Colors.white),
                //       SizedBox(width: 6),
                //       Text(
                //         '92%',
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 14,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('🐷', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Text(
              'All Savings',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // TabBar(
      //   controller: _tabController,
      //   indicator: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(16),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.1),
      //         blurRadius: 8,
      //         offset: const Offset(0, 4),
      //       ),
      //     ],
      //   ),
      //   labelColor: Colors.black,
      //   unselectedLabelColor: Colors.grey,
      //   tabs: [
      //     Tab(
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: const [
      //           Text('🐷', style: TextStyle(fontSize: 20)),
      //           SizedBox(width: 8),
      //           Text(
      //             'All Savings',
      //             style: TextStyle(
      //               fontSize: 14,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     // Tab(
      //     //   child: Row(
      //     //     mainAxisAlignment: MainAxisAlignment.center,
      //     //     children: const [
      //     //       Text('📈', style: TextStyle(fontSize: 20)),
      //     //       SizedBox(width: 8),
      //     //       Text(
      //     //         'Losses',
      //     //         style: TextStyle(
      //     //           fontSize: 14,
      //     //           fontWeight: FontWeight.bold,
      //     //         ),
      //     //       ),
      //     //     ],
      //     //   ),
      //     // ),
      //   ],
      // ),
    );
  }

  Widget _buildAllSavingsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildTotalSavingsCard(),
        const SizedBox(height: 20),
        _buildSavingGoalsCard(),
      ],
    );
  }

  Widget _buildLossesTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildTotalSavingsCard(),
        const SizedBox(height: 20),
        _buildSavingGoalsCard(showOnlyLosses: true),
      ],
    );
  }

  Widget _buildTotalSavingsCard() {
    final Map<String, Map<String, dynamic>> currencies = {
      'INR': {'flag': '🇮🇳', 'symbol': '₹', 'name': 'Indian Rupee'},
      'USD': {'flag': '🇺🇸', 'symbol': '\$', 'name': 'US Dollar'},
      'EUR': {'flag': '🇪🇺', 'symbol': '€', 'name': 'Euro'},
      'GBP': {'flag': '🇬🇧', 'symbol': '£', 'name': 'British Pound'},
    };

    return ValueListenableBuilder(
      valueListenable: _dbHelper.goalsBox.listenable(),
      builder: (context, Box<GoalModel> box, _) {
        final items = box.values.toList();

        // Group savings by currency
        final Map<String, double> totalSavingsByCurrency = {};

        for (var element in items) {
          try {
            final currentBalance = double.parse(element.currentBalance);
            final currency =
                element.currency ?? 'INR'; // Default to INR if null

            totalSavingsByCurrency.update(
                currency, (value) => value + currentBalance,
                ifAbsent: () => currentBalance);
          } catch (e) {
            continue;
          }
        }

        return AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_slideAnimation.value, 0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    // color: Colors.green,
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade400,
                        Colors.green.shade600,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Savings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: totalSavingsByCurrency.entries.map((entry) {
                          final currencyCode = entry.key;
                          final currencyData = currencies[currencyCode] ??
                              {
                                'flag': '🏳',
                                'symbol': '',
                                'name': currencyCode
                              };

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white
                                                .withValues(alpha: 0.3)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            currencyData['flag'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currencyCode,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          currencyData["name"],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  '${currencyData['symbol']}${entry.value.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
              // .animate().fadeIn(duration: 800.ms).slideX(begin: -0.8, end: 0);
            });
      },
    );
  }

  Widget _buildSavingGoalsCard({bool showOnlyLosses = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [Colors.white, Colors.grey[50]!],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            // borderRadius: BorderRadius.circular(24),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.05),
            //     blurRadius: 10,
            //     offset: const Offset(0, 4),
            //   ),
            // ],
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saving Goals',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        AnimatedNavigation()
                            .fadeAnimation(AddSavingGoalScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green.withValues(alpha: 0.3)
                        // color: const Color.fromARGB(255, 171, 244, 173).withValues(alpha: 0.7)
                        ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Add new",
                            style: TextStyle(fontSize: 12, color: Colors.green),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder(
                valueListenable: _dbHelper.goalsBox.listenable(),
                builder: (context, Box<GoalModel> box, _) {
                  final items = box.values.toList();

                  if (items.isEmpty) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "No goals added yet!",
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: List.generate(items.length, (index) {
                      final item = items[index];
                      final goalKey = box.keyAt(index);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: _buildGoalItem(goal: item),
                      );
                    }),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem({required GoalModel goal}) {
    final Map<String, Map<String, dynamic>> currencies = {
      'INR': {'flag': '🇮🇳', 'symbol': '₹', 'name': 'Indian Rupee'},
      'USD': {'flag': '🇺🇸', 'symbol': '\$', 'name': 'US Dollar'},
      'EUR': {'flag': '🇪🇺', 'symbol': '€', 'name': 'Euro'},
      'GBP': {'flag': '🇬🇧', 'symbol': '£', 'name': 'British Pound'},
    };
    final _icon = goal.toIconData();
    double progress = 0.0;
    try {
      double currentBalance = double.parse(goal.currentBalance);
      double targetAmount = double.parse(goal.amount);
      progress = currentBalance / targetAmount;
      print(progress);
      // progress = targetAmount > 0 ? currentBalance / targetAmount : 0.0;
    } catch (e) {
      print("Error parsing values: $e");
    }

    final symbol = currencies[goal.currency ?? 'INR']?['symbol'] ?? '';

    return InkWell(
      onTap: () {
        _showGraphBottomSheet(context, goal);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 225, 224, 224),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CustomFunctions().toSentenceCase(goal.name),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.green.shade400,
                                ),
                                minHeight: 4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(progress * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: Colors.green.shade600,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${symbol}${goal.currentBalance}',
                      style: TextStyle(
                        color: Colors.green.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' / ₹${goal.amount}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.8, end: 0),
    );
  }

  void _showGraphBottomSheet(BuildContext context, GoalModel goal) {
    final _transactions = _dbHelper.getSavingsNotifier(goal.id.toString());
    List<SavingModel> transactions = goal.savings ?? [];

    List<FlSpot> transactionsDoneSpots = [];
    List<FlSpot> savingsSpots = [];
    List<FlSpot> withdrawalsSpots = [];

    double minY = 500;
    double maxY = 500;

    for (int i = 0; i < transactions.length; i++) {
      final amount = double.parse(transactions[i].savingAmount.toString());

      minY = min(minY, amount);
      maxY = max(maxY, amount);

      transactionsDoneSpots.add(FlSpot(i.toDouble(), amount));

      if (transactions[i].isWithdraw == false) {
        savingsSpots.add(FlSpot(i.toDouble(), amount));
      } else {
        withdrawalsSpots.add(FlSpot(i.toDouble(), amount));
      }
    }

    minY = (minY / 500).floor() * 500;
    maxY = (maxY / 500).ceil() * 500;

    if (minY == maxY) {
      maxY += 500;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transaction History',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem('All Transactions', Colors.blue),
                  const SizedBox(width: 10),
                  _buildLegendItem('Savings', Colors.green),
                  const SizedBox(width: 10),
                  _buildLegendItem('Withdrawals', Colors.red),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 16),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 500,
                        verticalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.2),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.2),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 500,
                            reservedSize: 42,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${goal.currency} ${value.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: Color(0xFF606060),
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= transactions.length)
                                return const Text('');
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '${value.toInt() + 1}',
                                  style: const TextStyle(
                                    color: Color(0xFF606060),
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                            color: const Color(0xFF37434D), width: 1),
                      ),
                      minX: -0.5,
                      maxX: transactions.length - 0.5,
                      minY: minY,
                      maxY: maxY,
                      lineBarsData: [
                        _createLineChartBarData(
                            transactionsDoneSpots, Colors.blue),
                        _createLineChartBarData(savingsSpots, Colors.green),
                        _createLineChartBarData(withdrawalsSpots, Colors.red),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// Function to create chart bar data
  LineChartBarData _createLineChartBarData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(show: false),
    );
  }

// Function to build legend items
  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: Color(0xFF2D3748)),
        ),
      ],
    );
  }
}
