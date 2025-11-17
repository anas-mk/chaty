import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<MessageModel>> getMessages();
  Future<void> sendMessage(MessageModel message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;
  ChatRemoteDataSourceImpl({required this.firestore});

  CollectionReference get _messagesRef => firestore.collection('messages');

  @override
  Stream<List<MessageModel>> getMessages() {
    return _messagesRef
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((d) => MessageModel.fromMap(d.data() as Map<String, dynamic>, d.id)).toList());
  }

  @override
  Future<void> sendMessage(MessageModel message) async {
    await _messagesRef.add({
      'senderId': message.senderId,
      'senderName': message.senderName,
      'text': message.text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
