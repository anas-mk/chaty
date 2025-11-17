import '../../domain/entities/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel extends Message {
  const MessageModel({
    required String id,
    required String senderId,
    required String senderName,
    required String text,
    required DateTime timestamp,
  }) : super(
    id: id,
    senderId: senderId,
    senderName: senderName,
    text: text,
    timestamp: timestamp,
  );

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime ts;
    final raw = map['timestamp'];
    if (raw is Timestamp) {
      ts = raw.toDate();
    } else if (raw is DateTime) {
      ts = raw;
    } else {
      ts = DateTime.now();
    }

    return MessageModel(
      id: id,
      senderId: map['senderId'] as String? ?? '',
      senderName: map['senderName'] as String? ?? '',
      text: map['text'] as String? ?? '',
      timestamp: ts,
    );
  }

  Map<String, dynamic> toMapForSend() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
