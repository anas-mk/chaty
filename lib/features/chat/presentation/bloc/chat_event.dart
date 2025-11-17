import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubscribeMessages extends ChatEvent {}

class NewMessageSent extends ChatEvent {
  final Message message;
  NewMessageSent(this.message);

  @override
  List<Object?> get props => [message];
}
