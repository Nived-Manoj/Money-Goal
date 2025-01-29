// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:money_goal_application/model/goal_model.dart';

// ValueNotifier<List<GoalModel>> goalListsNotifier = ValueNotifier([]);

//   Future<void> addItem(GoalModel item) async{
//   // goalListsNotifier.value.add(item);
//   final goalBox = await Hive.openBox<GoalModel>("goalBox");
//  await  goalBox.add(item);

// getAllGoalBox();
//   goalListsNotifier.notifyListeners();

// }

// Future<void>  getAllGoalBox() async{
//  final goalBox = await Hive.openBox<GoalModel>("goalBox");
//  goalListsNotifier.value.clear();
//  goalListsNotifier.value.addAll(goalBox.values);
//  goalListsNotifier.notifyListeners();
//    print(goalListsNotifier.value);

// }

// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:money_goal_application/model/goal_model.dart';
// import 'package:money_goal_application/model/saving_model.dart';

// ValueNotifier<List<GoalModel>> goalListsNotifier = ValueNotifier([]);

// Future<void> addItem(GoalModel item) async {
//   final goalBox = await Hive.openBox<GoalModel>("goalBox");
//   await goalBox.add(item);
//   getAllGoalBox();
//   goalListsNotifier.notifyListeners();
// }

// Future<void> getAllGoalBox() async {
//   final goalBox = await Hive.openBox<GoalModel>("goalBox");
//   goalListsNotifier.value.clear();
//   goalListsNotifier.value.addAll(goalBox.values);
//   goalListsNotifier.notifyListeners();
// }

// Future<void> addSavingToGoal(String goalId, SavingModel saving) async {

//   final goalBox = await Hive.openBox<GoalModel>("goalBox");
//   final goalIndex = goalBox.values.toList().indexWhere((goal) => goal.id == goalId);

//   print("uuuuuuuuuuuuuuuuu ${goalIndex},  $goalId");

//   if (goalIndex != -1) {
//     GoalModel goal = goalBox.getAt(goalIndex)!;
//     List<SavingModel> updatedSavings = List.from(goal.savings ?? [])..add(saving);

//     // Update current balance
//     double updatedBalance = double.parse(goal.currentBalance) + double.parse(saving.savingAmount.toString());

//     GoalModel updatedGoal = GoalModel(
//       name: goal.name,
//       currency: goal.currency,
//       amount: goal.amount,
//       currentBalance: updatedBalance.toString(),
//       targetDate: goal.targetDate,
//       iconCodePoint: goal.iconCodePoint,
//       iconFontFamily: goal.iconFontFamily,
//       savings: updatedSavings,
//       id: goal.id,
//     );

//     print(updatedGoal.savings!.length.toString());

//     await goalBox.putAt(goalIndex, updatedGoal);
//     getAllGoalBox();
//   }
// }

// Future<void> updateGoalBalance(String goalId, double amount, bool isAddition) async {
//   final goalBox = await Hive.openBox<GoalModel>("goalBox");
//   final goalIndex = goalBox.values.toList().indexWhere((goal) => goal.id == goalId);

//   if (goalIndex != -1) {
//     GoalModel goal = goalBox.getAt(goalIndex)!;
//     double updatedBalance = double.parse(goal.currentBalance);

//     if (isAddition) {
//       updatedBalance += amount;
//     } else {
//       updatedBalance -= amount;
//     }

//     GoalModel updatedGoal = GoalModel(
//       name: goal.name,
//       currency: goal.currency,
//       amount: goal.amount,
//       currentBalance: updatedBalance.toString(),
//       targetDate: goal.targetDate,
//       iconCodePoint: goal.iconCodePoint,
//       iconFontFamily: goal.iconFontFamily,
//       savings: goal.savings,
//       id: goal.id,
//     );

//     await goalBox.putAt(goalIndex, updatedGoal);
//     getAllGoalBox();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:money_goal_application/model/goal_model.dart';
// import 'package:money_goal_application/model/saving_model.dart';

// ValueNotifier<List<GoalModel>> goalListsNotifier = ValueNotifier([]);

// ValueNotifier<List<SavingModel>> savingListsNotifier = ValueNotifier([]);
// Future<void> addItem(GoalModel item) async {
//   final goalBox = await Hive.openBox<GoalModel>("goalBox");
//   final int id = await goalBox.add(item); // Hive generates an int key

//   print("Added goal with ID: $id");

//   item.id = id.toString(); // Store ID as String in the model

//   await updateGoalBox(id: id.toString(), updatedGoal: item);
//   await getAllGoalBox();
//   goalListsNotifier.notifyListeners();
// }

// Future<void> getAllGoalBox() async {
//   final goalBox = await Hive.openBox<GoalModel>("goalBox");
//   goalListsNotifier.value.clear();
//   goalListsNotifier.value.addAll(goalBox.values);
//   goalListsNotifier.notifyListeners();
//   print(goalListsNotifier.value);
// }

// // Fetch All Saving Items
// Future<void> getAllSavingModel() async {
//   final savingBox = await Hive.openBox<SavingModel>("savingBox"); // Corrected
//   savingListsNotifier.value = savingBox.values.toList();
//   savingListsNotifier.notifyListeners();
// }

// Future<bool?> updateGoalBox(
//     {required String id, required GoalModel updatedGoal}) async {
//   print("Updating goal with ID: $id");

//   final goalBox = await Hive.openBox<GoalModel>("goalBox");

//   try {
//     int? key = int.tryParse(id); // Convert String to int
//     if (key != null && goalBox.containsKey(key)) {
//       await goalBox.put(key, updatedGoal);
//     await  getAllGoalBox();
//       return true;
//     } else {
//       print("Error: Key not found in Hive");
//       return false;
//     }
//   } catch (e) {
//     print("Update error: $e");
//     return null;
//   }

// }

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_goal_application/model/goal_model.dart';
import 'package:money_goal_application/model/saving_model.dart';

// Value notifiers for state management
ValueNotifier<List<GoalModel>> goalListsNotifier = ValueNotifier([]);
ValueNotifier<List<SavingModel>> savingListsNotifier = ValueNotifier([]);

ValueNotifier<List<SavingModel>> savingNotifier = ValueNotifier([]);

// Goal Functions
Future<void> addGoal(GoalModel item) async {
  final goalBox = await Hive.openBox<GoalModel>("goalBox");
  final int id = await goalBox.add(item);
  print("Added goal with ID: $id");
  item.id = id.toString();
  await updateGoalBox(id: id.toString(), updatedGoal: item);
  getAllGoal();
  addSavings(goalId: id.toString(), saving: SavingModel(
    description: "Current balance while adding", goalId: id.toString(), savingAmount: item.currentBalance, transactionDate: item.targetDate.toString()
  ));
  await getAllGoalBox(id.toString());
  goalListsNotifier.notifyListeners();
}

Future<void> addSavings(
    {required String goalId, required SavingModel saving}) async {
  final saveBox = await Hive.openBox<SavingModel>("saveBox");
  final int id = await saveBox.add(saving);
  print("Added goal with ID: $id");
  saving.id = id.toString();
  await saveBox.put(
      id,
      SavingModel(
          description: saving.description,
          goalId: goalId,
          id: id.toString(),
          savingAmount: saving.savingAmount,
          transactionDate: saving.transactionDate));
  getAllSavings();
  goalListsNotifier.notifyListeners();
}

Future<void> getAllSavings() async {
  final saveBox = await Hive.openBox<SavingModel>("saveBox");
  savingListsNotifier.value.clear();
  savingListsNotifier.value.addAll(saveBox.values);

  savingListsNotifier.notifyListeners();
  print("Goals in box: ${goalListsNotifier.value.length}");
}

Future<void> getAllGoal() async {
  final goalBox = await Hive.openBox<GoalModel>("goalBox");
  goalListsNotifier.value.clear();
  goalListsNotifier.value.addAll(goalBox.values);

  goalListsNotifier.notifyListeners();
  print("Goals in box: ${goalListsNotifier.value.length}");
}

Future<void> getAllGoalBox(String id) async {
  final goalBox = await Hive.openBox<GoalModel>("goalBox");
  goalListsNotifier.value.clear();
  goalListsNotifier.value.addAll(goalBox.values);

  try {
    // Find the goal with the given id
    final goal = goalBox.values.firstWhere(
      (goal) => goal.id == id,
    );

    // Update the saving list with the savings of the selected goal
    savingNotifier.value.clear();
    savingNotifier.value.addAll(goal.savings ?? []);

    goalListsNotifier.notifyListeners();
    savingNotifier.notifyListeners();
    print("Goals in box: ${goalListsNotifier.value.length}");
  } catch (e) {
    print("Goal not found for id: $id");
    savingNotifier.value.clear();
    savingNotifier.notifyListeners();
  }
}

Future<bool> updateGoalBox({
  required String id,
  required GoalModel updatedGoal,
}) async {
  print("Updating goal with ID: $id");
  final goalBox = await Hive.openBox<GoalModel>("goalBox");
  try {
    int? key = int.tryParse(id);
    if (key != null && goalBox.containsKey(key)) {
      await goalBox.put(key, updatedGoal); // Use key instead of id
      await getAllGoalBox(key.toString());
      return true;
    } else {
      print("Error: Key not found in Hive");
      return false;
    }
  } catch (e) {
    print("Update goal error: $e");
    return false;
  }
}

Future<bool> deleteGoal(String id) async {
  try {
    final goalBox = await Hive.openBox<GoalModel>("goalBox");
    int? key = int.tryParse(id);
    if (key != null) {
      // First delete all associated savings
      final savingBox = await Hive.openBox<SavingModel>("savingBox");
      final savingsToDelete =
          savingBox.values.where((saving) => saving.id == id).toList();
      for (var saving in savingsToDelete) {
        if (saving.id != null) {
          int? savingKey = int.tryParse(saving.id!);
          if (savingKey != null) {
            await savingBox.delete(savingKey);
          }
        }
      }

      await goalBox.delete(key);
      await getAllGoalBox(key.toString());
      // await getSavingsForGoal(id);
      return true;
    }
    return false;
  } catch (e) {
    print("Delete goal error: $e");
    return false;
  }
}

Future<void> addSaving(SavingModel saving) async {
  final savingBox = await Hive.openBox<SavingModel>("savingBox");
  try {
    // First verify that the goal exists before adding the saving
    final goalBox = await Hive.openBox<GoalModel>("goalBox");
    final goal = goalBox.values.firstWhere(
      (goal) => goal.id == saving.id,
      orElse: () => throw Exception('Goal not found'), // Better error handling
    );

    // Add the saving first
    final savingId = await savingBox.add(saving);
    saving.id = savingId.toString(); // Save the generated saving ID

    // Calculate new balance
    double currentBalance = double.tryParse(goal.currentBalance) ?? 0;
    double savingAmount = double.tryParse(saving.savingAmount ?? '0') ?? 0;
    double newBalance = currentBalance + savingAmount;

    // Add the new saving to the existing savings list
    List<SavingModel> updatedSavings = List.from(goal.savings ?? [])
      ..add(saving);

    // Create updated goal with new balance and savings
    final updatedGoal = GoalModel(
      id: goal.id,
      name: goal.name,
      currency: goal.currency,
      amount: goal.amount,
      currentBalance: newBalance.toString(),
      targetDate: goal.targetDate,
      iconCodePoint: goal.iconCodePoint,
      iconFontFamily: goal.iconFontFamily,
      savings: updatedSavings,
    );

    // Update the goal in the box without duplicating it
    await goalBox.put(goal.id, updatedGoal);

    // Refresh data or perform any necessary UI updates
    await getSavingsForGoal(goal.id.toString());
  } catch (e) {
    print("Add saving error: $e");
    // Rethrow the error so the UI can handle it
    rethrow;
  }
}

// Future<void> addSaving(SavingModel saving) async {
//   final savingBox = await Hive.openBox<SavingModel>("savingBox");
//   try {
//     // First verify that the goal exists before adding the saving
//     final goalBox = await Hive.openBox<GoalModel>("goalBox");
//     final goal = goalBox.values.firstWhere(
//       (goal) => goal.id == saving.id,
//       orElse: () => throw Exception('Goal not found'),  // Better error handling
//     );

//     // Add the saving first
//     final int savingId = await savingBox.add(saving);
//     saving.id = savingId.toString();

//     // Calculate new balance
//     double currentBalance = double.tryParse(goal.currentBalance) ?? 0;
//     double savingAmount = double.tryParse(saving.savingAmount ?? '0') ?? 0;
//     double newBalance = currentBalance + savingAmount;

//     // Create updated goal with new balance and saving
//     final updatedGoal = GoalModel(
//       id: goal.id,
//       name: goal.name,
//       currency: goal.currency,
//       amount: goal.amount,
//       currentBalance: newBalance.toString(),
//       targetDate: goal.targetDate,
//       iconCodePoint: goal.iconCodePoint,
//       iconFontFamily: goal.iconFontFamily,
//       savings: [...(goal.savings ?? []), saving],
//     );
// print("ppppppppppppppppppp ${goal.id}");
//     // Update the goal
//     await goalBox.put(goal.id, updatedGoal);

//     // Refresh data
//     await getAllSavingModel();
//   } catch (e) {
//     print("Add saving error: $e");
//     // Rethrow the error so the UI can handle it
//     rethrow;
//   }
// }

Future<void> getSavingsForGoal(String goalId) async {
  final goalBox = await Hive.openBox<GoalModel>("goalBox");

  // Fetch the goal by its ID
  final goal = goalBox.values.firstWhere(
    (goal) => goal.id == goalId,
    orElse: () => throw Exception('Goal not found'),
  );

  // Get the list of savings for the specific goal
  final savingsList = goal.savings ?? [];

  // Notify listeners with the specific savings list for this goal
  savingListsNotifier.value = savingsList;
  savingListsNotifier.notifyListeners();

  print("Savings for goal: ${goal.name} - ${savingsList.length} savings");
}

// Future<void> getAllSavingModel() async {
//   final savingBox = await Hive.openBox<SavingModel>("savingBox");
//   savingListsNotifier.value = savingBox.values.toList();
//   savingListsNotifier.notifyListeners();
//   print("Savings in box: ${savingListsNotifier.value.length}");
// }

Future<bool> updateSaving(
    {required String id, required SavingModel updatedSaving}) async {
  final savingBox = await Hive.openBox<SavingModel>("savingBox");
  try {
    int? key = int.tryParse(id);
    if (key != null && savingBox.containsKey(key)) {
      final oldSaving = savingBox.get(key);
      await savingBox.put(key, updatedSaving);

      // Update the goal's current balance and total amount
      final goalBox = await Hive.openBox<GoalModel>("goalBox");
      final goal = goalBox.values.firstWhere(
        (goal) => goal.id == updatedSaving.id,
        orElse: () => null as GoalModel,
      );

      if (goal != null) {
        // Calculate the difference between old and new saving amounts
        double oldAmount = oldSaving != null
            ? (double.tryParse(oldSaving.savingAmount ?? '0') ?? 0)
            : 0;
        double newAmount =
            double.tryParse(updatedSaving.savingAmount ?? '0') ?? 0;
        double currentBalance = double.tryParse(goal.currentBalance) ?? 0;
        double totalAmount = double.tryParse(goal.amount) ?? 0;

        double newBalance = currentBalance - oldAmount + newAmount;
        double updatedTotalAmount = totalAmount - oldAmount + newAmount;

        // Update the goal's savings list
        final updatedSavings = goal.savings?.map((saving) {
              if (saving.id == id) {
                return updatedSaving;
              }
              return saving;
            }).toList() ??
            [];

        final updatedGoal = GoalModel(
          id: goal.id,
          name: goal.name,
          currency: goal.currency,
          amount: updatedTotalAmount.toString(), // Updated amount field
          currentBalance: newBalance.toString(), // Updated balance field
          targetDate: goal.targetDate,
          iconCodePoint: goal.iconCodePoint,
          iconFontFamily: goal.iconFontFamily,
          savings: updatedSavings,
        );

        await updateGoalBox(id: goal.id!, updatedGoal: updatedGoal);
      }

      await getSavingsForGoal(goal.id.toString());
      return true;
    }
    return false;
  } catch (e) {
    print("Update saving error: $e");
    return false;
  }
}

// Future<bool> updateSaving({required String id, required SavingModel updatedSaving}) async {
//   final savingBox = await Hive.openBox<SavingModel>("savingBox");
//   try {
//     int? key = int.tryParse(id);
//     if (key != null && savingBox.containsKey(key)) {
//       final oldSaving = savingBox.get(key);
//       await savingBox.put(key, updatedSaving);

//       // Update the goal's current balance
//       final goalBox = await Hive.openBox<GoalModel>("goalBox");
//       final goal = goalBox.values.firstWhere(
//         (goal) => goal.id == updatedSaving.id,
//         orElse: () => null as GoalModel,
//       );

//       if (goal != null) {
//         // Calculate the difference between old and new saving amounts
//         double oldAmount = oldSaving != null ?
//             (double.tryParse(oldSaving.savingAmount ?? '0') ?? 0) : 0;
//         double newAmount = double.tryParse(updatedSaving.savingAmount ?? '0') ?? 0;
//         double currentBalance = double.tryParse(goal.currentBalance) ?? 0;
//         double newBalance = currentBalance - oldAmount + newAmount;

//         // Update the goal's savings list
//         final updatedSavings = goal.savings?.map((saving) {
//           if (saving.id == id) {
//             return updatedSaving;
//           }
//           return saving;
//         }).toList() ?? [];

//         final updatedGoal = GoalModel(
//           id: goal.id,
//           name: goal.name,
//           currency: goal.currency,
//           amount: goal.amount,
//           currentBalance: newBalance.toString(),
//           targetDate: goal.targetDate,
//           iconCodePoint: goal.iconCodePoint,
//           iconFontFamily: goal.iconFontFamily,
//           savings: updatedSavings,
//         );

//         await updateGoalBox(id: goal.id!, updatedGoal: updatedGoal);
//       }

//       await getAllSavingModel();
//       return true;
//     }
//     return false;
//   } catch (e) {
//     print("Update saving error: $e");
//     return false;
//   }
// }

Future<bool> deleteSaving(String id) async {
  try {
    final savingBox = await Hive.openBox<SavingModel>("savingBox");
    int? key = int.tryParse(id);
    if (key != null) {
      final saving = savingBox.get(key);

      if (saving != null) {
        // Update the goal's current balance
        final goalBox = await Hive.openBox<GoalModel>("goalBox");
        final goal = goalBox.values.firstWhere(
          (goal) => goal.id == saving.id,
          orElse: () => null as GoalModel,
        );

        if (goal != null) {
          // Subtract the saving amount from current balance
          double currentBalance = double.tryParse(goal.currentBalance) ?? 0;
          double savingAmount =
              double.tryParse(saving.savingAmount ?? '0') ?? 0;
          double newBalance = currentBalance - savingAmount;

          // Remove the saving from goal's savings list
          final updatedSavings =
              goal.savings?.where((s) => s.id != id).toList() ?? [];

          final updatedGoal = GoalModel(
            id: goal.id,
            name: goal.name,
            currency: goal.currency,
            amount: goal.amount,
            currentBalance: newBalance.toString(),
            targetDate: goal.targetDate,
            iconCodePoint: goal.iconCodePoint,
            iconFontFamily: goal.iconFontFamily,
            savings: updatedSavings,
          );

          await updateGoalBox(id: goal.id!, updatedGoal: updatedGoal);
        }
      }

      await savingBox.delete(key);
      // await getSavingsForGoal();
      return true;
    }
    return false;
  } catch (e) {
    print("Delete saving error: $e");
    return false;
  }
}

// Helper function to format currency
String formatCurrency(String amount) {
  try {
    final value = double.parse(amount);
    return value.toStringAsFixed(2);
  } catch (e) {
    return amount;
  }
}
