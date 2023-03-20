import '../models/movie.dart';
import '../models/video.dart';
import 'movie_state.dart';

class VideoState{
  final bool isLoad;
  final List<Video> videos;
  final String errorMessage;


  VideoState({required this.errorMessage, required this.isLoad, required this.videos});



  VideoState copyWith({bool? isLoad, String? errorMessage, List<Video>? videos}){
    return VideoState(
        errorMessage: errorMessage ?? this.errorMessage,
        isLoad: isLoad ?? this.isLoad,
      videos: videos ?? this.videos,
    );

  }
}