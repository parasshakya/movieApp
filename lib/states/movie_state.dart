import '../models/movie.dart';

class MovieState{
  final bool isLoad;
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> upcomingMovies;
  final List<Movie> searchMovies;
  final int page;
  final bool isLoadMore;
  final String errorMessage;


  MovieState({required this.isLoadMore, required this.page,required this.searchMovies,required this.errorMessage, required this.isLoad, required this.popularMovies, required this.topRatedMovies, required this.upcomingMovies});



  MovieState copyWith({bool? isLoadMore,int? page,bool? isLoad, String? errorMessage, List<Movie>? upcomingMovies, List<Movie>? popularMovies, List<Movie>? topRatedMovies, List<Movie>? searchMovies}){
    return MovieState(
        errorMessage: errorMessage ?? this.errorMessage,
        isLoad: isLoad ?? this.isLoad,
        popularMovies: popularMovies ?? this.popularMovies,
        upcomingMovies: upcomingMovies ?? this.upcomingMovies,
        topRatedMovies: topRatedMovies ?? this.topRatedMovies,
        searchMovies: searchMovies ?? this.searchMovies,
        page: page ?? this.page,
        isLoadMore : isLoadMore ?? this.isLoadMore


    );

  }
}