import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_service.dart';
import '../network/network_info.dart';
import '../utils/constants.dart';

// Features - Auth
import '../../features/auth/logic/cubit/cubit/login_cubit.dart';

// Features - Kiosk
import '../../features/kiosk/data/datasources/kiosk_remote_data_source.dart';
import '../../features/kiosk/data/repository/kiosk_repository.dart';
import '../../features/kiosk/logic/create_kiosk_cubit.dart';
import '../../features/kiosk/logic/markets_cubit.dart';
import '../../features/kiosk/logic/market_cubit.dart';

// Features - Home
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/datasources/notifications_remote_data_source.dart';
import '../../features/home/data/repository/home_repository.dart';
import '../../features/home/data/repository/notifications_repository.dart';
import '../../features/home/logic/home_cubit.dart';
import '../../features/home/logic/notifications_cubit.dart';

// Features - Withdraw
import '../../features/withdraw/data/datasources/withdraw_remote_data_source.dart';
import '../../features/withdraw/data/repository/withdraw_repository.dart';
import '../../features/withdraw/logic/cubit/withdraw_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: AppConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: AppConstants.receiveTimeout,
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    ),
  );

  sl.registerLazySingleton(() => InternetConnectionChecker());

  //! Core - API Service
  sl.registerLazySingleton<ApiService>(() => ApiService(sl<Dio>()));

  //! Features - Auth
  sl.registerFactory(
    () => LoginCubit(
      apiService: sl<ApiService>(),
      dio: sl<Dio>(),
      sharedPreferences: sl<SharedPreferences>(),
      kioskRepository: sl<KioskRepository>(),
    ),
  );

  //! Features - Kiosk
  // Data - Register data sources first
  sl.registerLazySingleton<KioskRemoteDataSource>(
    () => KioskRemoteDataSourceImpl(dio: sl(), apiService: sl<ApiService>()),
  );

  // Data - Register repositories second
  sl.registerLazySingleton<KioskRepository>(
    () => KioskRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Logic - Register cubits last (they depend on repositories)
  sl.registerFactory(
    () => CreateKioskCubit(
      repository: sl<KioskRepository>(),
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );
  sl.registerFactory(
    () => MarketsCubit(repository: sl<KioskRepository>()),
  );
  sl.registerFactory(
    () => MarketCubit(repository: sl<KioskRepository>()),
  );

  //! Features - Home
  // Data - Register data sources first
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(dio: sl(), apiService: sl<ApiService>()),
  );

  // Data - Register repositories second
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Logic - Register cubits last (they depend on repositories)
  sl.registerFactory(
    () => HomeCubit(
      repository: sl<HomeRepository>(),
      kioskRepository: sl<KioskRepository>(),
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  // Notifications
  // Data - Register data sources first
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(
      dio: sl(),
      apiService: sl<ApiService>(),
    ),
  );

  // Data - Register repositories second
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Logic - Register cubits last (they depend on repositories)
  sl.registerFactory(
    () => NotificationsCubit(
      repository: sl<NotificationsRepository>(),
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  //! Features - Withdraw
  // Data - Register data sources first
  sl.registerLazySingleton<WithdrawRemoteDataSource>(
    () => WithdrawRemoteDataSourceImpl(dio: sl(), apiService: sl<ApiService>()),
  );

  // Data - Register repositories second
  sl.registerLazySingleton<WithdrawRepository>(
    () => WithdrawRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Logic - Register cubits last (they depend on repositories)
  sl.registerFactory(
    () => WithdrawCubit(
      repository: sl<WithdrawRepository>(),
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );
}
