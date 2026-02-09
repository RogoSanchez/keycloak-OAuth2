import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keycloack_integrations/src/core/services/keyclock_service_android.dart';
import 'package:keycloack_integrations/src/core/services/keyclock_service_web.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:keycloack_integrations/src/core/storage/storage.dart';
import 'package:keycloack_integrations/src/core/services/abstract_service.dart';
import 'package:keycloack_integrations/src/data/repositories/autentication_repository.dart';
import 'package:keycloack_integrations/src/presentation/login/bloc/auth_bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  const secureStorage = FlutterSecureStorage(aOptions: AndroidOptions());
  getIt.registerSingleton<FlutterSecureStorage>(secureStorage);
  getIt.registerLazySingleton<StorageService>(
    () => StorageService(
      secureStorage: getIt<FlutterSecureStorage>(),
      localStorage: getIt<SharedPreferences>(),
    ),
  );

  getIt.registerLazySingleton<Dio>(() => Dio(), instanceName: 'authDio');

if(kIsWeb){
  getIt.registerLazySingleton<AbstractKeycloakService>(
    () => KeycloakServiceWeb(
      dio: getIt<Dio>(instanceName: 'authDio'),
      storageService: getIt<StorageService>(),
    ),
  );
}else{
  getIt.registerSingleton<FlutterAppAuth>(FlutterAppAuth());
  getIt.registerLazySingleton<AbstractKeycloakService>(
    () => KeycloakServiceAndroid(
      dio: getIt<Dio>(instanceName: 'authDio'),
      storageService: getIt<StorageService>(), appAuth:getIt<FlutterAppAuth>() ,
    ),
  );
}


  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepository(
      keycloakService: getIt<AbstractKeycloakService>(),
    ),
  );

  getIt.registerSingleton<AuthBloc>(
    AuthBloc(authenticationRepository: getIt<AuthenticationRepository>()),
  );
}
