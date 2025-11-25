import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeToggled extends ThemeEvent {
  const ThemeToggled();
}

class ThemeChanged extends ThemeEvent {
  const ThemeChanged(this.isDarkMode);
  final bool isDarkMode;

  @override
  List<Object> get props => [isDarkMode];
}
