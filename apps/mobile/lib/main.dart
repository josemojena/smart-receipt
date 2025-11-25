import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_receipt_mobile/features/profile/bloc/theme_bloc.dart';
import 'package:smart_receipt_mobile/features/profile/bloc/theme_state.dart';
import 'package:smart_receipt_mobile/shared/navigation/main_navigator.dart';
import 'package:smart_receipt_mobile/shared/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Smart Receipt',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainNavigator(),
          );
        },
      ),
    );
  }
}
