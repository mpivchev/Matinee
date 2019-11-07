import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_finder/api/repositories/repositories.dart';
import 'package:movie_finder/api/tmdb_api.dart';
import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/models/movie_details.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/shows_discover.dart';

abstract class TmdbMovieEvent extends Equatable {}

class FetchTrendingMovies extends TmdbMovieEvent {}

class FetchSimilarFromMovie extends TmdbMovieEvent {
  final int id;

  FetchSimilarFromMovie({@required this.id});
}

class FetchRecommendedFromMovie extends TmdbMovieEvent {
  final int id;

  FetchRecommendedFromMovie({@required this.id});
}

class FetchMoviesInTheaters extends TmdbMovieEvent {}

class FetchUpcomingMovies extends TmdbMovieEvent {}

class FetchMovieDetails extends TmdbMovieEvent {
  final int id;

  FetchMovieDetails({@required this.id});
}
