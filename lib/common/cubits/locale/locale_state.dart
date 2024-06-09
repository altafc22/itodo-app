part of 'locale_cubit.dart';

class LocaleState extends Equatable {
  LocaleState({
    Locale? locale,
  }) : locale = locale ?? Language.english.value;

  final Locale locale;

  @override
  List<Object> get props => [locale];

  LocaleState copyWith({Locale? locale}) {
    return LocaleState(
      locale: locale ?? this.locale,
    );
  }
}
