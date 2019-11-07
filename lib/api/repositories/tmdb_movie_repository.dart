import 'package:flutter/foundation.dart';
import 'package:movie_finder/api/tmdb_api.dart';
import 'package:movie_finder/models/genres_wrapper.dart';
import 'package:movie_finder/models/keywords.dart';

import 'dart:convert';

import 'package:movie_finder/models/movie_details.dart';
import 'package:movie_finder/models/movies_discover.dart';
import 'package:movie_finder/models/shows_discover.dart';

class TmdbMovieRepository {
  final TmdbAPI _api = TmdbAPI();

  Future<GenresWrapper> fetchMovieGenres() async {
    final response = await _api.fetchMovieGenres();
    return GenresWrapper.fromJson(json.decode(response.body));
  }

  Future<MoviesDiscover> fetchTrendingMovies(int page) async {
    final response = await _api.fetchTrendingMovies(page);
    return MoviesDiscover.fromJson(json.decode(response.body));
  }

  Future<MoviesDiscover> fetchMoviesInTheaters() async {
    final response = await _api.fetchMoviesInTheaters(1);
    return MoviesDiscover.fromJson(json.decode(response.body));
  }

  Future<MoviesDiscover> fetchUpcomingMovies() async {
    final response = await _api.fetchUpcomingMovies(1);
    return MoviesDiscover.fromJson(json.decode(response.body));
  }

  Future<MoviesDiscover> fetchSimilarFromMovie(int id) async {
    final response = await _api.fetchSimilarFromMovie(id);
    return MoviesDiscover.fromJson(json.decode(response.body));
  }

  Future<MoviesDiscover> fetchRecommendedForMovie(int id) async {
    final response = await _api.fetchRecommendedForMovie(1, id);
    return MoviesDiscover.fromJson(json.decode(response.body));
  }

  Future<MovieDetails> fetchMovieDetails(int id) async {
    final response = await _api.fetchMovieDetails(id);
    return MovieDetails.fromJson(json.decode(response.body));
  }

  Future<Keywords> fetchMovieKeywords(int id) async {
    final response = await _api.fetchMovieKeywords(id);

    return Keywords.fromJson(json.decode(response.body));
  }
}
