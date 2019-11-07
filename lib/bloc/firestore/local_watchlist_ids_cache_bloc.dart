import 'dart:async';
import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:movie_finder/api/repositories/auth_repository.dart';
import 'package:movie_finder/api/repositories/firestore_movie_repository.dart';
import 'package:movie_finder/api/repositories/repositories.dart';
import 'package:movie_finder/models/entry_ids_cache.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';

import 'local_watchlist_ids_cache_event.dart';
import 'local_watchlist_ids_cache_state.dart';

enum AddedTo { toWatch, alreadyWatched, liked, none }

class LocalWatchlistIdsCacheBloc extends Bloc<
    LocalWatchlistIdsCacheEvent, LocalWatchlistIdsCacheState> {
  EntryIdsCache entryIdsCache;

  final _firestoreShowRepository = FirestoreShowRepository();
  final _firestoreMovieRepository = FirestoreMovieRepository();
  final _authRepository = AuthRepository();

  @override
  LocalWatchlistIdsCacheState get initialState =>
      FirestoreEntryIdsCacheUninitialized();

  @override
  Stream<LocalWatchlistIdsCacheState> mapEventToState(
      LocalWatchlistIdsCacheEvent event) async* {
    if (event is InitializeCache) {
      yield* _mapInitializeCacheToState();
    } else if (event is AddMovieIdToWatch) {
      yield* _mapAddMovieIdToWatchToState(event.id);
    } else if (event is AddMovieIdToWatched) {
      yield* _mapAddMovieIdToWatchedToState(event.id);
    } else if (event is AddMovieIdToLiked) {
      yield* _mapAddMovieIdToLikedToState(event.id);
    } else if (event is RemoveMovieIdFromWatchlist) {
      yield* _mapRemoveMovieIdFromWatchlistToState(event.id);
    } else if (event is AddShowIdToWatch) {
      yield* _mapAddShowIdToWatchToState(event.id);
    } else if (event is AddShowIdToWatched) {
      yield* _mapAddShowIdToWatchedToState(event.id);
    } else if (event is AddShowIdToLiked) {
      yield* _mapAddShowIdToLikedToState(event.id);
    } else if (event is RemoveShowIdFromWatchlist) {
      yield* _mapRemoveShowIdFromWatchlistToState(event.id);
    } else if (event is FetchEntryIds) {
      yield* _mapFetchEntryIdsToState();
    }
  }

  /// Prefetches the firestore entry ids. This event MUST be called first.
  Stream<LocalWatchlistIdsCacheState> _mapInitializeCacheToState() async* {
    try {
      var user = await _authRepository.getUser();

      Map<String, HashSet<int>> prefetchedMovieIds =
          await _firestoreMovieRepository.fetchIds(user.uid);

      Map<String, HashSet<int>> prefetchedShowIds =
          await _firestoreShowRepository.fetchIds(user.uid);

      entryIdsCache = EntryIdsCache(prefetchedMovieIds, prefetchedShowIds);

      yield FirestoreEntryIdsCacheReady();
    } catch (e) {
      print(e);
      yield FirestoreEntryIdsCacheError();
    }
  }

  Stream<LocalWatchlistIdsCacheState> _mapAddMovieIdToWatchToState(
      int movieId) async* {
    try {
      entryIdsCache.addMovieIdToWatch(movieId);

      yield _watchlistEntryIdsAvailableState;
    } catch (e) {
      print(e);
      yield FirestoreEntryIdsCacheError();
    }
  }

  Stream<LocalWatchlistIdsCacheState> _mapAddMovieIdToWatchedToState(
      int movieId) async* {
    try {
      entryIdsCache.addMovieIdToAlreadyWatched(movieId);

      yield _watchlistEntryIdsAvailableState;
    } catch (e) {
      print(e);
      yield FirestoreEntryIdsCacheError();
    }
  }

  Stream<LocalWatchlistIdsCacheState> _mapAddMovieIdToLikedToState(
      int movieId) async* {
    try {
      entryIdsCache.addMovieIdToLiked(movieId);

      yield _watchlistEntryIdsAvailableState;
    } catch (e) {
      print(e);
      yield FirestoreEntryIdsCacheError();
    }
  }

  Stream<LocalWatchlistIdsCacheState> _mapRemoveMovieIdFromWatchlistToState(
      int movieId) async* {
    try {
      entryIdsCache.removeMovieIdFromWatchlist(movieId);

      yield _watchlistEntryIdsAvailableState;
    } catch (e) {
      print(e);
      yield FirestoreEntryIdsCacheError();
    }
  }

  Stream<LocalWatchlistIdsCacheState> _mapAddShowIdToWatchToState(
      int movieId) async* {
    try {
      entryIdsCache.addShowIdToWatch(movieId);

      yield _watchlistEntryIdsAvailableState;
    } catch (e) {
      print(e);
      yield FirestoreEntryIdsCacheError();
    }
  }

  Stream<LocalWatchlistIdsCacheState> _mapAddShowIdToWatchedToState(
      int movieId) async* {
    try {
      entryIdsCache.addShowIdToAlreadyWatched(movieId);

      yield _watchlistEntryIdsAvailableState;
    } catch (e) {
      print(e);
      yield FirestoreEntryIdsCacheError();
    }
  }

  Stream<LocalWatchlistIdsCacheState> _mapAddShowIdToLikedToState(
      int movieId) async* {
    try {
      entryIdsCache.addShowIdToLiked(movieId);

      yield _watchlistEntryIdsAvailableState;
    } catch (e) {
      print(e);
      yield FirestoreEntryIdsCacheError();
    }
  }

  Stream<LocalWatchlistIdsCacheState> _mapRemoveShowIdFromWatchlistToState(
      int movieId) async* {
    try {
      entryIdsCache.removeShowIdFromWatchlist(movieId);

      yield _watchlistEntryIdsAvailableState;
    } catch (e) {
      print(e);
      yield FirestoreEntryIdsCacheError();
    }
  }

  Stream<LocalWatchlistIdsCacheState> _mapFetchEntryIdsToState() async* {
    try {
      yield _watchlistEntryIdsAvailableState;
    } catch (e) {
      print(e);
      yield FirestoreEntryIdsCacheError();
    }
  }

  WatchlistEntryIdsAvailable get _watchlistEntryIdsAvailableState =>
      WatchlistEntryIdsAvailable(
          HashSet<int>.from(entryIdsCache.toWatchMovieIds),
          HashSet<int>.from(entryIdsCache.watchedMovieIds),
          HashSet<int>.from(entryIdsCache.likedMovieIds),
          HashSet<int>.from(entryIdsCache.toWatchShowIds),
          HashSet<int>.from(entryIdsCache.watchedShowIds),
          HashSet<int>.from(entryIdsCache.likedShowIds));
}
