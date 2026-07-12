import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_question_screen.dart';
import 'manage_question_screen.dart';
import 'admin_login_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FF),

      appBar: AppBar(
        title: const Text("Admin Panel"),
        centerTitle: true,
        backgroundColor: const Color(0xff6A11CB),
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),

            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminLoginScreen(),
                ),
                    (route) => false,
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 20),

            adminButton(
              context,
              title: "Add Question",
              icon: Icons.add_circle,
              color: Colors.green,
              screen: const AddQuestionScreen(),
            ),

            const SizedBox(height: 20),

            adminButton(
              context,
              title: "Manage Questions",
              icon: Icons.edit_note,
              color: Colors.orange,
              screen: const ManageQuestionScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget adminButton(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required Widget screen,
      }) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
        icon: Icon(icon, size: 30),
        label: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}