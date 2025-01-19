import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:money_goal_application/services/api_lists.dart';


class GoalServices {

  static Future<bool?> createGoal({
    required String goalName,
    required String currency,
    required String amount,
     String? image,
    required String targetDate,
    required String currentBalance
  }) async{
    try {
      final url = Uri.parse(ApiLists.goal);
      final response = await http.post(url,
      body: jsonEncode({
        "name": "aaaa",
        "currency": currency,
        "amount": amount,
        "current_balance": currentBalance,
        "target_date": targetDate
      }),
      headers: {
        "Content-Type": "application/json",
      }
      );

      print(response.statusCode);
      print(response.body);
      if(response.statusCode == 201){
        return true;
      }else{
        return false;
      }
    } catch (e) {
      print("error : $e");
      return null;
    }
  }


  // static Future<>
}