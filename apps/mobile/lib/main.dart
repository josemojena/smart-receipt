import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smart_receipt_mobile/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:smart_receipt_mobile/features/dashboard/bloc/dashboard_event.dart';
import 'package:smart_receipt_mobile/features/profile/bloc/theme_bloc.dart';
import 'package:smart_receipt_mobile/features/profile/bloc/theme_state.dart';
import 'package:smart_receipt_mobile/infrastructure/dependency_injection/dependency_injection.dart';
import 'package:smart_receipt_mobile/shared/navigation/app_router.dart';
import 'package:smart_receipt_mobile/shared/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for Spanish locale
  await initializeDateFormatting('es', null);

  // Setup dependency injection
  await setupDependencyInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider(
          create: (context) =>
              DashboardBloc()..add(const DashboardLoadTickets()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Smart Receipt',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
