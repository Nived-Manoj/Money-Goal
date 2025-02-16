import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart' as intl;
import 'package:money_goal_application/view/home_screen/add_goal/add_goal_reminder.dart';

class SavingsGoalDetails extends StatefulWidget {
  final int selectedIndex;
  final String name;
  final IconData icon;
  const SavingsGoalDetails({super.key, required this.selectedIndex, 
  required this.name,
  required this.icon
  });

  @override
  State<SavingsGoalDetails> createState() => _SavingsGoalDetailsState();
}

class _SavingsGoalDetailsState extends State<SavingsGoalDetails> {
  String selectedCurrency = 'INR';
  final TextEditingController goalAmountController = TextEditingController();
  final TextEditingController currentBalanceController =
      TextEditingController();
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  final Map<String, Map<String, dynamic>> currencies = {
    'INR': {'flag': '🇮🇳', 'symbol': '₹', 'name': 'Indian Rupee'},
    'USD': {'flag': '🇺🇸', 'symbol': '\$', 'name': 'US Dollar'},
    'EUR': {'flag': '🇪🇺', 'symbol': '€', 'name': 'Euro'},
    'GBP': {'flag': '🇬🇧', 'symbol': '£', 'name': 'British Pound'},
  };

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
                  'What Are the Details of\nYour Saving Goal?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 10, end: 0),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Currency Selector
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
                    
                        const SizedBox(height: 16),
                    
                        // Goal Amount
                        _buildDetailCard(
                          'Goal Amount',
                          TextFormField(
                            controller: goalAmountController,
                            validator: (_){
                              if(goalAmountController.text.trim().isEmpty){
                                return "This field is required";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '0',
                              suffixText: selectedCurrency,
                            ),
                          ),
                        ),
                    
                        const SizedBox(height: 16),
                    
                        // Current Balance
                        _buildDetailCard(
                          'Current Balance',
                          TextFormField(
                            controller: currentBalanceController,
                            validator: (_){
                              if(currentBalanceController.text.trim().isEmpty){
                                return "This field is required";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '0',
                              suffixText: selectedCurrency,
                            ),
                          ),
                        ),
                    
                        const SizedBox(height: 16),
                    
                        // Target Date
                        _buildDetailCard(
                          'Target Date',
                          Row(
                            children: [
                              Text(
                                intl.DateFormat('MMM dd, yyyy')
                                    .format(selectedDate),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.calendar_today),
                            ],
                          ),
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setState(() => selectedDate = picked);
                            }
                          },
                        ),
                      ]
                          .animate(interval: 100.ms)
                          .fadeIn()
                          .slideY(begin: 20, end: 0),
                    ),
                  ),
                ),
              ),

              // Continue Button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SavingsReminderSettings(
                          amount: goalAmountController.text,
                          balance: currentBalanceController.text,
                          currency: selectedCurrency,
                          name: widget.name,
                          date: selectedDate,
                          icon: widget.icon,
                        ),
                      ),
                    );
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
                        'Continue',
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
