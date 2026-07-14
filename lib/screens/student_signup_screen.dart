import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentSignupScreen extends StatefulWidget {
  const StudentSignupScreen({super.key});

  @override
  State<StudentSignupScreen> createState() => _StudentSignupScreenState();
}

class _StudentSignupScreenState extends State<StudentSignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String selectedClass = "Class 6";
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signUpStudent() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password does not match"),
        ),
      );
      return;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FF),

      appBar: AppBar(
        title: const Text("Student Sign Up"),
        centerTitle: true,
        backgroundColor: const Color(0xff6A11CB),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(Icons.school, size: 90, color: Color(0xff6A11CB)),

            const SizedBox(height: 20),

            const Text(
              "Smart Exam",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xff6A11CB),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Create Student Account",
              style: TextStyle(fontSize: 18, color: Colors.grey),

            ),
            const SizedBox(height: 30),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                hintText: "Enter your full name",
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Enter your password",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                hintText: "Re-enter your password",
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: selectedClass,
              decoration: InputDecoration(
                labelText: "Select Class",
                prefixIcon: const Icon(Icons.school),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
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
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: signUpStudent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6A11CB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),

                TextButton(
                  onPressed: () {

                    // পরে StudentLoginScreen এ যাবে
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff6A11CB),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
