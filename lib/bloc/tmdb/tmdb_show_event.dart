import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_finder/api/repositories/repositories.dart';
import 'package:movie_finder/api/tmdb_api.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/models/movie_details.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/shows_discover.dart';

abstract class TmdbShowEvent extends Equatable {}

class FetchTrendingShows extends TmdbShowEvent {}


class FetchRecommendedFromShow extends TmdbShowEvent {
  final int id;

  FetchRecommendedFromShow({@required this.id});
}
