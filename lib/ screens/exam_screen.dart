import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'result_screen.dart';

class ExamScreen extends StatefulWidget {
  final String selectedClass;
  final String selectedSubject;

  const ExamScreen({
    super.key,
    required this.selectedClass,
    required this.selectedSubject,
  });

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  Map<int, String> selectedAnswers = {};

  Timer? timer;

  ValueNotifier<int> timeNotifier = ValueNotifier(1800);

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeNotifier.value > 0) {
        timeNotifier.value--;
      } else {
        timer.cancel();
        autoSubmit();
      }
    });
  }

  String getTime(int seconds) {
    int minute = seconds ~/ 60;

    int second = seconds % 60;

    return "${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}";
  }

  Future<void> autoSubmit() async {
    int score = 0;

    final snapshot = await FirebaseFirestore.instance
        .collection("questions")
        .where("class", isEqualTo: widget.selectedClass)
        .where("subject", isEqualTo: widget.selectedSubject)
        .get();

    var questions = snapshot.docs;

    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i]["answer"]) {
        score++;
      }
    }

    final prefs = await SharedPreferences.getInstance();

    String name = prefs.getString("studentName") ?? "Student";

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          studentName: name,
          score: score,
          totalQuestion: questions.length,
          selectedClass: widget.selectedClass,
          selectedSubject: widget.selectedSubject,
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();

    timeNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FF),

      appBar: AppBar(
        centerTitle: true,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            const Text(
              "📝 Smart Exam",

              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            ValueListenableBuilder<int>(
              valueListenable: timeNotifier,

              builder: (context, value, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,

                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white24,

                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Text(
                    getTime(value),

                    style: const TextStyle(
                      color: Colors.white,

                      fontSize: 18,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff6A11CB), Color(0xff2575FC)],
            ),
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("questions")
            .where("class", isEqualTo: widget.selectedClass)
            .where("subject", isEqualTo: widget.selectedSubject)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Question Found\nClass: ${widget.selectedClass}\nSubject: ${widget.selectedSubject}",
                textAlign: TextAlign.center,
              ),
            );
          }
          var questions = snapshot.data!.docs;

          for (var doc in questions) {
            print(doc.data());
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),

                  itemCount: questions.length,

                  itemBuilder: (context, index) {
                    var data = questions[index];

                    print(data.data());

                    List options = [
                      data["option1"],
                      data["option2"],
                      data["option3"],
                      data["option4"],
                    ];
                    return Card(
                      elevation: 3,

                      margin: const EdgeInsets.only(bottom: 12),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(15),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Question ${index + 1}",

                              style: const TextStyle(
                                color: Colors.blue,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              data["question"],

                              style: const TextStyle(
                                fontSize: 18,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 15),

                            ...options.map((option) {
                              bool selected = selectedAnswers[index] == option;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedAnswers[index] = option;
                                  });
                                },

                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),

                                  margin: const EdgeInsets.only(bottom: 10),

                                  padding: const EdgeInsets.all(14),

                                  decoration: BoxDecoration(
                                    color: selected
                                        ? const Color(0xff6A11CB)
                                        : Colors.white,

                                    borderRadius: BorderRadius.circular(12),
                                  ),

                                  child: Row(
                                    children: [
                                      Icon(
                                        selected
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,

                                        color: selected
                                            ? Colors.white
                                            : Colors.grey,
                                      ),

                                      const SizedBox(width: 10),

                                      Expanded(
                                        child: Text(
                                          option,

                                          style: TextStyle(
                                            color: selected
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12),

                child: SizedBox(
                  width: double.infinity,

                  height: 55,

                  child: ElevatedButton(
                    onPressed: () async {
                      timer?.cancel();
                      await autoSubmit();
                    },

                    child: const Text(
                      "Submit Exam",

                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
