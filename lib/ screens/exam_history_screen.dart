import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExamHistoryScreen extends StatelessWidget {
  const ExamHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FF),

      appBar: AppBar(
        title: const Text("Exam History 📜"),

        centerTitle: true,

        backgroundColor: const Color(0xff6A11CB),

        foregroundColor: Colors.white,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("results")
            .orderBy("date", descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Exam History Found",

                style: TextStyle(fontSize: 20),
              ),
            );
          }

          var exams = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(15),

            itemCount: exams.length,

            itemBuilder: (context, index) {
              var data = exams[index].data() as Map<String, dynamic>;

              Timestamp timestamp = data["date"];

              DateTime date = timestamp.toDate();

              return Card(
                elevation: 6,

                margin: const EdgeInsets.only(bottom: 15),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(18),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.amber,

                            child: Icon(
                              Icons.emoji_events,

                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Text(
                            data["studentName"],

                            style: const TextStyle(
                              fontSize: 22,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Score : ${data["score"]}/${data["totalQuestion"]}",

                        style: const TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Percentage : ${data["percentage"].toStringAsFixed(0)}%",

                        style: const TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Grade : ${data["grade"]}",

                        style: const TextStyle(
                          fontSize: 18,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Date : ${date.day}/${date.month}/${date.year}",

                        style: const TextStyle(
                          color: Colors.grey,

                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
