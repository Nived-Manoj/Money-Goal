import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math' as math;

import 'package:money_goal_application/core/animated_navigation.dart';
import 'package:money_goal_application/db_functions/db_helper.dart';
import 'package:money_goal_application/model/goal_model.dart';
import 'package:money_goal_application/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:money_goal_application/view/profile_screen/achieved_goal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[50]!,
              Colors.white,
              Colors.grey[100]!,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween(begin: -30, end: 0),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(value, 0),
                        child: const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Settings List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSection(
                      'Quick Actions',
                      [
                        SettingItem(
                          icon: Icons.archive_outlined,
                          title: 'Achieved Goals',
                          onTap: () {
                            Navigator.push(
                                context,
                                AnimatedNavigation()
                                    .fadeAnimation(AchievedGoal()));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildSection(
                      'Other',
                      [
                        SettingItem(
                          icon: Icons.share_outlined,
                          title: 'Share',
                          onTap: () {
                            String text =
                                "📲 Check out this amazing app developed by Auxzon Solutions! 🚀 Stay organized, manage leads, and boost productivity—all in one place. Download now and experience seamless performance! 🔥 https://play.google.com/store/apps?hl=en_IN&pli=1";
                            shareText(text);
                          },
                        ),
                        SettingItem(
                          icon: Icons.star_outline,
                          title: 'Rate Us',
                          onTap: () {
                            openPlayStore();
                          },
                        ),
                        SettingItem(
                          icon: Icons.contact_support_outlined,
                          title: 'Contact Us',
                          onTap: () {
                            _contactAlertDialogue();
                            // _contactBottomsheet();
                          },
                        ),
                        SettingItem(
                          icon: Icons.shield_outlined,
                          title: 'Privacy Policy',
                          onTap: () {},
                        ),
                        SettingItem(
                          icon: Icons.description_outlined,
                          title: 'Terms of Service',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildSection(
                      'Account Settings',
                      [
                        // SettingItem(
                        //   icon: Icons.restore,
                        //   title: 'Restore Purchases',
                        //   onTap: () {},
                        // ),
                        SettingItem(
                          icon: Icons.delete_outline,
                          title: 'Delete Data',
                          isDestructive: true,
                          onTap: () async {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Delete",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    content: SizedBox(
                                      height: 100,
                                      child: Column(
                                        children: [
                                          Text(
                                              "Are you sure want to delete the data?"),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("No")),
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.black),
                                                  onPressed: () async {
                                                    Box<GoalModel> box;
                                                    if (Hive.isBoxOpen(
                                                        'goals')) {
                                                      box = Hive.box<GoalModel>(
                                                          'goals');
                                                    } else {
                                                      box = await Hive.openBox<
                                                          GoalModel>('goals');
                                                    }
                                                    await box.clear().then((_) {
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                              context,
                                                              AnimatedNavigation()
                                                                  .fadeAnimation(
                                                                      const BottomNav(
                                                                index: 0,
                                                              )),
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false);
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Data deleted successfully",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        backgroundColor:
                                                            Colors.black54,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                    });
                                                  },
                                                  child: const Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 800),
                        tween: Tween(begin: 0, end: 1),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Text(
                              'Version 1.0',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openPlayStore() async {
    final String appPackageName = "com.example.yourapp";
    final Uri playStoreUrl = Uri.parse(
        "https://play.google.com/store/apps/details?id=$appPackageName");

    if (await canLaunchUrl(playStoreUrl)) {
      await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch $playStoreUrl";
    }
  }

  void shareText(String text) async {
    final result = await Share.share(text);
    if (result.status == ShareResultStatus.success) {
      Fluttertoast.showToast(
        msg: "Successfully shared",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void sendEmail({required String message}) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path:
          'codynamixsoftwaresolutions@gmail.com', // Replace with the recipient email
      queryParameters: {'subject': "Query about SaveUp", 'body': message},
    );
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: "Failed to send email. Try again later",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _contactAlertDialogue() {
    final TextEditingController messageCont = TextEditingController();
    // final TextEditingController emailCont = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 305,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    const Text(
                      "Contact us",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                       ,
                    const SizedBox(
                      height: 15,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // TextFormField(
                          //   controller: emailCont,
                          //   validator: (value) {
                          //     final emailRegex = RegExp(
                          //       r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          //     );

                          //     if (value == null || value.trim().isEmpty) {
                          //       return "This field is required";
                          //     } else if (!emailRegex.hasMatch(value)) {
                          //       return "Please enter a valid email address";
                          //     }
                          //     return null;
                          //   },
                          //   keyboardType: TextInputType.emailAddress,
                          //   decoration: InputDecoration(
                          //     hintText: "Enter your email",
                          //     hintStyle: TextStyle(color: Colors.grey),
                          //     labelText: "Email address",
                          //     focusedBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(15),
                          //         borderSide: BorderSide(
                          //             color: Colors.grey.withValues(alpha: 0.6))),
                          //     enabledBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(15),
                          //         borderSide: BorderSide(
                          //             color: Colors.grey.withValues(alpha: 0.6))),
                          //     errorBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(15),
                          //         borderSide: BorderSide(color: Colors.red)),
                          //     focusedErrorBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(15),
                          //         borderSide: BorderSide(color: Colors.red)),
                          //   ),
                          // )
                          //     .animate()
                          //     .fadeIn(duration: 900.ms)
                          //     .slideX(begin: -0.8, end: 0),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          TextFormField(
                            controller: messageCont,
                            validator: (_) {
                              if (messageCont.text.trim().isEmpty ||
                                  messageCont.text == "") {
                                return "This field is required";
                              }
                              return null;
                            },
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: "Enter your message",
                              hintStyle: TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color:
                                          Colors.grey.withValues(alpha: 0.6))),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color:
                                          Colors.grey.withValues(alpha: 0.6))),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                          )
                             ,
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                sendEmail(message: messageCont.text);
                              }
                            },
                            child: Text(
                              "Sent",
                              style: TextStyle(color: Colors.white),
                            ))
                       ,
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _contactBottomsheet() {
    final TextEditingController messageCont = TextEditingController();
    // final TextEditingController emailCont = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        const Text(
                          "Contact us",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                            .animate()
                            .fadeIn(duration: 900.ms)
                            .slideX(begin: -0.8, end: 0),
                        const SizedBox(
                          height: 15,
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              // TextFormField(
                              //   controller: emailCont,
                              //   validator: (value) {
                              //     final emailRegex = RegExp(
                              //       r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              //     );

                              //     if (value == null || value.trim().isEmpty) {
                              //       return "This field is required";
                              //     } else if (!emailRegex.hasMatch(value)) {
                              //       return "Please enter a valid email address";
                              //     }
                              //     return null;
                              //   },
                              //   keyboardType: TextInputType.emailAddress,
                              //   decoration: InputDecoration(
                              //     hintText: "Enter your email",
                              //     hintStyle: TextStyle(color: Colors.grey),
                              //     labelText: "Email address",
                              //     focusedBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(15),
                              //         borderSide: BorderSide(
                              //             color: Colors.grey.withValues(alpha: 0.6))),
                              //     enabledBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(15),
                              //         borderSide: BorderSide(
                              //             color: Colors.grey.withValues(alpha: 0.6))),
                              //     errorBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(15),
                              //         borderSide: BorderSide(color: Colors.red)),
                              //     focusedErrorBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(15),
                              //         borderSide: BorderSide(color: Colors.red)),
                              //   ),
                              // )
                              //     .animate()
                              //     .fadeIn(duration: 900.ms)
                              //     .slideX(begin: -0.8, end: 0),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              TextFormField(
                                controller: messageCont,
                                validator: (_) {
                                  if (messageCont.text.trim().isEmpty ||
                                      messageCont.text == "") {
                                    return "This field is required";
                                  }
                                  return null;
                                },
                                maxLines: 5,
                                decoration: InputDecoration(
                                  hintText: "Enter your message",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: Colors.grey
                                              .withValues(alpha: 0.6))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                          color: Colors.grey
                                              .withValues(alpha: 0.6))),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 900.ms)
                                  .slideX(begin: -0.8, end: 0),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  minimumSize: const Size(double.infinity, 56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    sendEmail(message: messageCont.text);
                                  }
                                },
                                child: Text(
                                  "Sent",
                                  style: TextStyle(color: Colors.white),
                                ))
                            .animate()
                            .fadeIn(duration: 900.ms)
                            .slideY(begin: 0.8, end: 0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildSection(String title, List<SettingItem> items) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 30, end: 0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: items.map((item) => _buildListTile(item)).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListTile(SettingItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Animated Icon Container
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: item.isDestructive
                            ? Colors.red.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.isDestructive ? Colors.red : Colors.blue,
                        size: 22,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: item.isDestructive ? Colors.red : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Transform.rotate(
                angle: -math.pi / 2,
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.grey[400],
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class SettingItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  SettingItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });
}
