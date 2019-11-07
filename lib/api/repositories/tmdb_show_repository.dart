import 'package:flutter/foundation.dart';
import 'package:movie_finder/api/tmdb_api.dart';
import 'package:movie_finder/models/genres_wrapper.dart';
import 'package:movie_finder/models/keywords.dart';

import 'dart:convert';

import 'package:movie_finder/models/movie_details.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/shows_discover.dart';


class TmdbShowRepository {
  final TmdbAPI _api = TmdbAPI();

  Future<ShowsDiscover> fetchTrendingShows(int page) async {
    final response = await _api.fetchTrendingShows(page);
    return ShowsDiscover.fromJson(json.decode(response.body));
  }

  Future<ShowsDiscover> fetchRecommendedForShow(int id) async {
    final response = await _api.fetchRecommendedForShow(1, id);
    return ShowsDiscover.fromJson(json.decode(response.body));
  }

  Future<Keywords> fetchShowKeywords(int id) async {
    final response = await _api.fetchShowKeywords(id);

    return Keywords.fromJson(json.decode(response.body));
  }
}
