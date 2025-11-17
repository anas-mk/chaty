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
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);


  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  sl.registerFactory(() => AuthBloc(
    loginUsecase: sl(),
    registerUsecase: sl(),
    logoutUsecase: sl(),
    repository: sl(),
  ));





  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl(firestore: sl()));

  // Repositories
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(remote: sl()));

  // Usecases
  sl.registerLazySingleton(() => GetMessagesStream(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));

  // Bloc
  sl.registerFactory(() => ChatBloc(getMessagesStream: sl(), sendMessage: sl()));






}
