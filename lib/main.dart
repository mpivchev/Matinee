import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/local/settings.dart';
import 'package:movie_finder/models/entry_ids_cache.dart';
import 'package:movie_finder/screens/login/login.dart';
import 'package:movie_finder/screens/menu/base/base_menu.dart';
import 'package:movie_finder/utils/statusbar.dart';
import 'package:movie_finder/widgets/custom_widgets/empty_widget.dart';
import 'package:movie_finder/widgets/custom_widgets/loading_indicator.dart';

import 'bloc/logger_bloc_delegate.dart';

void main() {
  BlocSupervisor.delegate = LoggerBlocDelegate();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _authBloc = AuthBloc();
  final _localCacheBloc = LocalWatchlistIdsCacheBloc();

  var movieIdsReady = false;
  var showIdsReady = false;

  @override
  Widget build(BuildContext context) {
    StatusBar.setWhite();

    return BlocProviderTree(
        blocProviders: [
          BlocProvider<AuthBloc>(
            builder: (BuildContext context) => _authBloc,
          ),
          BlocProvider<LocalWatchlistIdsCacheBloc>(
            builder: (BuildContext context) => _localCacheBloc,
          )
        ],
        child: StreamBuilder<FirebaseUser>(
          stream: _authBloc.onAuthStateChanged,
          builder: (BuildContext context, authSnapshot) {
            if (!authSnapshot.hasData) {
              // no user data, go to login
              return goToLogin();
            }

            _localCacheBloc.dispatch(InitializeCache());

            return BlocBuilder(
                bloc: _localCacheBloc,
                condition: (previousState, currentState) {
                  if (currentState is FirestoreEntryIdsCacheReady) return true;
                  return false;
                },
                builder: (context, LocalWatchlistIdsCacheState firestoreState) {
                  if (firestoreState is FirestoreEntryIdsCacheReady) {
                    // since the cache is ready, we can now fetch all ids and update widgets
                    _localCacheBloc.dispatch(FetchEntryIds());

                    return goToBaseMenu();
                  }

                  return LoadingIndicator(); // TODO: Change this to a placeholder
                });
          },
        ));
  }

  Widget goToBaseMenu() {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie finder',
        theme: ThemeData(
            fontFamily: "OpenSans",
            primaryColor: white,
            backgroundColor: Colors.red),
        home: BaseMenu());
  }

  Widget goToLogin() {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);
