import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Stream<List<Message>> getMessagesStream();
  Future<Either<Failure, void>> sendMessage(Message message);
}
