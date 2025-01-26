// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

// part 'goal_model.g.dart';

// @HiveType(typeId: 0) // Assign a unique typeId for this model.
// class GoalModel extends HiveObject {
//   @HiveField(0)
//   final String name;

//   @HiveField(1)
//   final String currency;

//   @HiveField(2)
//   final String amount;

//   @HiveField(3)
//   final String currentBalance;

//   @HiveField(4)
//   final String targetDate;

//    @HiveField(5)
//   final IconData image;

//   GoalModel({
//     required this.name,
//     required this.currency,
//     required this.amount,
//     required this.currentBalance,
//     required this.targetDate,
//     required this.image
//   });

 
// }


import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 0) // Assign a unique typeId for this model.
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
  final String targetDate;

  @HiveField(5)
  final int iconCodePoint; // Store the codePoint of IconData.

  @HiveField(6)
  final String? iconFontFamily; // Store the fontFamily of IconData.

  GoalModel({
    required this.name,
    required this.currency,
    required this.amount,
    required this.currentBalance,
    required this.targetDate,
    required this.iconCodePoint,
    this.iconFontFamily,
  });

  // Helper method to convert IconData to GoalModel.
  static GoalModel fromIconData({
    required String name,
    required String currency,
    required String amount,
    required String currentBalance,
    required String targetDate,
    required IconData icon,
  }) {
    return GoalModel(
      name: name,
      currency: currency,
      amount: amount,
      currentBalance: currentBalance,
      targetDate: targetDate,
      iconCodePoint: icon.codePoint,
      iconFontFamily: icon.fontFamily,
    );
  }

  // Helper method to reconstruct IconData.
  IconData toIconData() {
    return IconData(iconCodePoint, fontFamily: iconFontFamily);
  }
}
