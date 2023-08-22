import 'package:flutter/material.dart';

import 'hexcolor.dart';

@immutable
abstract class MyTheme {
  final MaterialColor? primarySwatch;
  final Color? primaryColor;

  const MyTheme({@required this.primaryColor, @required this.primarySwatch});

  @override
  String toString() {
    return "Primary color : $primaryColor | Primary Swatch : $primarySwatch";
  }

  buildTheme() {
    return ThemeData(
        primaryColor: primaryColor,
        colorScheme: const ColorScheme.light().copyWith(primary: primaryColor),
        primarySwatch: primarySwatch);
  }
}

class DefaultTheme extends MyTheme {
  DefaultTheme()
      : super(
            primaryColor: Colors.purple.shade900,
            primarySwatch: Colors.blueGrey);
}

class ThemeChanger with ChangeNotifier {
  static ThemeChanger? _instance;

  ThemeChanger._internal() {
    _instance = this;
  }

  factory ThemeChanger() => _instance ?? ThemeChanger._internal();

  ThemeData? themeData;
  String? path;
  // ignore: prefer_typing_uninitialized_variables
  var value;

  //ThemeChanger({this.themeData, required this.path, required this.value});

  get getTheme => themeData;

  setTheme(ThemeData theme, String? path, var value) {
    if (theme.primaryColor != themeData?.primaryColor && path != this.path) {
      themeData = theme;
      this.path = path;
      this.value = value;
      notifyListeners();
    }
  }
}

/*class CustomeTheme extends MyTheme {
  final Color primaryColor;
  final Color primarySwatch;
  CustomeTheme({@required this.primaryColor, this.primarySwatch})
      : super(
            primaryColor: primaryColor,
            primarySwatch:
                primarySwatch == null ? Colors.blueGrey : primarySwatch);
}

// ---------------Theme State --------------------
@immutable
abstract class ThemeState {
  final MyTheme theme;

  ThemeState({@required this.theme});
}

class InitialThemeState extends ThemeState {
  InitialThemeState() : super(theme: DefaultTheme());
}

class NewThemeState extends ThemeState {
  NewThemeState(MyTheme theme) : super(theme: theme);
}

//-------------Theme Cubit--------------------

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(InitialThemeState());

  void setNewTheme(MyTheme theme) {
    emit(NewThemeState(theme));
  }
}

//--------------- Theme Bloc -----------------

class ThemeBloc {
  final _themeController = StreamController<MyTheme>();

  get changeTheme {
   //printt("Received theme : ");
    return _themeController.sink.add;
  }

  get getTheme => _themeController.stream;
  get closeTheme => _themeController.close();
}
*/
