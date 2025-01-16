import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:money_goal_application/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:money_goal_application/view/home_screen/home_screen.dart';

class SavingsReminderSettings extends StatefulWidget {
  const SavingsReminderSettings({super.key});

  @override
  State<SavingsReminderSettings> createState() =>
      _SavingsReminderSettingsState();
}

class _SavingsReminderSettingsState extends State<SavingsReminderSettings> {
  bool remindersEnabled = false;
  bool notificationsAllowed = false;
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);
  String selectedFrequency = 'Every Week';

  final List<String> frequencies = [
    'Every Day',
    'Every Week',
    'Every Two Weeks',
    'Every Month',
  ];

  void _showTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  void _showFrequencyPicker() {
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
                'Select Frequency',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: frequencies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(frequencies[index]),
                    trailing: selectedFrequency == frequencies[index]
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    onTap: () {
                      setState(() => selectedFrequency = frequencies[index]);
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
                  'Need a Reminder for\nYour Saving?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 10, end: 0),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      // Enable Reminders Switch
                      _buildCard(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Enable Reminders',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Switch.adaptive(
                              value: remindersEnabled,
                              onChanged: (value) {
                                setState(() => remindersEnabled = value);
                              },
                            ),
                          ],
                        ),
                      ),

                      if (!notificationsAllowed) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.orange.shade200,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_rounded,
                                color: Colors.orange.shade700,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Notifications Not Allowed',
                                  style: TextStyle(
                                    color: Colors.orange.shade900,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() => notificationsAllowed = true);
                                },
                                child: Row(
                                  children: const [
                                    Text('Allow'),
                                    Icon(Icons.arrow_forward, size: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Time Picker
                      _buildCard(
                        onTap: _showTimePicker,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedTime.format(context),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Icon(Icons.access_time),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Frequency Picker
                      _buildCard(
                        onTap: _showFrequencyPicker,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Repeat Frequency',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedFrequency,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]
                        .animate(interval: 100.ms)
                        .fadeIn()
                        .slideY(begin: 20, end: 0),
                  ),
                ),
              ),

              // Watch Ad Button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNav(),
                      ),
                    );
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
                        'Watch Ad & Save',
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

  Widget _buildCard({required Widget child, VoidCallback? onTap}) {
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
        child: child,
      ),
    );
  }
}
