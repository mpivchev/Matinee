import 'package:http/http.dart';

class TmdbAPI {
  static const baseUrl = "https://api.themoviedb.org/3";
  static const apiKey = "1534be0a6bea8df725ab5edc224234d6";

  Future<Response> fetchMovieGenres() async {
    return get("$baseUrl/genre/movie/list?api_key=$apiKey");
  }

  Future<Response> fetchShowGenres() async {
    return get("$baseUrl/genre/tv/list?api_key=$apiKey");
  }

  // Future<Response> fetchDiscoverMovies(int page, {String keywordIds = ""}) async {
  //   return get("$baseUrl/discover/movie?api_key=$apiKey&page=$page&with_keywords=$keywordIds");
  // }

  Future<Response> fetchMoviesInTheaters(int page) async {
    return get("$baseUrl/movie/now_playing?region=US&api_key=$apiKey&page=$page");
//    return get("$baseUrl/movie/now_playing?api_key=$apiKey&page=$page");
  }

  // Future<Response> fetchDiscoverShows(int page, {String keywordIds = ""}) async {
  //   return get("$baseUrl/discover/tv?api_key=$apiKey&page=$page&with_keywords=$keywordIds");
  // }

//  Future<Response> fetchPopularMovies(int page) async {
//    return get("$baseUrl/movie/popular?api_key=$apiKey&page=$page");
//  }

  Future<Response> fetchTrendingMovies(int page) async {
    return get("$baseUrl/trending/movie/day?region=US&api_key=$apiKey&page=$page");
  }

  Future<Response> fetchUpcomingMovies(int page) async {
    return get("$baseUrl/movie/upcoming?region=US&api_key=$apiKey&page=$page");
//    return get("$baseUrl/movie/upcoming?api_key=$apiKey&page=$page");
  }

  Future<Response> fetchTrendingShows(int page) async {
    return get("$baseUrl/trending/tv/day?region=US&api_key=$apiKey&page=$page");
  }

  Future<Response> fetchRecommendedForMovie(int page, int movieId) async {
    return get("$baseUrl/movie/$movieId/similar?api_key=$apiKey");
  }

  Future<Response> fetchRecommendedForShow(int page, int showId) async {
    return get("$baseUrl/tv/$showId/similar?api_key=$apiKey");
  }

  Future<Response> fetchMovieDetails(int movieId) async {
    return get("$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=keywords");
  }

  Future<Response> fetchShowDetails(int showId) async {
    return get(
        "$baseUrl/tv/$showId?api_key=$apiKey&append_to_response=keywords");
  }

  Future<Response> fetchSimilarFromMovie(int movieId) async {
    return get("$baseUrl/movie/$movieId/similar?api_key=$apiKey");
  }

  Future<Response> fetchMovieKeywords(int movieId) async {
    return get("$baseUrl/movie/$movieId/keywords?api_key=$apiKey");
  }

  Future<Response> fetchShowKeywords(int movieId) async {
    return get("$baseUrl/tv/$movieId/keywords?api_key=$apiKey");
  }
}
