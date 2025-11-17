import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  String _getChatId(String a, String b) {
    return a.hashCode <= b.hashCode ? '$a-$b' : '$b-$a';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('Not logged in')));
    }

    final currentUserId = currentUser.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', isNotEqualTo: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          final users = snapshot.data!.docs;

          return StreamBuilder<QuerySnapshot>(
            // نجيب كل الشاتات ونرتبها حسب آخر رسالة
            stream: FirebaseFirestore.instance
                .collection('chats')
                .snapshots(),
            builder: (context, chatsSnapshot) {
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final userDoc = users[index];
                  final uid = userDoc['uid'];
                  final name = userDoc['name'];

                  final chatId = _getChatId(currentUserId, uid);

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chatId)
                        .collection('messages')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, msgSnapshot) {
                      String lastMessage = "No messages yet";
                      String lastTime = "";
                      int totalMessages = 0;

                      if (msgSnapshot.hasData &&
                          msgSnapshot.data!.docs.isNotEmpty) {
                        final msgDoc = msgSnapshot.data!.docs.first;
                        lastMessage = msgDoc['text'] ?? "";
                        final timestamp = msgDoc['timestamp'] as Timestamp?;
                        if (timestamp != null) {
                          final time = timestamp.toDate();
                          lastTime = TimeOfDay.fromDateTime(time).format(context);
                        }
                        totalMessages = msgSnapshot.data!.docs.length;
                      }

                      return ListTile(
                        leading: const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blue,
                        ),
                        title: Text(name),

                        subtitle: Row(
                          children: [
                            Expanded(
                              child: Text(
                                lastMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              lastTime,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            if (totalMessages > 0)
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  totalMessages.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                          ],
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatPage(
                                chatId: chatId,
                                receiverId: uid,
                                receiverName: name,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
