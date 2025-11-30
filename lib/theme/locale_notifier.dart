import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null); // null means system default

  void setLocale(Locale? locale) {
    state = locale;
  }

  void setEnglish() {
    state = const Locale('en');
  }

  void setPortuguese() {
    state = const Locale('pt', 'BR');
  }

  void setSystemDefault() {
    state = null;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});
