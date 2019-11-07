// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:movie_finder/constants/constants.dart';
import 'package:movie_finder/models/watchlist_entry_info.dart';

ShowsDiscover showsDiscoverFromJson(String str) =>
    ShowsDiscover.fromJson(json.decode(str));

String showsDiscoverToJson(ShowsDiscover data) => json.encode(data.toJson());

class ShowsDiscover {
  int page;
  int totalResults;
  int totalPages;
  List<ShowEntry> entries;

  ShowsDiscover({
    this.page,
    this.totalResults,
    this.totalPages,
    this.entries,
  });

  factory ShowsDiscover.fromJson(Map<String, dynamic> json) =>
      new ShowsDiscover(
        page: json["page"],
        totalResults: json["total_results"],
        totalPages: json["total_pages"],
        entries: new List<ShowEntry>.from(
            json["results"].map((x) => ShowEntry.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "total_results": totalResults,
        "total_pages": totalPages,
        "results": new List<dynamic>.from(entries.map((x) => x.toJson())),
      };
}

class ShowEntry {
  String originalName;
  List<int> genreIds;
  String title;
  double popularity;
  List<OriginCountry> originCountry;
  int voteCount;
  DateTime releaseDate;
  String backdropPath;
  OriginalLanguage originalLanguage;
  int id;
  double voteAverage;
  String overview;
  String posterPath;

  WatchlistEntryInfo watchlistInfo;

  bool upcoming;

  ShowEntry(
      {this.originalName,
      this.genreIds,
      this.title,
      this.popularity,
      this.originCountry,
      this.voteCount,
      this.releaseDate,
      this.backdropPath,
      this.originalLanguage,
      this.id,
      this.voteAverage,
      this.overview,
      this.posterPath,
      this.watchlistInfo}) {
    upcoming = (releaseDate == null || DateTime.now().isBefore(releaseDate));
  }

  factory ShowEntry.fromJson(Map<String, dynamic> json) => new ShowEntry(
        originalName: json["original_name"],
        genreIds: new List<int>.from(json["genre_ids"].map((x) => x)),
        title: json["name"],
        popularity: json["popularity"].toDouble(),
        originCountry: new List<OriginCountry>.from(
            json["origin_country"].map((x) => originCountryValues.map[x])),
        voteCount: json["vote_count"],
        releaseDate: DateTime.parse(json["first_air_date"]),
        backdropPath: json["backdrop_path"],
        originalLanguage: originalLanguageValues.map[json["original_language"]],
        id: json["id"],
        voteAverage: json["vote_average"].toDouble(),
        overview: json["overview"],
        posterPath: json["poster_path"],
        watchlistInfo: WatchlistEntryInfo.fromJsonTmdb(json, EntryType.show),
      );

  Map<String, dynamic> toJson() => {
        "original_name": originalName,
        "genre_ids": new List<dynamic>.from(genreIds.map((x) => x)),
        "name": title,
        "popularity": popularity,
        "origin_country": new List<dynamic>.from(
            originCountry.map((x) => originCountryValues.reverse[x])),
        "vote_count": voteCount,
        "first_air_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "backdrop_path": backdropPath,
        "original_language": originalLanguageValues.reverse[originalLanguage],
        "id": id,
        "vote_average": voteAverage,
        "overview": overview,
        "poster_path": posterPath,
      };
}

enum OriginCountry { US, JP, ES }

final originCountryValues = new EnumValues(
    {"ES": OriginCountry.ES, "JP": OriginCountry.JP, "US": OriginCountry.US});

enum OriginalLanguage { EN, JA, ES }

final originalLanguageValues = new EnumValues({
  "en": OriginalLanguage.EN,
  "es": OriginalLanguage.ES,
  "ja": OriginalLanguage.JA
});

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
