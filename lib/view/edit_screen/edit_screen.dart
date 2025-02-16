import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:money_goal_application/core/animated_navigation.dart';
import 'package:money_goal_application/db_functions/db_helper.dart';
import 'package:money_goal_application/model/goal_model.dart';
import 'package:money_goal_application/view/bottom_nav_bar/bottom_nav_bar.dart';

class EditScreen extends StatefulWidget {
  final GoalModel goal;
  const EditScreen({Key? key, required this.goal}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _goalNameController = TextEditingController();
  final TextEditingController _goalAmountController = TextEditingController();
  final _goalFormKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  int? selectedIconIndex;
  DateTime? selectedDate;

  IconData? image;

  String selectedCurrency = 'INR';
  final List<IconData> savingIcons = [
    Icons.add_photo_alternate_outlined,
    Icons.directions_car,
    Icons.flight,
    Icons.shopping_cart,
    Icons.show_chart,
    Icons.attach_money,
    Icons.palette,
    Icons.public,
    Icons.card_giftcard,
    Icons.gamepad,
    Icons.headphones,
  ];
  final Map<String, Map<String, dynamic>> currencies = {
    'INR': {'flag': '🇮🇳', 'symbol': '₹', 'name': 'Indian Rupee'},
    'USD': {'flag': '🇺🇸', 'symbol': '\$', 'name': 'US Dollar'},
    'EUR': {'flag': '🇪🇺', 'symbol': '€', 'name': 'Euro'},
    'GBP': {'flag': '🇬🇧', 'symbol': '£', 'name': 'British Pound'},
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _goalNameController.text = widget.goal.name;
        _goalAmountController.text = widget.goal.amount;
        selectedDate = widget.goal.targetDate;
      });
    });
  }

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Select Currency',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  String currencyCode = currencies.keys.elementAt(index);
                  Map<String, dynamic> currency = currencies[currencyCode]!;
                  return ListTile(
                    leading: Text(
                      currency['flag'],
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(currencyCode),
                    subtitle: Text(currency['name']),
                    trailing: selectedCurrency == currencyCode
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    onTap: () {
                      setState(() => selectedCurrency = currencyCode);
                      Navigator.pop(context);
                    },
                  )
                      .animate()
                      .fadeIn(delay: (50 * index).ms)
                      .slideX(begin: 0.2, end: 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _icon = widget.goal.toIconData();

    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text("Edit Goal"),
          ),
          body: Stack(
            children: [
              Form(
                key: _goalFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 20,
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor:
                              Colors.transparent, // Removes divider lines
                        ),
                        child: ExpansionTile(
                          title: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              spacing: 20,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.green.shade400,
                                        Colors.green.shade600,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    selectedIconIndex != null
                                        ? savingIcons[selectedIconIndex!]
                                        : _icon,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                Text("Goal Icon"),
                              ],
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: 20, end: 0),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          childrenPadding: EdgeInsets.symmetric(horizontal: 15),
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Select an Icon for Your\nSavings',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                )
                                    .animate()
                                    .fadeIn(duration: 500.ms)
                                    .slideX(begin: -10, end: 0),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            SizedBox(
                              height: 500,
                              child: GridView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20,
                                ),
                                itemCount: savingIcons.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                          onTap: () => setState(() {
                                                selectedIconIndex = index;
                                                image = savingIcons[index];
                                              }),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              border: Border.all(
                                                color:
                                                    selectedIconIndex == index
                                                        ? Colors.blue.shade400
                                                        : Colors.grey.shade200,
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.05),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              savingIcons[index],
                                              size: 32,
                                              color: selectedIconIndex == index
                                                  ? Colors.blue.shade400
                                                  : Colors.grey.shade600,
                                            ),
                                          )
                                              .animate(
                                                  target:
                                                      selectedIconIndex == index
                                                          ? 1
                                                          : 0)
                                              .scale(
                                                  begin: Offset(1, 1),
                                                  end: Offset(1.05, 1.05),
                                                  duration: 200.ms)
                                              .shimmer(duration: 200.ms))
                                      .animate()
                                      .fadeIn(
                                          delay: (50 * index).ms,
                                          duration: 200.ms)
                                      .slideY(begin: 20, end: 0);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          spacing: 20,
                          children: [
                            Container(
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
                                validator: (_) {
                                  if (_goalNameController.text.trim().isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Saving Goal Name',
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade400),
                                  label: Text("Goal Name"),
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
                            _buildDetailCard(
                              'Goal Currency',
                              Row(
                                children: [
                                  Text(
                                    currencies[selectedCurrency]!['flag'],
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    selectedCurrency,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                              onTap: _showCurrencyPicker,
                            ),
                            Container(
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
                                controller: _goalAmountController,
                                validator: (_) {
                                  if (_goalAmountController.text
                                      .trim()
                                      .isEmpty) {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Saving Goal Amount',
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade400),
                                  label: Text("Goal Amount"),
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
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat('MMM dd, yyyy').format(
                                          selectedDate ?? DateTime.now()),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          final DateTime? picked =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: selectedDate,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2030),
                                          );
                                          if (picked != null) {
                                            setState(() {});
                                            (() => selectedDate = picked);
                                          }
                                        },
                                        child: Icon(Icons.calendar_today,
                                            color: Colors.black)),
                                  ],
                                )
                                    .animate()
                                    .fadeIn(duration: 600.ms)
                                    .slideY(begin: 20, end: 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_goalFormKey.currentState!.validate()) {
                        final goalsBox = Hive.box<GoalModel>('goals');
                        final existingGoal = goalsBox
                            .get(widget.goal.key); // Get the stored goal
                            

                        if (existingGoal != null) {
                          existingGoal
        ..name = _goalNameController.text
        ..currency = selectedCurrency
        ..amount = _goalAmountController.text
        ..targetDate = selectedDate ?? DateTime.now()
        ..iconCodePoint = selectedIconIndex != null
            ? savingIcons[selectedIconIndex!].codePoint
            : widget.goal.iconCodePoint
        ..iconFontFamily = selectedIconIndex != null
            ? savingIcons[selectedIconIndex!].fontFamily
            : widget.goal.iconFontFamily;
                          await existingGoal.save(); // Save changes directly

                          Navigator.pushAndRemoveUntil(
                            context,
                            AnimatedNavigation().fadeAnimation(BottomNav()),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          print("Error: Goal not found in Hive box");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 700.ms).slideY(begin: 20, end: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, Widget content, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }
}
