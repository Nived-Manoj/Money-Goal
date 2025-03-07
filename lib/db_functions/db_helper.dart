import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:money_goal_application/model/goal_model.dart';
import 'package:money_goal_application/model/saving_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  ValueNotifier<List<GoalModel>> goalsNotifier = ValueNotifier([]);
  ValueNotifier<List<SavingModel>> savingListsNotifier = ValueNotifier([]);
  Box<GoalModel> get goalsBox => Hive.box<GoalModel>('goals');

  // Add a new goal
  Future<void> addGoal(GoalModel goal) async {
    final key = await goalsBox.add(goal); // Get the auto-generated key
    goal.id = key.toString(); // Set the id field
    // await goalsBox.add(goal);
    await goalsBox.put(key, goal);
    _refreshGoals();
  }

  // Get all goals
  List<GoalModel> getGoals() {
    return goalsBox.values.toList();
  }

Future<void> updateGoal(GoalModel goal) async {
  final goalsBox = Hive.box<GoalModel>('goals');

  if (goal.key != null && goalsBox.containsKey(goal.key)) {
    await goalsBox.put(goal.key, goal); // Update the existing goal
  } else {
    throw HiveError("Goal not found in Hive box.");
  }
}


  // Delete a goal
  Future<void> deleteGoal(GoalModel goal, BuildContext context) async {
    await goal.delete().then((_) {
      Fluttertoast.showToast(
    msg: "Goal deleted successfully",
    toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
    gravity: ToastGravity.BOTTOM, // Position of the toast
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 16.0,
  );
      
    });
  }

  // Add a saving transaction to a goal
  Future<void> addSaving(String goalId, SavingModel saving) async {
    try {
      final goal = goalsBox.values.firstWhere(
        (goal) => goal.id == goalId,
        orElse: () => throw Exception("Goal not found"),
      );

      goal.savings ??= [];
      goal.savings!.add(saving);

      goal.currentBalance = (double.parse(goal.currentBalance) +
              double.parse(saving.savingAmount!))
          .toString();

      await goal.save();
      _refreshSavings(goalId);
    } catch (e) {
      print("Error adding saving: $e");
    }
  }

  // Add a withdrawal transaction to a goal
  Future<void> addWithdrawal(String goalId, SavingModel withdrawal) async {
    final goal = goalsBox.values.firstWhere((goal) => goal.id == goalId);
    goal.savings ??= [];
    goal.savings!.add(withdrawal);
    goal.currentBalance = (double.parse(goal.currentBalance) -
            double.parse(withdrawal.savingAmount!))
        .toString();
    await goal.save();
  }

  // // Get all savings for a specific goal
  // List<SavingModel> getSavings(String goalId) {
  //   final goal = goalsBox.values.firstWhere((goal) => goal.id == goalId);
  //   return goal.savings ?? [];
  // }

  // Get all savings for a specific goal
  List<SavingModel> getSavings(String goalId) {
    final goal = goalsBox.values.firstWhere((goal) => goal.id == goalId);
    return goal.savings ?? [];
  }

  ValueNotifier<List<SavingModel>> getSavingsNotifier(String goalId) {
    _refreshSavings(goalId); // Refresh the savings list
    return savingListsNotifier;
  }

  void _refreshGoals() {
    goalsNotifier.value = goalsBox.values.toList();
    goalsNotifier.notifyListeners();
  }

  void _refreshSavings(String goalId) {
    final goal = goalsBox.values.firstWhere((goal) => goal.id == goalId);
    savingListsNotifier.value = goal.savings ?? [];
    savingListsNotifier.notifyListeners();
  }
}
