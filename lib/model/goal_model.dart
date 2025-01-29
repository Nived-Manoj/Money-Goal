
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_goal_application/model/saving_model.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 0) 
class GoalModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String currency;

  @HiveField(2)
  final String amount;

  @HiveField(3)
  final String currentBalance;

  @HiveField(4)
  final DateTime targetDate;

  @HiveField(5)
  final int iconCodePoint; 

  @HiveField(6)
  final String? iconFontFamily; 

  @HiveField(7)
  final List<SavingModel>? savings;

  @HiveField(8)
   String? id;

  GoalModel({
    required this.name,
    required this.currency,
    required this.amount,
    required this.currentBalance,
    required this.targetDate,
    required this.iconCodePoint,
    this.iconFontFamily,
    this.savings,
    this.id
  });

  // Helper method to convert IconData to GoalModel.
  static GoalModel fromIconData({
    required String name,
    required String currency,
    required String amount,
    required String currentBalance,
    required DateTime targetDate,
    required IconData icon,
    List<SavingModel>? savings,
     String? id,
  }) {
    return GoalModel(
      name: name,
      currency: currency,
      amount: amount,
      currentBalance: currentBalance,
      targetDate: targetDate,
      iconCodePoint: icon.codePoint,
      iconFontFamily: icon.fontFamily,
      savings: savings,
      id: id
    );
  }

  // Helper method to reconstruct IconData.
  IconData toIconData() {
    return IconData(iconCodePoint, fontFamily: iconFontFamily);
  }
}
