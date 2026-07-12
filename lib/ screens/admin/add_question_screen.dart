import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final questionController = TextEditingController();
  final option1Controller = TextEditingController();
  final option2Controller = TextEditingController();
  final option3Controller = TextEditingController();
  final option4Controller = TextEditingController();
  final answerController = TextEditingController();

  bool isLoading = false;

  String selectedClass = "Class 7";
  String selectedSubject = "Bangla";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FF),
      appBar: AppBar(
        title: const Text("Add Question"),
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
                DropdownMenuItem(value: "Class 6", child: Text("Class 6")),
                DropdownMenuItem(value: "Class 7", child: Text("Class 7")),
                DropdownMenuItem(value: "Class 8", child: Text("Class 8")),
                DropdownMenuItem(value: "Class 9", child: Text("Class 9")),
                DropdownMenuItem(value: "Class 10", child: Text("Class 10")),
                DropdownMenuItem(
                  value: "HSC 1st Year",
                  child: Text("HSC 1st Year"),
                ),
                DropdownMenuItem(
                  value: "HSC 2nd Year",
                  child: Text("HSC 2nd Year"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedClass = value!;
                });
              },
            ),

            const SizedBox(height: 15),

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
                hintText: "সঠিক উত্তর লিখুন",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveQuestion,
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
                        "Save Question",
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

  Future<void> saveQuestion() async {
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
      await FirebaseFirestore.instance.collection("questions").add({
        "class": selectedClass,
        "subject": selectedSubject,
        "question": questionController.text.trim(),
        "option1": option1Controller.text.trim(),
        "option2": option2Controller.text.trim(),
        "option3": option3Controller.text.trim(),
        "option4": option4Controller.text.trim(),
        "answer": answerController.text.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      questionController.clear();
      option1Controller.clear();
      option2Controller.clear();
      option3Controller.clear();
      option4Controller.clear();
      answerController.clear();

      setState(() {
        selectedClass = "Class 7";
        selectedSubject = "Bangla";
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Question Successfully Added"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
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
}
