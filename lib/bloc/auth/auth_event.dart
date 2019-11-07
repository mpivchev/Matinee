import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_finder/api/repositories/repositories.dart';

import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/local/settings.dart';

abstract class AuthEvent extends Equatable {}

class LogInEmail extends AuthEvent {}

class LogInGoogle extends AuthEvent {}

class RegisterEmail extends AuthEvent {}

class GetUser extends AuthEvent {}
