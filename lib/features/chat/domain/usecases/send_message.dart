import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';
import '../entities/message.dart';

class SendMessage {
  final ChatRepository repository;
  SendMessage(this.repository);

  Future<Either<Failure, void>> call(String chatId, Message message) {
    return repository.sendMessage(chatId, message); // Message فقط
  }
}

