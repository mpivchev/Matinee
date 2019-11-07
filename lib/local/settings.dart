import 'package:shared_preferences/shared_preferences.dart';

enum LogInProvider {NONE, EMAIL, GOOGLE}

class Settings {
  static const _isLoggedInKey = "isLoggedIn";
  static const _lastLogInProvider = "lastLogInProvider";

//  static setLoggedIn(bool value) async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    int counter = (prefs.getInt('counter') ?? 0) + 1;
//    print('Pressed $counter times.');
//    await prefs.setInt('counter', counter);
//
//    await prefs.setBool(_isLoggedInKey, value);
//  }

  Future<LogInProvider> getLastLogInProvider(String providerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String providerId = prefs.getString(_lastLogInProvider);

    switch (providerId) {
      case "google.com": return LogInProvider.GOOGLE;
      default: return LogInProvider.NONE;
    }
  }

  static setLastLogInProvider(String providerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLogInProvider, providerId);
  }

}
