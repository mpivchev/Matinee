import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_finder/models/movie_details.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/shows_discover.dart';

abstract class TmdbShowState extends Equatable {
  TmdbShowState([List props = const []]) : super(props);
}

class TmdbUninitialized extends TmdbShowState {}

class TmdbLoading extends TmdbShowState {}

class TmdbError extends TmdbShowState {}

class TrendingShowsLoaded extends TmdbShowState {
  final List<ShowEntry> list;
  final int currentPage;
  final int maxPages;

  TrendingShowsLoaded(
      {@required this.list, @required this.currentPage, @required this.maxPages})
      : super([list, currentPage, maxPages]);

//  final ShowsDiscover list;

//  TrendingShowsLoaded({@required this.list}) : super([list]);
}

class RecommendedShowsLoaded extends TmdbShowState {
  final ShowsDiscover list;

  RecommendedShowsLoaded({@required this.list}) : super([list]);
}

class TopShowsLoaded extends TmdbShowState {
  final ShowsDiscover list;

  TopShowsLoaded({@required this.list}) : super([list]);
}
