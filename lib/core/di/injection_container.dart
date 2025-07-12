import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:post_challenge/core/network/network_info.dart';
import 'package:post_challenge/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:post_challenge/features/auth/domain/usecases/login_usecase.dart';
import 'package:post_challenge/features/auth/domain/usecases/logout_usecase.dart';
import 'package:post_challenge/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:post_challenge/features/auth/data/datasources/auth_datasource.dart';
import 'package:post_challenge/features/auth/domain/repositories/auth_repository.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:post_challenge/features/auth/data/repositories/auth_repository_impl.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => InternetConnection());

  sl.registerLazySingleton<AuthDatasource>(
    () => FirebaseAuthDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      loginDatasource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetUserUsecase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  sl.registerFactory(() => AuthBloc(
        getUserUsecase: sl(),
        loginUseCase: sl(),
        logoutUseCase: sl(),
      ));
}
