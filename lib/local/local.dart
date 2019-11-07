import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

enum LogInProvider { NONE, EMAIL, GOOGLE }

class Local {
  static const _movieToWatchIds = "movieToWatchIds";
  static const _movieWatchedIds = "movieWatchedIds";
  static const _movieLikedIds = "movieLikedIds";

//  static setLoggedIn(bool value) async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    int counter = (prefs.getInt('counter') ?? 0) + 1;
//    print('Pressed $counter times.');
//    await prefs.setInt('counter', counter);
//
//    await prefs.setBool(_isLoggedInKey, value);
//  }

  // Future<LogInProvider> getLastLogInProvider(String providerId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   String providerId = prefs.getString(_movieIds);

  //   switch (providerId) {
  //     case "google.com": return LogInProvider.GOOGLE;
  //     default: return LogInProvider.NONE;
  //   }
  // }

  // static setLastLogInProvider(String providerId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(_movieIds, providerId);
  // }

  // static setMovieIds(Map mapIds) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // await prefs.setMap(_movieIds, mapIds);
  // }

  static Future<List> getMovieToWatchIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final ids = prefs.getStringList(_movieToWatchIds);

    return ids;
  }

  static setMovieToWatchIds(Set ids) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_movieToWatchIds, ids.toList());
  }

  static setMovieWatchedIds(Set ids) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_movieWatchedIds, ids.toList());
  }

  static setMovieLikedIds(Set ids) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_movieLikedIds, ids.toList());
  }
}
