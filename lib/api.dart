import 'package:flutter_app_2/models/video.dart';

class Api{
  static const baseUrl = 'https://api.themoviedb.org/3';
  static const popularMovie = '$baseUrl/movie/popular';
  static const topRatedMovie = '$baseUrl/movie/top_rated';
  static const upcomingMovie = '$baseUrl/movie/upcoming';
  static const searchMovie = '$baseUrl/search/movie';
  static const video = '$baseUrl/movie';

}