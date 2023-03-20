import 'package:flutter/foundation.dart';
import 'package:flutter_app_2/api.dart';
import 'package:flutter_app_2/services/movie_service.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import '../models/movie.dart';
import '../states/movie_state.dart';

final movieProvider = StateNotifierProvider.family<MovieStateNotifier,MovieState, Categories>((ref,Categories category) =>
    MovieStateNotifier(
        MovieState(
    upcomingMovies: [],
    isLoad: false,
    errorMessage: '',
    topRatedMovies: [],
    popularMovies: [],
        searchMovies: [],
        page: 1, isLoadMore: false
        ),
    category)
);


class MovieStateNotifier extends StateNotifier<MovieState>{
  final Categories category;

  MovieStateNotifier(super.state, this.category){
    getMovie();
  }

  Future<void> getMovie() async{
    if(category == Categories.upcoming){
      state = state.copyWith(isLoad: state.isLoadMore ? false : true, errorMessage: '');
      final response = await MovieService.getMovie(apiPath: Api.upcomingMovie, page: state.page);
      response.fold((l) {
        state = state.copyWith(isLoad: false, errorMessage: l);
      }, (r) {
        state = state.copyWith(isLoad: false, upcomingMovies: [...state.upcomingMovies,...r]);
      });
    }else if(category == Categories.popular){
      state = state.copyWith(isLoad: state.isLoadMore ? false : true, errorMessage: '');
      final response = await MovieService.getMovie(apiPath: Api.popularMovie, page: state.page);
      response.fold((l) {
        state = state.copyWith(isLoad: false, errorMessage: l);
      }, (r) {
        state = state.copyWith(isLoad: false, popularMovies: [...state.popularMovies, ...r]);
      });
    }else{
      state = state.copyWith(isLoad: state.isLoadMore ? false : true, errorMessage: '');
      final response = await MovieService.getMovie(apiPath: Api.topRatedMovie, page: state.page);
      response.fold((l) {
        state = state.copyWith(isLoad: false, errorMessage: l);
      }, (r) {
        state = state.copyWith(isLoad: false, topRatedMovies: [...state.topRatedMovies,...r]);
      });
    }


  }

void loadMore(){
    state = state.copyWith(
      page: state.page + 1,
      isLoadMore: true
    );
    getMovie();
}
}