import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:handy_connect/core/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_connect/core/router/app_router.dart';
import 'package:handy_connect/features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<AuthBloc>(),
      child: Builder(
        builder: (context) {
          final router = AppRouter(context.read<AuthBloc>()).router;
          return MaterialApp.router(
            title: 'HandyConnect',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
