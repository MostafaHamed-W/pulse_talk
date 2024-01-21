import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pulse_talk/screens/chat_messages.dart';
import 'package:pulse_talk/screens/login.dart';
import 'package:pulse_talk/screens/widgets/new_message.dart';
import 'package:pulse_talk/screens/widgets/scaffold_messanger.dart';
import 'package:pulse_talk/utils/app_colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? userImageUrl;
  @override
  void initState() {
    setUpFirebaseMessaging();
    super.initState();
  }

  void setUpFirebaseMessaging() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('chat');

    final fcmToken = await fcm.getToken();
    log('$fcmToken');
  }

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
          showCustomSnackbar(
              context: context,
              message: e.message,
              spareError: 'Failed to signout, Please try again!');
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
              Icons.exit_to_app,
            ),
          )
        ],
      ),
      body: const SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ChatMessages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
