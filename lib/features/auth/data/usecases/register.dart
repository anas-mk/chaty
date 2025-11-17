import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class Register {
  final AuthRepository repository;
  Register(this.repository);

  Future<Either<Failure, UserEntity>> call(String name, String email, String password) {
    return repository.register(name,email, password);
  }
}
