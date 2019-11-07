import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_finder/api/repositories/repositories.dart';

import 'package:movie_finder/bloc/bloc.dart';
import 'package:movie_finder/models/movies_discover.dart';


import 'firestore_watchlist_state.dart';

abstract class LocalWatchlistIdsCacheEvent extends Equatable {}

/// Adds a movie id to the "to watch" id collection. Automatically yields [WatchlistEntryIdsAvailable] state.
class AddMovieIdToWatch extends LocalWatchlistIdsCacheEvent {
  final int id;

  AddMovieIdToWatch(this.id);
}

/// Adds a movie id to the "to watched" id collection. Automatically yields [WatchlistEntryIdsAvailable] state.
class AddMovieIdToWatched extends LocalWatchlistIdsCacheEvent {
  final int id;

  AddMovieIdToWatched(this.id);
}

/// Adds a movie id to the "to liked" id collection. Automatically yields [WatchlistEntryIdsAvailable] state.
class AddMovieIdToLiked extends LocalWatchlistIdsCacheEvent {
  final int id;

  AddMovieIdToLiked(this.id);
}

/// Remove a movie id from all watchlist collections. Automatically yields [WatchlistEntryIdsAvailable] state.
class RemoveMovieIdFromWatchlist extends LocalWatchlistIdsCacheEvent {
  final int id;

  RemoveMovieIdFromWatchlist(this.id);
}

/// Adds a show  id to the "to watch" id collection. Automatically yields [WatchlistEntryIdsAvailable] state.
class AddShowIdToWatch extends LocalWatchlistIdsCacheEvent {
  final int id;

  AddShowIdToWatch(this.id);
}

/// Adds a show id to the "to watched" id collection. Automatically yields [WatchlistEntryIdsAvailable] state.
class AddShowIdToWatched extends LocalWatchlistIdsCacheEvent {
  final int id;

  AddShowIdToWatched(this.id);
}

/// Adds a show id to the "to liked" id collection. Automatically yields [WatchlistEntryIdsAvailable] state.
class AddShowIdToLiked extends LocalWatchlistIdsCacheEvent {
  final int id;

  AddShowIdToLiked(this.id);
}

/// Remove a show id from all watchlist collections. Automatically yields [WatchlistEntryIdsAvailable] state.
class RemoveShowIdFromWatchlist extends LocalWatchlistIdsCacheEvent {
  final int id;

  RemoveShowIdFromWatchlist(this.id);
}

/// Fetches all watch, watched, and liked entry ids.
class FetchEntryIds extends LocalWatchlistIdsCacheEvent {}

///// Fetches all watch, watched, and liked entry ids. They are provided in single sets.
//class FetchUngroupedEntryIds extends FirestoreWatchlistIdsCacheEvent {}

/// Prefetches the firestore ids. This must be the event that is called first.
class InitializeCache extends LocalWatchlistIdsCacheEvent {}
