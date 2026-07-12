import 'package:flutter/material.dart';

import 'subject_selection_screen.dart';

class ClassSelectionScreen extends StatelessWidget {
  const ClassSelectionScreen({super.key});

  final List<String> classes = const [
    "Class 6",
    "Class 7",
    "Class 8",
    "Class 9",
    "Class 10",
    "HSC 1st Year",
    "HSC 2nd Year",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FF),

      appBar: AppBar(
        title: const Text("Select Class"),
        centerTitle: true,
        backgroundColor: const Color(0xff6A11CB),
        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: classes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xff6A11CB),
                child: Icon(Icons.school, color: Colors.white),
              ),
              title: Text(
                classes[index],
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubjectSelectionScreen(
                      selectedClass: classes[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}