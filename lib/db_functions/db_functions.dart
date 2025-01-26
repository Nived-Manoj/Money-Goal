import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_goal_application/model/goal_model.dart';

ValueNotifier<List<GoalModel>> goalListsNotifier = ValueNotifier([]);

  Future<void> addItem(GoalModel item) async{
  // goalListsNotifier.value.add(item);
  final goalBox = await Hive.openBox<GoalModel>("goalBox");
 await  goalBox.add(item);

getAllGoalBox();
  goalListsNotifier.notifyListeners();

}



Future<void>  getAllGoalBox() async{
 final goalBox = await Hive.openBox<GoalModel>("goalBox");
 goalListsNotifier.value.clear();
 goalListsNotifier.value.addAll(goalBox.values);
 goalListsNotifier.notifyListeners();
   print(goalListsNotifier.value);

}