import '../repositories/chat_repository.dart';
import '../entities/message.dart';

class GetMessagesStream {
  final ChatRepository repository;
  GetMessagesStream(this.repository);

  Stream<List<Message>> call(String chatId) {
    return repository.getMessagesStream(chatId);
  }
}

