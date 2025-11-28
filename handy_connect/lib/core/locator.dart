import 'package:get_it/get_it.dart';
import 'package:handy_connect/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:handy_connect/features/auth/domain/repositories/auth_repository.dart';
import 'package:handy_connect/features/auth/domain/usecases/signin.dart';
import 'package:handy_connect/features/auth/domain/usecases/signup.dart';
import 'package:handy_connect/features/auth/domain/usecases/signin_with_google.dart';
import 'package:handy_connect/features/auth/presentation/bloc/auth_bloc.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Blocs
  locator.registerFactory(
    () => AuthBloc(
      signUp: locator(),
      signIn: locator(),
      signInWithGoogle: locator(),
    ),
  );

  // Use Cases
  locator.registerLazySingleton(() => SignUp(locator()));
  locator.registerLazySingleton(() => SignIn(locator()));
  locator.registerLazySingleton(() => SignInWithGoogle(locator()));

  // Repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
}
