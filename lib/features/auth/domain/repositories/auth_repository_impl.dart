import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/entities/user_entity.dart';
import '../../data/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final user = await remote.login(email, password);
      return Right(user);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(String name, String email, String password) async {
    try {
      final user = await remote.register(name,email, password);
      return Right(user);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remote.logout();
      return const Right(null);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return remote.authStateChanges();
  }
}
