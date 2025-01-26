import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:money_goal_application/model/goal_model.dart';
import 'package:money_goal_application/services/api_lists.dart';


class GoalServices {
  late Box<GoalModel>  goalBox;

  Future<void>  openGoalBox()  async{
    goalBox = await Hive.openBox<GoalModel>("goalBox");
  }

//   void addItem(GoalModel item) {
//   goalBox.add(item);
// }

// void addItems(List<GoalModel> items) {
//   goalBox.addAll(items);
// }

// List<GoalModel> getItems() {
//   return goalBox.values.toList();
// }

// void deleteItem(int index) {
//   goalBox.deleteAt(index);
// }

// void updateItem(int index, GoalModel updatedItem) {
//   goalBox.putAt(index, updatedItem);
// }









}