import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_finder/api/repositories/firestore_base_repository.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';

class FirestoreMovieRepository extends FirestoreBaseRepository {
  final _firestore = Firestore.instance;

  CollectionReference _getMovieWatchlistCollectionRef(String userId) {
    return _firestore
        .collection('users')
        .document(userId)
        .collection("watchlist")
        .document("movies")
        .collection("entries");
  }

  CollectionReference _getMovieIdsCollectionRef(String userId) {
    return _firestore
        .collection('users')
        .document(userId)
        .collection("watchlist_ids");
  }

  @override
  Future<Null> addToWatch(
      String userId, int movieId, String title, String posterPath) async {
    _firestore.runTransaction((transaction) async {
      try {
        final refWatchlistIds = _getMovieIdsCollectionRef(userId);
        final refWatchlist = _getMovieWatchlistCollectionRef(userId);

        final docWatchlistIds =
            await transaction.get(refWatchlistIds.document("movie_ids"));
        final docWatchlist =
            await transaction.get(refWatchlist.document(movieId.toString()));

        await _addMovieIdToWatchField(docWatchlistIds, movieId, transaction);

        var data = {
          "id": movieId,
          "userId": userId,
          "title": title,
          "poster_path": posterPath,
          "type": "movie",
          "added_as": "to_watch",
          "random": generate64BitRandom(),
        };

        if (!docWatchlist.exists) {
          transaction.set(docWatchlist.reference, data);
        } else {
          transaction.update(docWatchlist.reference, data);
        }
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Future<Null> addToAlreadyWatched(
      String userId, int movieId, String title, String posterPath) async {
    _firestore.runTransaction((transaction) async {
      try {
        final refWatchlistIds = _getMovieIdsCollectionRef(userId);
        final refWatchlist = _getMovieWatchlistCollectionRef(userId);

        final docWatchlistIds =
            await transaction.get(refWatchlistIds.document("movie_ids"));
        final docWatchlist =
            await transaction.get(refWatchlist.document(movieId.toString()));

        await _addMovieIdAlreadyWatchedField(
            docWatchlistIds, movieId, transaction);

        var data = {
          "id": movieId,
          "userId": userId,
          "title": title,
          "poster_path": posterPath,
          "type": "movie",
          "added_as": "watched",
          "random": generate64BitRandom(),
        };

        if (!docWatchlist.exists) {
          transaction.set(docWatchlist.reference, data);
        } else {
          transaction.update(docWatchlist.reference, data);
        }
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Future<Null> addToLiked(
      String userId, int movieId, String title, String posterPath) async {
    _firestore.runTransaction((transaction) async {
      try {
        final refWatchlistIds = _getMovieIdsCollectionRef(userId);
        final refWatchlist = _getMovieWatchlistCollectionRef(userId);

        final docWatchlistIds =
            await transaction.get(refWatchlistIds.document("movie_ids"));
        final docWatchlist =
            await transaction.get(refWatchlist.document(movieId.toString()));

        await _addMovieIdLikedField(docWatchlistIds, movieId, transaction);

        var data = {
          "id": movieId,
          "userId": userId,
          "title": title,
          "poster_path": posterPath,
          "type": "movie",
          "added_as": "liked",
          "random": generate64BitRandom(),
          "last_liked_timestamp": DateTime.now().millisecondsSinceEpoch,
        };

        if (!docWatchlist.exists) {
          transaction.set(docWatchlist.reference, data);
        } else {
          transaction.update(docWatchlist.reference, data);
        }
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Future<Null> removeFromWatchList(
      String userId, int movieId, String title, String posterPath) async {
    _firestore.runTransaction((transaction) async {
      _removeMovieIdFromWatchlist(userId, movieId, transaction);

      final ref = _getMovieWatchlistCollectionRef(userId);
      final doc = await transaction.get(ref.document(movieId.toString()));

      transaction.delete(doc.reference);
    });
  }

  Future<Null> _addMovieIdToWatchField(
      DocumentSnapshot docWatchlistIds, int id, Transaction transaction) async {
    try {
      var data = {
        "to_watch": FieldValue.arrayUnion([id]),
        "watched": FieldValue.arrayRemove([id]),
        "liked": FieldValue.arrayRemove([id]),
      };

      if (!docWatchlistIds.exists) {
        transaction.set(docWatchlistIds.reference, data);
      } else {
        transaction.update(docWatchlistIds.reference, data);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Null> _addMovieIdAlreadyWatchedField(
      DocumentSnapshot docWatchlistIds, int id, Transaction transaction) async {
    try {
      var data = {
        "watched": FieldValue.arrayUnion([id]),
        "to_watch": FieldValue.arrayRemove([id]),
        "liked": FieldValue.arrayRemove([id]),
      };

      if (!docWatchlistIds.exists) {
        transaction.set(docWatchlistIds.reference, data);
      } else {
        transaction.update(docWatchlistIds.reference, data);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Null> _addMovieIdLikedField(
      DocumentSnapshot docWatchlistIds, int id, Transaction transaction) async {
    try {
      var data = {
        "watched": FieldValue.arrayRemove([id]),
        "to_watch": FieldValue.arrayRemove([id]),
        "liked": FieldValue.arrayUnion([id]),
      };

      if (!docWatchlistIds.exists) {
        transaction.set(docWatchlistIds.reference, data);
      } else {
        transaction.update(docWatchlistIds.reference, data);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Null> _removeMovieIdFromWatchlist(
      String userId, int id, Transaction transaction) async {
    try {
      final ref = _getMovieIdsCollectionRef(userId);
      final doc = await transaction.get(ref.document("movie_ids"));

      transaction.update(doc.reference, {
        "to_watch": FieldValue.arrayRemove([id]),
        "watched": FieldValue.arrayRemove([id]),
        "liked": FieldValue.arrayRemove([id]),
      });
    } catch (e) {
      print(e);
    }
  }

  /// Returns a map containing the ids of the to-watch, watched, and liked movies for the user
  ///
  /// Used to set up the ids cache for the session - [EntryCachedIdsProvider]. The cache contains all movie/show ids and is used to easily get all ids from the user's watchlist with very few Firestore reads
  ///
  /// Returns an empty map if there are no movie ids
  @override
  Future<Map<String, HashSet<int>>> fetchIds(String userId) async {
    final ref = _getMovieIdsCollectionRef(userId);
    final doc = await ref.document("movie_ids").get();

    print("fetchMovieIds: 1 documents read");

    final map = Map<String, HashSet<int>>();

    final HashSet<int> toWatchIdSet = HashSet();
    final HashSet<int> watchedIdSet = HashSet();
    final HashSet<int> likedIdSet = HashSet();

    if (doc.data != null) {
      (doc.data["to_watch"] as List).forEach((e) => toWatchIdSet.add(e));
      (doc.data["watched"] as List).forEach((e) => watchedIdSet.add(e));
      (doc.data["liked"] as List).forEach((e) => likedIdSet.add(e));
    }

    map.putIfAbsent("to_watch", () => toWatchIdSet);
    map.putIfAbsent("watched", () => watchedIdSet);
    map.putIfAbsent("liked", () => likedIdSet);

    return map;
  }

  @override
  Future<List<WatchlistEntryInfo>> fetchRandomLiked(String userId, int limit) async {
    try {
      final ref = _getMovieWatchlistCollectionRef(userId);

      // Bi-directional query of random documents based on https://stackoverflow.com/questions/46798981/firestore-how-to-get-random-documents-in-a-collection
      final randomInt = generate64BitRandom();
      List<DocumentSnapshot> docs = List();

      final doc = await ref
          .where("random", isLessThanOrEqualTo: randomInt)
          .where("added_as", isEqualTo: "liked")
          .where("type", isEqualTo: "movie")
          .orderBy("random", descending: true)
          .limit(limit)
          .getDocuments();

      docs.addAll(doc.documents);

      // if there are less documents than the amount we want, query more in the other direction
      if (docs.length < limit) {
        final doc = await ref
            .where("random", isGreaterThanOrEqualTo: randomInt)
            .where("added_as", isEqualTo: "liked")
            .where("type", isEqualTo: "movie")
            .limit(limit - docs.length)
            .getDocuments();

        docs.addAll(doc.documents);
      }

      print("fetchRandomLikedMovies: ${docs.length} documents read");

      List<WatchlistEntryInfo> entries = docs
          .map((document) => WatchlistEntryInfo.fromJsonFirestore(document.data))
          .toList();
      return entries;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
