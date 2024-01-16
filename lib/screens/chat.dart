import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pulse_talk/screens/login.dart';
import 'package:pulse_talk/utils/app_colors.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void signOut() async {
      try {
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.message ?? 'Failed to signout, Please try again!',
              ),
            ),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
        backgroundColor: AppColor.kPrimary,
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(
              Icons.login,
            ),
          )
        ],
      ),
    );
  }
}
