import 'package:equatable/equatable.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  bool get isDarkMode;

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {
  @override
  final bool isDarkMode;

  const ThemeInitial({this.isDarkMode = false});

  @override
  List<Object> get props => [isDarkMode];
}
