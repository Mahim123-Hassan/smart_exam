import 'package:flutter/material.dart';

import '../exam_screen.dart';
class SubjectSelectionScreen extends StatelessWidget {
  final String selectedClass;

  const SubjectSelectionScreen({
    super.key,
    required this.selectedClass,
  });


  List<String> getSubjects() {

    if (selectedClass == "HSC 1st Year" ||
        selectedClass == "HSC 2nd Year") {

      return [
        "Physics",
        "Chemistry",
        "Biology",
        "Higher Mathematics",
        "ICT",
        "Bangla 1st Paper",
        "English 1st Paper",
      ];

    } else {

      return [
        "Bangla",
        "English",
        "Mathematics",
        "Science",
        "ICT",
      ];
    }
  }


  @override
  Widget build(BuildContext context) {

    final subjects = getSubjects();

    return Scaffold(

      backgroundColor: const Color(0xffF5F7FF),

      appBar: AppBar(
        title: Text(selectedClass),
        centerTitle: true,
        backgroundColor: const Color(0xff6A11CB),
        foregroundColor: Colors.white,
      ),


      body: ListView.builder(

        padding: const EdgeInsets.all(15),

        itemCount: subjects.length,

        itemBuilder: (context, index) {

          return Card(

            elevation: 5,

            margin: const EdgeInsets.only(bottom: 15),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),


            child: ListTile(

              leading: const CircleAvatar(
                backgroundColor: Color(0xff6A11CB),
                child: Icon(
                  Icons.menu_book,
                  color: Colors.white,
                ),
              ),


              title: Text(
                subjects[index],
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),


              trailing: const Icon(
                Icons.arrow_forward_ios,
              ),


              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExamScreen(
                      selectedClass: selectedClass,
                      selectedSubject: subjects[index],
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