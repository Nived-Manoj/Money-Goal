import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_goal_application/db_functions/db_helper.dart';
import 'package:money_goal_application/model/goal_model.dart';
import 'package:money_goal_application/view/home_screen/detail_screen.dart';

class AchievedGoal extends StatefulWidget {
  const AchievedGoal({Key? key}) : super(key: key);

  @override
  _AchievedGoalState createState() => _AchievedGoalState();
}

class _AchievedGoalState extends State<AchievedGoal>
    with TickerProviderStateMixin {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Animation<double> _slideAnimation;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
   
     _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
     _slideAnimation = Tween<double>(begin: -30, end: 0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

     _slideController.forward();
  }

  List<GoalModel> _getAchievedGoals(List<GoalModel> goals) {
    return goals.where((goal) {
      double progress =
          double.parse(goal.currentBalance) / double.parse(goal.amount);
      return progress >= 1.0; // 100% or more
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildAppBar(),
           Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ValueListenableBuilder(
                      valueListenable: _dbHelper.goalsBox.listenable(),
                      builder: (context, Box<GoalModel> box, _) {
                        final items = box.values.toList();
                        final achievedGoals =
                            _getAchievedGoals(items); // Filter achieved goals
            
                        if (achievedGoals.isEmpty) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: double.infinity,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.savings_outlined,
                                size: 32,
                                color: Colors.grey,),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                'No goals achieved yet!',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              ],
                            ),
                          );
                        }
            
                        return Column(
                          children: List.generate(achievedGoals.length, (index) {
                            final item = achievedGoals[index];
                            final goalKey = box.keyAt(index);
                            return _buildSavingsCard(context,
                                goal: item, index: goalKey);
                          }),
                        );
                      })),
            
          
        ],
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
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.grey.shade50,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade100.withOpacity(0.5),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background Progress Indicator
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.green.shade50,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.green.shade300.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row with Icon and Goal Name
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
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.green.shade200.withOpacity(0.5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _icon,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                goal.name,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green.shade900,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Balance Information
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '₹${goal.currentBalance}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 26,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: ' / ₹${goal.amount}',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.green.shade500,
                            ),
                            minHeight: 10,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Progress Percentage
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${(progress * 100).toStringAsFixed(0)}% Complete',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child:  Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back, size: 30,)),
               const SizedBox(width: 20,),
               const  Text(
                  'Achieved Goals',
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
}
