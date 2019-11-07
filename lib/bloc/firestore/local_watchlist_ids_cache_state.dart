import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';

abstract class LocalWatchlistIdsCacheState extends Equatable {
  LocalWatchlistIdsCacheState([List props = const []]) : super(props);
}

class FirestoreEntryIdsCacheUninitialized
    extends LocalWatchlistIdsCacheState {}

class FirestoreEntryIdsCacheError extends LocalWatchlistIdsCacheState {}

class FirestoreEntryIdsCacheReady extends LocalWatchlistIdsCacheState {
  FirestoreEntryIdsCacheReady();
}

class WatchlistEntryIdsAvailable extends LocalWatchlistIdsCacheState {
  final HashSet<int> toWatchMovieIds;
  final HashSet<int> watchedMovieIds;
  final HashSet<int> likedMovieIds;

  final HashSet<int> toWatchShowIds;
  final HashSet<int> watchedShowIds;
  final HashSet<int> likedShowIds;

  /// Combines to watch, watched, and liked movie ids into one set
  HashSet<int> get allMovieIds =>
      HashSet<int>.of([...toWatchMovieIds, ...watchedMovieIds, ...likedMovieIds]);

  /// Combines to watch, watched, and liked show ids into one set
  HashSet<int> get allShowIds =>
      HashSet<int>.of([...toWatchShowIds, ...watchedShowIds, ...likedShowIds]);

  WatchlistEntryIdsAvailable(
      this.toWatchMovieIds,
      this.watchedMovieIds,
      this.likedMovieIds,
      this.toWatchShowIds,
      this.watchedShowIds,
      this.likedShowIds)
      : super([
          toWatchMovieIds,
          watchedMovieIds,
          likedMovieIds,
          toWatchShowIds,
          watchedShowIds,
          likedShowIds
        ]);

  bool isEntryInToWatch(WatchlistEntryInfo info) {
    if (info.entryType == EntryType.movie) {
      if (toWatchMovieIds.contains(info.id)) return true;
    } else {
      if (toWatchShowIds.contains(info.id)) return true;
    }

    return false;
  }

  bool isEntryInWatched(WatchlistEntryInfo info) {
    if (info.entryType == EntryType.movie) {
      if (watchedMovieIds.contains(info.id)) return true;
    } else {
      if (watchedShowIds.contains(info.id)) return true;
    }

    return false;
  }

  bool isEntryInLiked(WatchlistEntryInfo info) {
    if (info.entryType == EntryType.movie) {
      if (likedMovieIds.contains(info.id)) return true;
    } else {
      if (likedShowIds.contains(info.id)) return true;
    }

    return false;
  }
}
