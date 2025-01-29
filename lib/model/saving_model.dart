

import 'package:hive_flutter/hive_flutter.dart';
part 'saving_model.g.dart';
@HiveType(typeId: 1)
class SavingModel extends HiveObject{
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? savingAmount;

  @HiveField(2)
  String? transactionDate;

  @HiveField(3)
  String? description;

  @HiveField(4)
   String? goalId;


  SavingModel({
    this.description,
    this.id,
    this.savingAmount,
    this.transactionDate,
     this.goalId
    
  });
}