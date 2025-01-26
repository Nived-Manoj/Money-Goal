import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:money_goal_application/view/home_screen/add_goal/add_goal_amount.dart';

class SavingsIconSelector extends StatefulWidget {
  final String name;
  const SavingsIconSelector({super.key, required this.name});

  @override
  State<SavingsIconSelector> createState() => _SavingsIconSelectorState();
}

class _SavingsIconSelectorState extends State<SavingsIconSelector> {
  int? selectedIconIndex;

  IconData? image;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideX(begin: -10, end: 0),
                    const SizedBox(width: 16),
                    Text(
                      'Add Goal',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: -10, end: 0),
                  ],
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Select an Icon for Your\nSavings',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 10, end: 0),
              ),

              // Icons Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  color: selectedIconIndex == index
                                      ? Colors.blue.shade400
                                      : Colors.grey.shade200,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
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
                                    target: selectedIconIndex == index ? 1 : 0)
                                .scale(
                                    begin: Offset(1, 1),
                                    end: Offset(1.05, 1.05),
                                    duration: 200.ms)
                                .shimmer(duration: 200.ms))
                        .animate()
                        .fadeIn(delay: (50 * index).ms, duration: 200.ms)
                        .slideY(begin: 20, end: 0);
                  },
                ),
              ),

              // Continue Button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: selectedIconIndex != null
                      ? () {
                          if (image != null) {
                            // Navigate to the next screen and pass the selected index
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SavingsGoalDetails(
                                  selectedIndex: selectedIconIndex!,
                                  name: widget.name,
                                  icon: image!,
                                ),
                              ),
                            );
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Select any image")));
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 700.ms).slideY(begin: 20, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
