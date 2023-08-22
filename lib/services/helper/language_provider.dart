import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    //if (!Language.languageList().contains(locale.languageCode)) {
    //  return;
    //}
    _locale = locale;
    notifyListeners();
  }
}
