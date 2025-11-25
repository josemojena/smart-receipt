import 'package:equatable/equatable.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  bool get isDarkMode;

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial({this.isDarkMode = false});
  @override
  final bool isDarkMode;

  @override
  List<Object> get props => [isDarkMode];
}
