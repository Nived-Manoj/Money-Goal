import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:money_goal_application/db_functions/db_functions.dart';
import 'package:money_goal_application/model/goal_model.dart';
import 'package:money_goal_application/services/goal_services.dart';
import 'package:money_goal_application/view/home_screen/add_goal/add_goal_icon.dart';

class AddSavingGoalScreen extends StatefulWidget {
  const AddSavingGoalScreen({super.key});

  @override
  State<AddSavingGoalScreen> createState() => _AddSavingGoalScreenState();
}

class _AddSavingGoalScreenState extends State<AddSavingGoalScreen> {
  final TextEditingController _goalNameController = TextEditingController();
  final _goalFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideX(begin: -10, end: 0),
                    const SizedBox(width: 16),
                    Text(
                      'Add Goal',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: -10, end: 0),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What's Your Saving\nGoal?",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                        )
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slideY(begin: 10, end: 0),

                        const SizedBox(height: 32),

                        // Input Field
                        Form(
                          key: _goalFormKey,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _goalNameController,
                              validator: (_){
                                if(_goalNameController.text.trim().isEmpty){
                                  return "This field is required";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Saving Goal Name',
                                hintStyle: TextStyle(color: Colors.grey.shade400),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(20),
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: 20, end: 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: () {
                    if(_goalFormKey.currentState!.validate()){

                     
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SavingsIconSelector(name: _goalNameController.text,),
                        ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 700.ms).slideY(begin: 20, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _goalNameController.dispose();
    super.dispose();
  }
}
