import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubscribeMessages extends ChatEvent {
  final String chatId;
  SubscribeMessages(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class NewMessageSent extends ChatEvent {
  final String chatId;
  final Message message;
  NewMessageSent(this.chatId, this.message);

  @override
  List<Object?> get props => [chatId, message];
}



