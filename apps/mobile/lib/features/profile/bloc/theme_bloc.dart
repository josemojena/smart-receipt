import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_receipt_mobile/features/profile/bloc/theme_event.dart';
import 'package:smart_receipt_mobile/features/profile/bloc/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeInitial(isDarkMode: false)) {
    on<ThemeToggled>(_onThemeToggled);
    on<ThemeChanged>(_onThemeChanged);
  }

  Future<void> _onThemeToggled(
    ThemeToggled event,
    Emitter<ThemeState> emit,
  ) async {
    emit(ThemeInitial(isDarkMode: !state.isDarkMode));
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    emit(ThemeInitial(isDarkMode: event.isDarkMode));
  }
}
