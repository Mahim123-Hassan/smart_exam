import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentResultScreen extends StatefulWidget {
  const StudentResultScreen({super.key});

  @override
  State<StudentResultScreen> createState() => _StudentResultScreenState();
}

class _StudentResultScreenState extends State<StudentResultScreen> {
  TextEditingController searchController = TextEditingController();

  String searchText = "";
  String selectedClass = "All";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Student...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: selectedClass,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: "All", child: Text("All Classes")),
                DropdownMenuItem(value: "Class 6", child: Text("Class 6")),
                DropdownMenuItem(value: "Class 7", child: Text("Class 7")),
                DropdownMenuItem(value: "Class 8", child: Text("Class 8")),
                DropdownMenuItem(value: "Class 9", child: Text("Class 9")),
                DropdownMenuItem(value: "Class 10", child: Text("Class 10")),
                DropdownMenuItem(
                  value: "Inter 1st Year",
                  child: Text("Inter 1st Year"),
                ),
                DropdownMenuItem(
                  value: "Inter 2nd Year",
                  child: Text("Inter 2nd Year"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedClass = value!;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                results = results.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;

                  String studentName = data["studentName"]
                      .toString()
                      .toLowerCase();

                  String studentClass = data["class"].toString();

                  bool matchName = studentName.contains(searchText);

                  bool matchClass =
                      selectedClass == "All" || studentClass == selectedClass;

                  return matchName && matchClass;
                }).toList();

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
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
          ),
        ],
      ),
    );
  }
}
