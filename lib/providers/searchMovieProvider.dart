import 'package:flutter/foundation.dart';
import 'package:flutter_app_2/api.dart';
import 'package:flutter_app_2/services/movie_service.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import '../models/movie.dart';
import '../states/movie_state.dart';

final searchProvider = StateNotifierProvider.autoDispose<SearchNotifier,MovieState>((ref) =>
    SearchNotifier(
        MovieState(
            upcomingMovies: [],
            isLoad: false,
            errorMessage: '',
            topRatedMovies: [],
            popularMovies: [],
            searchMovies: [],
            page: 1,
            isLoadMore: false
          ),
    )
);


class SearchNotifier extends StateNotifier<MovieState>{

  SearchNotifier(super.state);

  Future<void> getSearchMovie(String searchText) async{

      state = state.copyWith(isLoad: true, errorMessage: '');
      final response = await MovieService.getSearchMovie(searchText: searchText );
      response.fold((l) {
        state = state.copyWith(isLoad: false, errorMessage: l);
      }, (r) {
        state = state.copyWith(isLoad: false, searchMovies: r);
      });
    }


  }


