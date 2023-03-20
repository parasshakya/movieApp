import 'package:flutter/foundation.dart';
import 'package:flutter_app_2/api.dart';
import 'package:flutter_app_2/services/movie_service.dart';
import 'package:flutter_app_2/states/video_state.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import '../models/movie.dart';
import '../states/movie_state.dart';

final videoProvider = StateNotifierProvider.family<VideoNotifier,VideoState, int>((ref, int movieId) =>
    VideoNotifier(
      VideoState(
          isLoad: false,
          errorMessage: '',
          videos: []
    ),
    movieId
));


class VideoNotifier extends StateNotifier<VideoState>{
  final int movieId;
  VideoNotifier(super.state, this.movieId){
    getVideo();
  }

  Future<void> getVideo() async{

    state = state.copyWith(isLoad: true, errorMessage: '');
    final response = await MovieService.getVideo(movieId: movieId);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l);
    }, (r) {
      state = state.copyWith(isLoad: false, videos: r);
    });
  }


}


