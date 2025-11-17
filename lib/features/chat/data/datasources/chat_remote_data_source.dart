import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<MessageModel>> getMessages(String chatId);
  Future<void> sendMessage(String chatId, MessageModel message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;
  ChatRemoteDataSourceImpl({required this.firestore});

  CollectionReference _chatMessagesRef(String chatId) =>
      firestore.collection('chats').doc(chatId).collection('messages');

  @override
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _chatMessagesRef(chatId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snap) => snap.docs
        .map((d) => MessageModel.fromMap(d.data() as Map<String, dynamic>, d.id))
        .toList());
  }

  @override
  Future<void> sendMessage(String chatId, MessageModel message) async {
    await _chatMessagesRef(chatId).add({
      'senderId': message.senderId,
      'senderName': message.senderName,
      'text': message.text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
