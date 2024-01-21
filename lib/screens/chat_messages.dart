import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pulse_talk/screens/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (context, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Text('No messages yet');
        }
        if (chatSnapshots.hasError) {
          return const Text('Something went wrong');
        }

        final loadedMessages = chatSnapshots.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          itemCount: loadedMessages.length,
          reverse: true,
          itemBuilder: (context, index) {
            final chatMessage = loadedMessages[index].data();
            final nextChatMessage =
                index + 1 < chatMessage.length ? loadedMessages[index + 1].data() : null;

            final currentMessageUserID = chatMessage['userID'];
            final nextMessageUserID = nextChatMessage != null ? nextChatMessage['userID'] : null;
            final nextUserIsSame = nextMessageUserID == currentMessageUserID;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: FirebaseAuth.instance.currentUser!.uid == currentMessageUserID,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['userImage'],
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: FirebaseAuth.instance.currentUser!.uid == currentMessageUserID,
              );
            }
          },
        );
      },
    );
  }
}
