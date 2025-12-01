import 'package:get_it/get_it.dart';
import 'package:handy_connect/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:handy_connect/features/auth/domain/repositories/auth_repository.dart';
import 'package:handy_connect/features/auth/domain/usecases/signin.dart';
import 'package:handy_connect/features/auth/domain/usecases/signup.dart';
import 'package:handy_connect/features/auth/domain/usecases/signin_with_google.dart';
import 'package:handy_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:handy_connect/features/handyman/data/repositories/handyman_repository_impl.dart';
import 'package:handy_connect/features/handyman/domain/repositories/handyman_repository.dart';
import 'package:handy_connect/features/handyman/domain/usecases/get_service_requests.dart';
import 'package:handy_connect/features/handyman/domain/usecases/update_request_status.dart';
import 'package:handy_connect/features/handyman/presentation/bloc/requests_bloc.dart';
import 'package:handy_connect/features/handyman/domain/usecases/get_handyman_profile.dart';
import 'package:handy_connect/features/handyman/domain/usecases/update_handyman_profile.dart';
import 'package:handy_connect/features/handyman/presentation/bloc/profile_bloc.dart';
import 'package:handy_connect/features/customer/data/repositories/customer_repository_impl.dart';
import 'package:handy_connect/features/customer/domain/repositories/customer_repository.dart';
import 'package:handy_connect/features/customer/domain/usecases/get_handymen.dart';
import 'package:handy_connect/features/customer/presentation/bloc/handyman_list_bloc.dart';
import 'package:handy_connect/features/customer/domain/usecases/create_service_request.dart';
import 'package:handy_connect/features/customer/presentation/bloc/booking_bloc.dart';
import 'package:handy_connect/features/customer/domain/usecases/get_my_requests.dart';
import 'package:handy_connect/features/customer/presentation/bloc/my_requests_bloc.dart';
import 'package:handy_connect/features/auth/domain/usecases/get_user_type.dart';
import 'package:handy_connect/features/customer/domain/usecases/get_customer_profile.dart';
import 'package:handy_connect/features/customer/domain/usecases/update_customer_profile.dart';
import 'package:handy_connect/features/customer/presentation/bloc/customer_profile_bloc.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Blocs
  locator.registerFactory(
    () => AuthBloc(
      signUp: locator(),
      signIn: locator(),
      signInWithGoogle: locator(),
      getUserType: locator(),
    ),
  );
  locator.registerFactory(
    () => RequestsBloc(
      getServiceRequests: locator(),
      updateRequestStatus: locator(),
    ),
  );
  locator.registerFactory(
    () => ProfileBloc(
      getHandymanProfile: locator(),
      updateHandymanProfile: locator(),
    ),
  );
  locator.registerFactory(() => HandymanListBloc(getHandymen: locator()));
  locator.registerFactory(() => BookingBloc(createServiceRequest: locator()));
  locator.registerFactory(() => MyRequestsBloc(getMyRequests: locator()));
  locator.registerFactory(
    () => CustomerProfileBloc(
      getCustomerProfile: locator(),
      updateCustomerProfile: locator(),
    ),
  );

  // Use Cases
  locator.registerLazySingleton(() => SignUp(locator()));
  locator.registerLazySingleton(() => SignIn(locator()));
  locator.registerLazySingleton(() => SignInWithGoogle(locator()));
  locator.registerLazySingleton(() => GetServiceRequests(locator()));
  locator.registerLazySingleton(() => GetHandymanProfile(locator()));
  locator.registerLazySingleton(() => UpdateHandymanProfile(locator()));
  locator.registerLazySingleton(() => UpdateRequestStatus(locator()));
  locator.registerLazySingleton(() => GetHandymen(locator()));
  locator.registerLazySingleton(() => CreateServiceRequest(locator()));
  locator.registerLazySingleton(() => GetMyRequests(locator()));
  locator.registerLazySingleton(() => GetUserType(locator()));
  locator.registerLazySingleton(() => GetCustomerProfile(locator()));
  locator.registerLazySingleton(() => UpdateCustomerProfile(locator()));

  // Repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  locator.registerLazySingleton<HandymanRepository>(
    () => HandymanRepositoryImpl(),
  );
  locator.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(),
  );
}
