import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_messages_stream.dart';
import '../../domain/usecases/send_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import '../../domain/entities/message.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessagesStream getMessagesStream;
  final SendMessage sendMessage;
  StreamSubscription? _messagesSub;

  ChatBloc({
    required this.getMessagesStream,
    required this.sendMessage,
  }) : super(ChatInitial()) {
    // SUBSCRIBE
    on<SubscribeMessages>((event, emit) async {
      emit(ChatLoading());

      await _messagesSub?.cancel();

      _messagesSub = getMessagesStream(event.chatId).cast().listen(
            (messages) {
          add(MessagesUpdated(messages));
        },
        onError: (err) {
          add(MessagesError(err.toString()));
        },
      );
    });
    // SEND MESSAGE
    on<NewMessageSent>((event, emit) async {
      final result = await sendMessage.call(event.chatId, event.message);

      result.fold(
            (failure) => emit(ChatError("Failed to send")),
            (_) => null,
      );
    });

    // STREAM SUCCESS
    on<MessagesUpdated>((event, emit) {
      emit(ChatLoaded(event.messages));
    });

    // STREAM ERROR
    on<MessagesError>((event, emit) {
      emit(ChatError(event.error));
    });
  }

  @override
  Future<void> close() {
    _messagesSub?.cancel();
    return super.close();
  }
}

/// INTERNAL EVENTS
class MessagesUpdated extends ChatEvent {
  final List<Message> messages;
  MessagesUpdated(this.messages);

  @override
  List<Object?> get props => [messages];
}

class MessagesError extends ChatEvent {
  final String error;
  MessagesError(this.error);

  @override
  List<Object?> get props => [error];
}
