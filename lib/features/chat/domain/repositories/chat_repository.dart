import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/message.dart';


abstract class ChatRepository {
  Stream<List<Message>> getMessagesStream(String chatId);
  Future<Either<Failure, void>> sendMessage(String chatId, Message message);
}

