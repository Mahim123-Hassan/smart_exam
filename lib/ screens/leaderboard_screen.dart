import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FF),

      appBar: AppBar(
        title: const Text("Leaderboard 🏆"),

        centerTitle: true,

        backgroundColor: const Color(0xff6A11CB),

        foregroundColor: Colors.white,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("results")
            .orderBy("percentage", descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Result Found", style: TextStyle(fontSize: 20)),
            );
          }

          var results = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(15),

            itemCount: results.length,

            itemBuilder: (context, index) {
              var data = results[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 5,

                margin: const EdgeInsets.only(bottom: 15),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,

                    backgroundColor: index == 0
                        ? Colors.amber
                        : Colors.deepPurple,

                    child: Text(
                      "${index + 1}",

                      style: const TextStyle(
                        color: Colors.white,

                        fontSize: 20,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  title: Text(
                    data["studentName"],

                    style: const TextStyle(
                      fontSize: 20,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text("Grade: ${data["grade"]}"),

                  trailing: Text(
                    "${data["percentage"].toStringAsFixed(0)}%",

                    style: const TextStyle(
                      fontSize: 20,

                      fontWeight: FontWeight.bold,
                    ),
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
