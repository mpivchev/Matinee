import 'dart:collection';

import 'package:equatable/equatable.dart';

import 'movies_discover.dart';

/// Holds the entry ids for all movies and shows that are marked as to watch, watched, or liked
///
/// Used by [EntryCachedIdsProvider]
class EntryIdsCache {
  /// The starting prefetched movie ids imported from Firestore
  final Map<String, HashSet<int>> _prefetchedMovieIds;

  /// The starting prefetched show ids imported from Firestore
  final Map<String, HashSet<int>> _prefetchedShowIds;

  final Map<String, HashSet<int>> _movieIds = Map();

  final Map<String, HashSet<int>> _showIds = Map();

  HashSet<int> get toWatchMovieIds => _movieIds["to_watch"];

  HashSet<int> get watchedMovieIds => _movieIds["watched"];

  HashSet<int> get likedMovieIds => _movieIds["liked"];

  HashSet<int> get toWatchShowIds => _showIds["to_watch"];

  HashSet<int> get watchedShowIds => _showIds["watched"];

  HashSet<int> get likedShowIds => _showIds["liked"];

  EntryIdsCache(this._prefetchedMovieIds, this._prefetchedShowIds) {
    _movieIds.addAll(_prefetchedMovieIds);
    _showIds.addAll(_prefetchedShowIds);
  }

  void addMovieIdToWatch(int id) {
    _movieIds["to_watch"].add(id);
    _movieIds["watched"].remove(id);
    _movieIds["liked"].remove(id);
  }

  void addMovieIdToAlreadyWatched(int id) {
    _movieIds["to_watch"].remove(id);
    _movieIds["watched"].add(id);
    _movieIds["liked"].remove(id);
  }

  void addMovieIdToLiked(int id) {
    _movieIds["to_watch"].remove(id);
    _movieIds["watched"].remove(id);
    _movieIds["liked"].add(id);
  }

  void removeMovieIdFromWatchlist(int id) {
    _movieIds["to_watch"].remove(id);
    _movieIds["watched"].remove(id);
    _movieIds["liked"].remove(id);
  }

  void addShowIdToWatch(int id) {
    _showIds["to_watch"].add(id);
    _showIds["watched"].remove(id);
    _showIds["liked"].remove(id);
  }

  void addShowIdToAlreadyWatched(int id) {
    _showIds["to_watch"].remove(id);
    _showIds["watched"].add(id);
    _showIds["liked"].remove(id);
  }

  void addShowIdToLiked(int id) {
    _showIds["to_watch"].remove(id);
    _showIds["watched"].remove(id);
    _showIds["liked"].add(id);
  }

  void removeShowIdFromWatchlist(int id) {
    _showIds["to_watch"].remove(id);
    _showIds["watched"].remove(id);
    _showIds["liked"].remove(id);
  }
}