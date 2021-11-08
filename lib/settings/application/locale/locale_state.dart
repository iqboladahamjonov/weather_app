part of 'locale_cubit.dart';

class LocaleState extends Equatable {
  Locale? _locale;
  LocaleState([this._locale]);
  Locale? get locale => _locale;
  factory LocaleState.initial() => LocaleState();

  LocaleState copyWith({Locale? locale}) => LocaleState(locale ?? this._locale);

  @override
  List<Object> get props => [_locale ?? const Locale('en')];
}
