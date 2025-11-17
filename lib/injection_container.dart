import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/data/usecases/login.dart';
import 'features/auth/data/usecases/logout.dart';
import 'features/auth/data/usecases/register.dart';
import 'features/auth/domain/datasources/auth_remote_data_source.dart';
import 'features/auth/domain/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/chat/data/datasources/chat_remote_data_source.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/get_messages_stream.dart';
import 'features/chat/domain/usecases/send_message.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Firebase instances
  if (!sl.isRegistered<FirebaseAuth>()) {
    sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  }

  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  }

  // Auth
  if (!sl.isRegistered<AuthRemoteDataSource>()) {
    sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  }

  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  }

  if (!sl.isRegistered<Login>()) {
    sl.registerLazySingleton(() => Login(sl()));
  }

  if (!sl.isRegistered<Register>()) {
    sl.registerLazySingleton(() => Register(sl()));
  }

  if (!sl.isRegistered<Logout>()) {
    sl.registerLazySingleton(() => Logout(sl()));
  }

  if (!sl.isRegistered<AuthBloc>()) {
    sl.registerFactory(() => AuthBloc(
      loginUsecase: sl(),
      registerUsecase: sl(),
      logoutUsecase: sl(),
      repository: sl(),
    ));
  }

  // Chat
  if (!sl.isRegistered<ChatRemoteDataSource>()) {
    sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl(firestore: sl()));
  }

  if (!sl.isRegistered<ChatRepository>()) {
    sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(remote: sl()));
  }

  if (!sl.isRegistered<GetMessagesStream>()) {
    sl.registerLazySingleton(() => GetMessagesStream(sl()));
  }

  if (!sl.isRegistered<SendMessage>()) {
    sl.registerLazySingleton(() => SendMessage(sl()));
  }

  if (!sl.isRegistered<ChatBloc>()) {
    sl.registerFactory(() => ChatBloc(getMessagesStream: sl(), sendMessage: sl()));
  }
}

