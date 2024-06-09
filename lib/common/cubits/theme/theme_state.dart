part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  const ThemeState({
    ThemeMode? themeMode,
  }) : themeMode = themeMode ?? ThemeMode.light;

  final ThemeMode? themeMode;

  @override
  List<ThemeMode?> get props => [themeMode];

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
