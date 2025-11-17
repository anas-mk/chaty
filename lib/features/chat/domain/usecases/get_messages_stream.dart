import '../repositories/chat_repository.dart';
import '../entities/message.dart';

class GetMessagesStream {
  final ChatRepository repository;
  GetMessagesStream(this.repository);

  Stream<List<Message>> call() {
    return repository.getMessagesStream();
  }
}
