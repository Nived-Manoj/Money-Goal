import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_goal_application/model/goal_model.dart';
import 'package:money_goal_application/model/saving_model.dart';
import 'package:money_goal_application/services/goal_services.dart';

import 'package:money_goal_application/view/bottom_nav_bar/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(GoalModelAdapter().typeId)) {
    Hive.registerAdapter(GoalModelAdapter());
  }

  if (!Hive.isAdapterRegistered(SavingModelAdapter().typeId)) {
    Hive.registerAdapter(SavingModelAdapter());
  }
 await Hive.openBox<GoalModel>('goals');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: BottomNav());
  }
}
