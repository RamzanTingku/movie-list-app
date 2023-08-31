import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_list_app/core/constants/app_constants.dart';
import 'package:movie_list_app/data/model/movie_list.dart';

import '../../../core/constants/urls.dart';
import '../../../core/networking/dio_client.dart';
import '../../model/movie_genre.dart';

class MovieApiDataRepository{

  final Dio _dio;

  MovieApiDataRepository({Dio? dio}) : _dio = dio ?? DioClient.getDio(baseUrl: Urls.movieBaseUrl, token: AppConstants.API_TOKEN);

  Future<List<Genres>> getMovieGenre() async {
    try {
      final response = await _dio.get(Urls.movieGenreList);
      final jsonResponse = DioClient.responseDecode(response);
      final moveGenre = MovieGenre.fromJson(jsonResponse);
      return moveGenre.genres ?? [];
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }


  Future<List<MovieData>> getMovieList(String? genreId, int page) async {
    try {
      final response = await _dio.get(Urls.movieDiscoverList,
          queryParameters: {"with_genres":genreId, "page":page});
      final jsonResponse = DioClient.responseDecode(response);
      final moveGenre = MovieListResponse.fromJson(jsonResponse);
      return moveGenre.results ?? [];
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }


}