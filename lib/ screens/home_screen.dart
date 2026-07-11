import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/dashboard_card.dart';
import 'exam_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String studentName = "Student";
  int totalQuestions = 0;

  @override
  void initState() {
    super.initState();
    loadStudentName();
    loadQuestionCount();
  }

  Future<void> loadStudentName() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      studentName = prefs.getString("studentName") ?? "Student";
    });
  }

  Future<void> loadQuestionCount() async {
    final data = await FirebaseFirestore.instance.collection("questions").get();

    setState(() {
      totalQuestions = data.docs.length;
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning ☀";
    } else if (hour < 17) {
      return "Good Afternoon 🌤";
    } else {
      return "Good Evening 🌙";
    }
  }

  String getTodayDate() {
    final now = DateTime.now();

    return "${now.day}/${now.month}/${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FF),

      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 25),

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff6A11CB), Color(0xff2575FC)],
                ),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 34,
                          color: Color(0xff6A11CB),
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    getGreeting(),
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    studentName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    getTodayDate(),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DashboardCard(
                            icon: Icons.menu_book_rounded,
                            title: "Questions",
                            value: totalQuestions.toString(),
                            color: Colors.blue,
                          ),
                        ),

                        const SizedBox(width: 15),

                        const Expanded(
                          child: DashboardCard(
                            icon: Icons.emoji_events,
                            title: "Best Score",
                            value: "95%",
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        const Expanded(
                          child: DashboardCard(
                            icon: Icons.assignment_turned_in,
                            title: "Completed",
                            value: "18",
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(width: 15),

                        const Expanded(
                          child: DashboardCard(
                            icon: Icons.timer,
                            title: "Exam Time",
                            value: "30 Min",
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ExamScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text(
                          "Start Exam",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6A11CB),
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(.15),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),

                      child: const Column(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.amber, size: 45),

                          SizedBox(height: 12),

                          Text(
                            "Daily Motivation",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 10),

                          Text(
                            "Success comes to those who never stop learning.\nPractice every day and become unstoppable! 🚀",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
