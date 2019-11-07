import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_finder/api/repositories/repositories.dart';

import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';


import 'firestore_watchlist_state.dart';

abstract class FirestoreWatchlistEvent extends Equatable {}

class AddMovieToWatch extends FirestoreWatchlistEvent {
  final WatchlistEntryInfo info;

  AddMovieToWatch(this.info);
}

class AddMovieToWatched extends FirestoreWatchlistEvent {
  final WatchlistEntryInfo info;

  AddMovieToWatched(this.info);
}

class AddMovieToLiked extends FirestoreWatchlistEvent {
  final WatchlistEntryInfo info;

  AddMovieToLiked(this.info);
}

class RemoveMovieFromWatchlist extends FirestoreWatchlistEvent {
  final WatchlistEntryInfo info;

  RemoveMovieFromWatchlist(this.info);
}

class FetchRandomLikedMovies extends FirestoreWatchlistEvent {
  final int limit;

  FetchRandomLikedMovies({@required this.limit});
}

class AddShowToWatch extends FirestoreWatchlistEvent {
  final WatchlistEntryInfo info;

  AddShowToWatch(this.info);
}

class AddShowToWatched extends FirestoreWatchlistEvent {
  final WatchlistEntryInfo info;

  AddShowToWatched(this.info);
}

class AddShowToLiked extends FirestoreWatchlistEvent {
  final WatchlistEntryInfo info;

  AddShowToLiked(this.info);
}

class RemoveShowFromWatchlist extends FirestoreWatchlistEvent {
  final WatchlistEntryInfo info;

  RemoveShowFromWatchlist(this.info);
}

class FetchRandomLikedShows extends FirestoreWatchlistEvent {
  final int limit;

  FetchRandomLikedShows({@required this.limit});
}

