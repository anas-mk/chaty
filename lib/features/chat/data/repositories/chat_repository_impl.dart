import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;
  ChatRepositoryImpl({required this.remote});

  @override
  Stream<List<Message>> getMessagesStream() {
    return remote.getMessages().map((list) => list.map((m) => m as Message).toList());
  }

  @override
  Future<Either<Failure, void>> sendMessage(Message message) async {
    try {
      final model = MessageModel(
        id: message.id,
        senderId: message.senderId,
        senderName: message.senderName,
        text: message.text,
        timestamp: message.timestamp,
      );
      await remote.sendMessage(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
