import 'dart:async';
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_finder/api/repositories/repositories.dart';
import 'package:movie_finder/bloc/auth/auth_event.dart';
import 'package:movie_finder/bloc/auth/auth_state.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';

import 'package:rxdart/rxdart.dart';

import 'firestore_watchlist_event.dart';
import 'firestore_watchlist_state.dart';

class FirestoreWatchlistBloc
    extends Bloc<FirestoreWatchlistEvent, FirestoreWatchlistState> {
  final _movieRepository = FirestoreMovieRepository();
  final _showRepository = FirestoreShowRepository();
  final _authRepository = AuthRepository();

  Stream<QuerySnapshot> get fullWatchlistSnapshot async* {
    final user = await _authRepository.getUser();

    var source = Firestore.instance
        .collectionGroup("entries")
        .where("userId", isEqualTo: user.uid)
//        .limit(10)
        .snapshots();

    await for (var chunk in source) {
      yield chunk;
    }
  }

  Stream<List<WatchlistEntryInfo>> get toWatchSnapshot async* {
    final user = await _authRepository.getUser();

    var source = Firestore.instance
        .collectionGroup("entries")
        .where("userId", isEqualTo: user.uid)
        .where("added_as", isEqualTo: "to_watch")
//        .limit(10)
        .snapshots();

    await for (var chunk in source) {
      final firestoreMovies = chunk.documents
          .map((entry) => WatchlistEntryInfo.fromJsonFirestore(entry.data))
          .toList();

      yield firestoreMovies;
    }
  }

  Stream<List<WatchlistEntryInfo>> get alreadyWatchedSnapshot async* {
    final user = await _authRepository.getUser();

    var source = Firestore.instance
        .collectionGroup("entries")
        .where("userId", isEqualTo: user.uid)
        .where("added_as", isEqualTo: "watched")
//        .limit(10)
        .snapshots();


    await for (var chunk in source) {
      final firestoreMovies = chunk.documents
          .map((entry) => WatchlistEntryInfo.fromJsonFirestore(entry.data))
          .toList();

      yield firestoreMovies;
    }
  }

  Stream<List<WatchlistEntryInfo>> get likedMoviesSnapshot async* {
    final user = await _authRepository.getUser();

    var source = Firestore.instance
        .collectionGroup("entries")
        .where("userId", isEqualTo: user.uid)
        .where("added_as", isEqualTo: "liked")
//        .limit(10)
        .snapshots();


    await for (var chunk in source) {
      final firestoreMovies = chunk.documents
          .map((entry) => WatchlistEntryInfo.fromJsonFirestore(entry.data))
          .toList();

      yield firestoreMovies;
    }
  }

  @override
  FirestoreWatchlistState get initialState => FirestoreNothing();

  @override
  Stream<FirestoreWatchlistState> mapEventToState(
      FirestoreWatchlistEvent event) async* {
    if (event is AddMovieToWatch) {
      yield* _mapAddMovieToWatchToState(event.info);
    } else if (event is AddMovieToWatched) {
      yield* _mapAddMovieToAlreadyWatchedToState(event.info);
    } else if (event is AddMovieToLiked) {
      yield* _mapAddMovieToLikedToState(event.info);
    } else if (event is RemoveMovieFromWatchlist) {
      yield* _mapRemoveMovieFromWatchlistToState(event.info);
    } else if (event is FetchRandomLikedMovies) {
      yield* _mapFetchRandomLikedMoviesToState(event.limit);
    } else if (event is AddShowToWatch) {
      yield* _mapAddShowToWatchToState(event.info);
    } else if (event is AddShowToWatched) {
      yield* _mapAddShowToAlreadyWatchedToState(event.info);
    } else if (event is AddShowToLiked) {
      yield* _mapAddShowToLikedToState(event.info);
    } else if (event is RemoveShowFromWatchlist) {
      yield* _mapRemoveShowFromWatchlistToState(event.info);
    } else if (event is FetchRandomLikedShows) {
      yield* _mapFetchRandomLikedShowsToState(event.limit);
    }
  }

  Stream<FirestoreWatchlistState> _mapAddMovieToWatchToState(
      WatchlistEntryInfo info) async* {
    final user = await _authRepository.getUser();

    try {
      await _movieRepository.addToWatch(
          user.uid, info.id, info.title, info.posterPath);
//      yield FirestoreMovieAddedToWatch(info.id);
    } catch (e) {
      print(e);
      yield FirestoreError();
    }
  }

  Stream<FirestoreWatchlistState> _mapAddMovieToAlreadyWatchedToState(
      WatchlistEntryInfo info) async* {
    var user = await _authRepository.getUser();

    try {
      await _movieRepository.addToAlreadyWatched(
          user.uid, info.id, info.title, info.posterPath);
//      yield FirestoreMovieAddedToAlreadyWatched(info.id);
    } catch (e) {
      print(e);
      yield FirestoreError();
    }
  }

  Stream<FirestoreWatchlistState> _mapAddMovieToLikedToState(
      WatchlistEntryInfo info) async* {
    var user = await _authRepository.getUser();

    try {
      await _movieRepository.addToLiked(
          user.uid, info.id, info.title, info.posterPath);
//      yield FirestoreMovieAddedToLiked(info.id);
    } catch (e) {
      print(e);
      yield FirestoreError();
    }
  }

  Stream<FirestoreWatchlistState> _mapRemoveMovieFromWatchlistToState(
      WatchlistEntryInfo info) async* {
    var user = await _authRepository.getUser();

    try {
      await _movieRepository.removeFromWatchList(
          user.uid, info.id, info.title, info.posterPath);
//      yield FirestoreMovieRemovedFromWatchlist(info.id);
    } catch (e) {
      print(e);
      yield FirestoreError();
    }
  }

  Stream<FirestoreWatchlistState> _mapFetchRandomLikedMoviesToState(
      int limit) async* {
    try {
      var user = await _authRepository.getUser();
      var entries =
          await _movieRepository.fetchRandomLiked(user.uid, limit);

      yield FirestoreRandomLikedEntriesAvailable(entries);
    } catch (e) {
      print(e);
      yield FirestoreError();
    }
  }

  Stream<FirestoreWatchlistState> _mapAddShowToWatchToState(
      WatchlistEntryInfo info) async* {
    final user = await _authRepository.getUser();

    try {
      await _showRepository.addToWatch(
          user.uid, info.id, info.title, info.posterPath);
//      yield FirestoreMovieAddedToWatch(info.id);
    } catch (e) {
      print(e);
      yield FirestoreError();
    }
  }

  Stream<FirestoreWatchlistState> _mapAddShowToAlreadyWatchedToState(
      WatchlistEntryInfo info) async* {
    var user = await _authRepository.getUser();

    try {
      await _showRepository.addToAlreadyWatched(
          user.uid, info.id, info.title, info.posterPath);
//      yield FirestoreMovieAddedToAlreadyWatched(info.id);
    } catch (e) {
      print(e);
      yield FirestoreError();
    }
  }

  Stream<FirestoreWatchlistState> _mapAddShowToLikedToState(
      WatchlistEntryInfo info) async* {
    var user = await _authRepository.getUser();

    try {
      await _showRepository.addToLiked(
          user.uid, info.id, info.title, info.posterPath);
//      yield FirestoreMovieAddedToLiked(info.id);
    } catch (e) {
      print(e);
      yield FirestoreError();
    }
  }

  Stream<FirestoreWatchlistState> _mapRemoveShowFromWatchlistToState(
      WatchlistEntryInfo info) async* {
    var user = await _authRepository.getUser();

    try {
      await _showRepository.removeFromWatchList(
          user.uid, info.id, info.title, info.posterPath);
//      yield FirestoreMovieRemovedFromWatchlist(info.id);
    } catch (e) {
      print(e);
      yield FirestoreError();
    }
  }

  Stream<FirestoreWatchlistState> _mapFetchRandomLikedShowsToState(
      int limit) async* {
    try {
      var user = await _authRepository.getUser();
      var entries =
      await _showRepository.fetchRandomLiked(user.uid, limit);

      yield FirestoreRandomLikedEntriesAvailable(entries);
    } catch (e) {
      print(e);
      yield FirestoreError();
    }
  }
}
