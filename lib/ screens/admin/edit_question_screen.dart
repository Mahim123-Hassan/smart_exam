import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditQuestionScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const EditQuestionScreen({
    super.key,
    required this.docId,
    required this.data,
  });

  @override
  State<EditQuestionScreen> createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  late TextEditingController questionController;
  late TextEditingController option1Controller;
  late TextEditingController option2Controller;
  late TextEditingController option3Controller;
  late TextEditingController option4Controller;
  late TextEditingController answerController;

  late String selectedClass;
  late String selectedSubject;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    questionController = TextEditingController(text: widget.data["question"]);

    option1Controller = TextEditingController(text: widget.data["option1"]);

    option2Controller = TextEditingController(text: widget.data["option2"]);

    option3Controller = TextEditingController(text: widget.data["option3"]);

    option4Controller = TextEditingController(text: widget.data["option4"]);

    answerController = TextEditingController(text: widget.data["answer"]);

    selectedClass = widget.data["class"];
    selectedSubject = widget.data["subject"];
  }

  @override
  void dispose() {
    questionController.dispose();
    option1Controller.dispose();
    option2Controller.dispose();
    option3Controller.dispose();
    option4Controller.dispose();
    answerController.dispose();

    super.dispose();
  }

  @override
  Future<void> updateQuestion() async {
    if (questionController.text.trim().isEmpty ||
        option1Controller.text.trim().isEmpty ||
        option2Controller.text.trim().isEmpty ||
        option3Controller.text.trim().isEmpty ||
        option4Controller.text.trim().isEmpty ||
        answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("সব তথ্য পূরণ করুন"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection("questions")
          .doc(widget.docId)
          .update({
            "class": selectedClass,
            "subject": selectedSubject,
            "question": questionController.text.trim(),
            "option1": option1Controller.text.trim(),
            "option2": option2Controller.text.trim(),
            "option3": option3Controller.text.trim(),
            "option4": option4Controller.text.trim(),
            "answer": answerController.text.trim(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Question Updated Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FF),
      appBar: AppBar(
        title: const Text("Edit Question"),
        centerTitle: true,
        backgroundColor: const Color(0xff6A11CB),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedClass,
              decoration: const InputDecoration(
                labelText: "Select Class",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "7", child: Text("Class 7")),
                DropdownMenuItem(value: "8", child: Text("Class 8")),
                DropdownMenuItem(value: "9", child: Text("Class 9")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedClass = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                labelText: "Question",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: option1Controller,
              decoration: const InputDecoration(
                labelText: "Option 1",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: option2Controller,
              decoration: const InputDecoration(
                labelText: "Option 2",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: option3Controller,
              decoration: const InputDecoration(
                labelText: "Option 3",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: option4Controller,
              decoration: const InputDecoration(
                labelText: "Option 4",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                labelText: "Correct Answer",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            DropdownButtonFormField<String>(
              value: selectedSubject,
              decoration: const InputDecoration(
                labelText: "Select Subject",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Bangla", child: Text("Bangla")),
                DropdownMenuItem(value: "English", child: Text("English")),
                DropdownMenuItem(
                  value: "Mathematics",
                  child: Text("Mathematics"),
                ),
                DropdownMenuItem(value: "Science", child: Text("Science")),
                DropdownMenuItem(value: "ICT", child: Text("ICT")),
              ],

              onChanged: (value) {
                setState(() {
                  selectedSubject = value!;
                });
              },
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : updateQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6A11CB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Update Question",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
