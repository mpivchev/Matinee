// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';

MoviesDiscover welcomeFromJson(String str) =>
    MoviesDiscover.fromJson(json.decode(str));

String welcomeToJson(MoviesDiscover data) => json.encode(data.toJson());

class MoviesDiscover {
  int page;
  int totalResults;
  int totalPages;
  List<MovieEntry> entries;

  MoviesDiscover({
    this.page,
    this.totalResults,
    this.totalPages,
    this.entries,
  });

  factory MoviesDiscover.fromJson(Map<String, dynamic> json) =>
      new MoviesDiscover(
        page: json["page"],
        totalResults: json["total_results"],
        totalPages: json["total_pages"],
        entries: new List<MovieEntry>.from(
            json["results"].map((x) => MovieEntry.fromJson(x))),
//        watchlistEntries: new List<WatchlistInfo>.from(
//            json["results"].map((x) => WatchlistInfo.fromJsonMovie(x))),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "total_results": totalResults,
        "total_pages": totalPages,
        "results": new List<dynamic>.from(entries.map((x) => x.toJson())),
      };
}

class MovieEntry {
  int voteCount;
  int id;
  bool video;
  double voteAverage;
  String title;
  double popularity;
  String posterPath;
  OriginalLanguage originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String backdropPath;
  bool adult;
  String overview;
  DateTime releaseDate;
  WatchlistEntryInfo watchlistInfo;

  bool upcoming;

  MovieEntry({
    this.voteCount,
    this.id,
    this.video,
    this.voteAverage,
    this.title,
    this.popularity,
    this.posterPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.backdropPath,
    this.adult,
    this.overview,
    this.releaseDate,
    this.watchlistInfo,
  }) {
    upcoming = (releaseDate == null || DateTime.now().isBefore(releaseDate));
  }

  factory MovieEntry.fromJson(Map<String, dynamic> json) {
    return new MovieEntry(
      voteCount: json["vote_count"],
      id: json["id"],
      video: json["video"],
      voteAverage: json["vote_average"].toDouble(),
      title: json["title"],
      popularity: json["popularity"].toDouble(),
      posterPath: json["poster_path"],
      originalLanguage: originalLanguageValues.map[json["original_language"]],
      originalTitle: json["original_title"],
      genreIds: new List<int>.from(json["genre_ids"].map((x) => x)),
      backdropPath: json["backdrop_path"],
      adult: json["adult"],
      overview: json["overview"],
      releaseDate: DateTime.tryParse(json["release_date"]),
      watchlistInfo: WatchlistEntryInfo.fromJsonTmdb(json, EntryType.movie),
    );
  }

  Map<String, dynamic> toJson() => {
        "vote_count": voteCount,
        "id": id,
        "video": video,
        "vote_average": voteAverage,
        "title": title,
        "popularity": popularity,
        "poster_path": posterPath,
        "original_language": originalLanguageValues.reverse[originalLanguage],
        "original_title": originalTitle,
        "genre_ids": new List<dynamic>.from(genreIds.map((x) => x)),
        "backdrop_path": backdropPath,
        "adult": adult,
        "overview": overview,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
      };
}

enum OriginalLanguage { EN, JA }

final originalLanguageValues =
    new EnumValues({"en": OriginalLanguage.EN, "ja": OriginalLanguage.JA});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
