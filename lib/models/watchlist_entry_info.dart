import 'package:equatable/equatable.dart';
import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/utils/enum_util.dart';

/// The watchlist info for a movie or a show, used for the watchlist
class WatchlistEntryInfo extends Equatable {
  final int id;
  final String title;
  final String posterPath;
  final EntryType entryType;

  WatchlistEntryInfo({this.id, this.title, this.posterPath, this.entryType});

  factory WatchlistEntryInfo.fromJsonTmdb(Map<String, dynamic> json, EntryType type) {
    if (type == EntryType.movie) {
      return WatchlistEntryInfo(
          id: json["id"],
          title: json["title"],
          posterPath: json["poster_path"],
          entryType: type);
    } else if (type == EntryType.show){
      return WatchlistEntryInfo(
          id: json["id"],
          title: json["name"],
          posterPath: json["poster_path"],
          entryType: type);
    }

    throw ArgumentError("Invalid entry type");
  }

  factory WatchlistEntryInfo.fromJsonFirestore(Map<String, dynamic> json) {
    final entryType = EnumUtil.enumFromString(EntryType.values, json["type"]);

      return WatchlistEntryInfo(
          id: json["id"],
          title: json["title"],
          posterPath: json["poster_path"],
          entryType: entryType);
    }
  }
