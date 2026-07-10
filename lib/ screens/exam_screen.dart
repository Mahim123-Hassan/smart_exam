import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  Map<int, String> selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FF),
      appBar: AppBar(
        centerTitle: true,

        title: const Text(
          "📝 Smart Exam",
          style: TextStyle(fontWeight: FontWeight.bold),
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
        stream: FirebaseFirestore.instance.collection("questions").snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Question Found"));
          }

          var questions = snapshot.data!.docs;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),

                  itemCount: questions.length,

                  itemBuilder: (context, index) {
                    var data = questions[index];

                    List options = [
                      data["option1"],
                      data["option2"],
                      data["option3"],
                      data["option4"],
                    ];

                    return Card(
                      elevation: 2,

                      margin: const EdgeInsets.only(bottom: 12),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(12),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,

                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Text(
                                "Question ${index + 1}",

                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              data["question"],

                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 8),
                            ...options.map((option) {
                              bool isSelected =
                                  selectedAnswers[index] == option;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedAnswers[index] = option;
                                  });
                                },

                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),

                                  margin: const EdgeInsets.only(bottom: 10),

                                  padding: const EdgeInsets.all(14),

                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xff6A11CB)
                                        : Colors.white,

                                    borderRadius: BorderRadius.circular(15),

                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xff6A11CB)
                                          : Colors.grey.shade300,

                                      width: 2,
                                    ),

                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.15),

                                        blurRadius: 8,

                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),

                                  child: Row(
                                    children: [
                                      Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,

                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey,
                                      ),

                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: Text(
                                          option,

                                          style: TextStyle(
                                            fontSize: 16,

                                            fontWeight: FontWeight.w500,

                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
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

                  height: 48,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    onPressed: () {
                      int score = 0;

                      for (int i = 0; i < questions.length; i++) {
                        if (selectedAnswers[i] == questions[i]["answer"]) {
                          score++;
                        }
                      }

                      showDialog(
                        context: context,

                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Exam Result"),

                            content: Text(
                              "Your Score: $score/${questions.length}",

                              style: const TextStyle(fontSize: 18),
                            ),

                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },

                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    },

                    child: const Text(
                      "Submit Exam",

                      style: TextStyle(fontSize: 17),
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
