import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

abstract class AuthState extends Equatable {
  AuthState([List props = const []]) : super(props);
}

class Nothing extends AuthState {}

class AuthError extends AuthState {}

// class AuthLogInSuccess extends AuthState {}

class RegisterSuccess extends AuthState {}

class UserAvailable extends AuthState {
  final FirebaseUser firebaseUser;

  UserAvailable({@required this.firebaseUser}) : super([firebaseUser]);
}

class UserNull extends AuthState {}
