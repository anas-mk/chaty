import 'dart:async';
import 'package:bloc/bloc.dart';
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
    on<SubscribeMessages>((event, emit) async {
      emit(ChatLoading());
      await _messagesSub?.cancel();
      _messagesSub = getMessagesStream().listen((messages) {
        add(_MessagesUpdated(messages));
      }, onError: (err) {
        add(_MessagesError(err.toString()));
      });
    });

    on<NewMessageSent>((event, emit) async {
      final result = await sendMessage(event.message);
      result.fold(
            (failure) => emit(ChatError('Failed to send')),
            (_) => null,
      );
    });

    on<_MessagesUpdated>((event, emit) {
      emit(ChatLoaded(event.messages));
    });

    on<_MessagesError>((event, emit) {
      emit(ChatError(event.error));
    });
  }

  @override
  Future<void> close() {
    _messagesSub?.cancel();
    return super.close();
  }
}

// Internal events
class _MessagesUpdated extends ChatEvent {
  final List<Message> messages;
  _MessagesUpdated(this.messages);

  @override
  List<Object?> get props => [messages];
}

class _MessagesError extends ChatEvent {
  final String error;
  _MessagesError(this.error);

  @override
  List<Object?> get props => [error];
}
