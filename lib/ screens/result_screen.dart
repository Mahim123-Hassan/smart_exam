import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'exam_screen.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final String studentName;
  final int score;
  final int totalQuestion;

  const ResultScreen({
    super.key,

    required this.studentName,
    required this.score,
    required this.totalQuestion,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  double get percentage => (widget.score / widget.totalQuestion) * 100;

  String get grade {
    if (percentage >= 80) {
      return "A+";
    } else if (percentage >= 70) {
      return "A";
    } else if (percentage >= 60) {
      return "B";
    } else if (percentage >= 50) {
      return "C";
    } else {
      return "F";
    }
  }

  Color get gradeColor {
    if (percentage >= 80) {
      return Colors.green;
    } else if (percentage >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Future<void> saveResult() async {
    await FirebaseFirestore.instance.collection("results").add({
      "studentName": widget.studentName,

      "score": widget.score,

      "totalQuestion": widget.totalQuestion,

      "percentage": percentage,

      "grade": grade,

      "date": DateTime.now(),
    });

    print("Result Saved Successfully");
  }

  @override
  void initState() {
    super.initState();

    saveResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FF),

      appBar: AppBar(
        title: const Text("Exam Result"),

        centerTitle: true,

        backgroundColor: const Color(0xff6A11CB),

        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 100),

              const SizedBox(height: 20),

              const Text(
                "Congratulations 🎉",

                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Text(
                widget.studentName,

                style: const TextStyle(fontSize: 22, color: Colors.grey),
              ),

              const SizedBox(height: 35),

              Card(
                elevation: 8,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(25),

                  child: Column(
                    children: [
                      Text(
                        "${widget.score} / ${widget.totalQuestion}",

                        style: const TextStyle(
                          fontSize: 42,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "${percentage.toStringAsFixed(1)} %",

                        style: const TextStyle(fontSize: 22),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,

                          vertical: 12,
                        ),

                        decoration: BoxDecoration(
                          color: gradeColor,

                          borderRadius: BorderRadius.circular(30),
                        ),

                        child: Text(
                          "Grade : $grade",

                          style: const TextStyle(
                            color: Colors.white,

                            fontSize: 22,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,

                height: 55,

                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),

                  label: const Text(
                    "Retry Exam",

                    style: TextStyle(fontSize: 18),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,

                    foregroundColor: Colors.white,
                  ),

                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ExamScreen(selectedClass: "", selectedSubject: ""),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,

                height: 55,

                child: ElevatedButton.icon(
                  icon: const Icon(Icons.home),

                  label: const Text(
                    "Back Home",

                    style: TextStyle(fontSize: 18),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff6A11CB),

                    foregroundColor: Colors.white,
                  ),

                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,

                      MaterialPageRoute(builder: (_) => const HomeScreen()),

                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
