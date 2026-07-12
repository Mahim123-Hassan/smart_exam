import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentResultScreen extends StatelessWidget {
  const StudentResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FF),

      appBar: AppBar(
        title: const Text("Student Results"),
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
                "No Results Found",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          var results = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: results.length,

            itemBuilder: (context, index) {
              var data = results[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 4,

                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xff6A11CB),
                    child: Icon(Icons.person, color: Colors.white),
                  ),

                  title: Text(
                    data["studentName"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    "Class: ${data["class"]}\n"
                        "Subject: ${data["subject"]}\n"
                        "Score: ${data["score"]}/${data["totalQuestion"]}\n"
                        "Grade: ${data["grade"]}",
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