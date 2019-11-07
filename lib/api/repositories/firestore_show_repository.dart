import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_finder/api/repositories/firestore_base_repository.dart';
import 'package:movie_finder/api/repositories/repositories.dart';
import 'package:movie_finder/models/keywords.dart';
import 'package:movie_finder/models/show_firestore_entry.dart';
import 'package:movie_finder/models/shows_discover.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';

class FirestoreShowRepository extends FirestoreBaseRepository {
  final _firestore = Firestore.instance;

  CollectionReference _getShowWatchlistCollectionRef(String userId) {
    return _firestore
        .collection('users')
        .document(userId)
        .collection("watchlist")
        .document("shows")
        .collection("entries");
  }

  CollectionReference _getShowIdsCollectionRef(String userId) {
    return _firestore
        .collection('users')
        .document(userId)
        .collection("watchlist_ids");
  }

  @override
  Future<Null> addToWatch(
      String userId, int showId, String title, String posterPath) async {
    _firestore.runTransaction((transaction) async {
      try {
        final refWatchlistIds = _getShowIdsCollectionRef(userId);
        final refWatchlist = _getShowWatchlistCollectionRef(userId);

        final docWatchlistIds =
            await transaction.get(refWatchlistIds.document("show_ids"));
        final docWatchlist =
            await transaction.get(refWatchlist.document(showId.toString()));

        await _addShowIdToWatchField(docWatchlistIds, showId, transaction);

        var data = {
          "id": showId,
          "userId": userId,
          "title": title,
          "poster_path": posterPath,
          "type": "show",
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
      String userId, int showId, String title, String posterPath) async {
    _firestore.runTransaction((transaction) async {
      try {
        final refWatchlistIds = _getShowIdsCollectionRef(userId);
        final refWatchlist = _getShowWatchlistCollectionRef(userId);

        final docWatchlistIds =
            await transaction.get(refWatchlistIds.document("show_ids"));
        final docWatchlist =
            await transaction.get(refWatchlist.document(showId.toString()));

        await _addShowIdAlreadyWatchedField(
            docWatchlistIds, showId, transaction);

        var data = {
          "id": showId,
          "userId": userId,
          "title": title,
          "poster_path": posterPath,
          "type": "show",
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
      String userId, int showId, String title, String posterPath) async {
    _firestore.runTransaction((transaction) async {
      try {
        final refWatchlistIds = _getShowIdsCollectionRef(userId);
        final refWatchlist = _getShowWatchlistCollectionRef(userId);

        final docWatchlistIds =
            await transaction.get(refWatchlistIds.document("show_ids"));
        final docWatchlist =
            await transaction.get(refWatchlist.document(showId.toString()));

        await _addShowIdLikedField(docWatchlistIds, showId, transaction);

        var data = {
          "id": showId,
          "userId": userId,
          "title": title,
          "poster_path": posterPath,
          "type": "show",
          "added_as": "liked",
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
  Future<Null> removeFromWatchList(
      String userId, int id, String title, String posterPath) async {
    _firestore.runTransaction((transaction) async {
      _removeShowIdFromWatchlist(userId, id, transaction);

      final ref = _getShowWatchlistCollectionRef(userId);
      final doc = await transaction.get(ref.document(id.toString()));

      transaction.delete(doc.reference);
    });
  }

  Future<Null> _addShowIdToWatchField(
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

  Future<Null> _addShowIdAlreadyWatchedField(
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

  Future<Null> _addShowIdLikedField(
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

  Future<Null> _removeShowIdFromWatchlist(
      String userId, int id, Transaction transaction) async {
    try {
      final ref = _getShowIdsCollectionRef(userId);
      final doc = await transaction.get(ref.document("show_ids"));

      transaction.update(doc.reference, {
        "to_watch": FieldValue.arrayRemove([id]),
        "watched": FieldValue.arrayRemove([id]),
        "liked": FieldValue.arrayRemove([id]),
      });
    } catch (e) {
      print(e);
    }
  }

  /// Returns a map containing the ids of the to-watch, watched, and liked shows for the user
  @override
  Future<Map<String, HashSet<int>>> fetchIds(String userId) async {
    final ref = _getShowIdsCollectionRef(userId);
    final doc = await ref.document("show_ids").get();

    print("fetchShowIds: 1 documents read");

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
      final ref = _getShowWatchlistCollectionRef(userId);

      // Bi-directional query of random documents based on https://stackoverflow.com/questions/46798981/firestore-how-to-get-random-documents-in-a-collection
      final randomInt = generate64BitRandom();
      List<DocumentSnapshot> docs = List();

      final doc = await ref
          .where("random", isLessThanOrEqualTo: randomInt)
          .where("added_as", isEqualTo: "liked")
          .where("type", isEqualTo: "show")
          .orderBy("random", descending: true)
          .limit(limit)
          .getDocuments();

      docs.addAll(doc.documents);

      // if there are less documents than the amount we want, query more in the other direction
      if (docs.length < limit) {
        final doc = await ref
            .where("random", isGreaterThanOrEqualTo: randomInt)
            .where("added_as", isEqualTo: "liked")
            .where("type", isEqualTo: "show")
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
