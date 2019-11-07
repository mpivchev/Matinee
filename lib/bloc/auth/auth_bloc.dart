import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_finder/api/repositories/auth_repository.dart';
import 'package:movie_finder/bloc/auth/auth_event.dart';
import 'package:movie_finder/bloc/auth/auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  Stream<FirebaseUser> onAuthStateChanged =
      FirebaseAuth.instance.onAuthStateChanged;
  final AuthRepository _authRepository = AuthRepository();

  @override
  AuthState get initialState => Nothing();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is LogInEmail) {
      yield* _mapLogInEmailToState();
    } else if (event is LogInGoogle) {
      yield* _mapLogInGoogleToState();
    } else if (event is RegisterEmail) {
      yield* _mapRegisterEmailToState();
    } else if (event is GetUser) {
      yield* _mapGetUserToState();
    }
  }

  Stream<AuthState> _mapLogInEmailToState() async* {
    try {
      final user = await _authRepository
          .logInEmail("test@test.com", "test123")
          .catchError((e) {
        print(e);
        return AuthError();
      });

      yield UserAvailable(firebaseUser: user);
    } catch (e) {
      print(e);
      yield AuthError();
    }
  }

  Stream<AuthState> _mapLogInGoogleToState() async* {
    try {
      final user = await _authRepository.logInGoogle().catchError((e) {
        print(e);
        return AuthError();
      });

      yield UserAvailable(firebaseUser: user);
    } catch (e) {
      print(e);
      yield AuthError();
    }
  }

  Stream<AuthState> _mapRegisterEmailToState() async* {
    try {
      final user = await _authRepository
          .registerEmail("test@test.com", "test123")
          .catchError((e) {
        print(e);
        return AuthError();
      });

      yield UserAvailable(firebaseUser: user);
    } catch (e) {
      print(e);
      yield AuthError();
    }
  }

  Stream<AuthState> _mapGetUserToState() async* {
    try {
      final user = await _authRepository.getUser().catchError((e) {
        print(e);
        return AuthError();
      });

      yield UserAvailable(firebaseUser: user);
    } catch (e) {
      print(e);
      yield AuthError();
    }
  }
}
