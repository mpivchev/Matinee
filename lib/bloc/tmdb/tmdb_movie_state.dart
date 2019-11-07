import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_finder/models/movie_details.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/shows_discover.dart';

abstract class TmdbMovieState extends Equatable {
  TmdbMovieState([List props = const []]) : super(props);
}

class TmdbUninitialized extends TmdbMovieState {}

class TmdbLoading extends TmdbMovieState {}

class TmdbError extends TmdbMovieState {}

class TrendingMoviesLoaded extends TmdbMovieState {
  final List<MovieEntry> list;
  final int currentPage;
  final int maxPages;

  TrendingMoviesLoaded(
      {@required this.list, @required this.currentPage, @required this.maxPages})
      : super([list, currentPage, maxPages]);
}

class RecommendedMoviesLoaded extends TmdbMovieState {
  final MoviesDiscover list;

  RecommendedMoviesLoaded({@required this.list}) : super([list]);
}

class RecommendedShowsLoaded extends TmdbMovieState {
  final ShowsDiscover list;

  RecommendedShowsLoaded({@required this.list}) : super([list]);
}

class UpcomingMoviesLoaded extends TmdbMovieState {
  final MoviesDiscover list;

  UpcomingMoviesLoaded({@required this.list}) : super([list]);
}

class MoviesInTheatersLoaded extends TmdbMovieState {
  final MoviesDiscover list;

  MoviesInTheatersLoaded({@required this.list}) : super([list]);
}

class SimilarMoviesLoaded extends TmdbMovieState {
  final MoviesDiscover list;

  SimilarMoviesLoaded({@required this.list}) : super([list]);
}

class MovieDetailsLoaded extends TmdbMovieState {
  final MovieDetails movieDetails;

  MovieDetailsLoaded({@required this.movieDetails})
      : super([movieDetails]);
}
