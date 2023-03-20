import'package:flutter/material.dart';
import 'package:flutter_app_2/models/movie.dart';
import 'package:flutter_app_2/providers/movie_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pod_player/pod_player.dart';

import '../providers/video_provider.dart';

class PlayVideoFromNetwork extends StatefulWidget {
  final String keys;
  final Movie movie;
  PlayVideoFromNetwork(this.keys, this.movie);

  @override
  State<PlayVideoFromNetwork> createState() => _PlayVideoFromNetworkState();
}

class _PlayVideoFromNetworkState extends State<PlayVideoFromNetwork> {
  late final PodPlayerController controller;

  @override
  void initState() {
    controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.youtube('https://youtu.be/${widget.keys}'),
        podPlayerConfig: const PodPlayerConfig(
            autoPlay: true,
            // isLooping: false,
            videoQualityPriority: [1080, 720]
        )
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PodVideoPlayer(controller: controller,
      videoTitle: Text(widget.movie.title),
    );
  }
}



class DetailPage extends ConsumerWidget {
  final Movie movie;
  DetailPage(this.movie);
  @override
  Widget build(BuildContext context,ref) {
    final videoData = ref.watch(videoProvider(movie.id));
    return  Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          if(videoData.videos.isNotEmpty) PlayVideoFromNetwork(videoData.videos[0].key, movie),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(movie.title, style: TextStyle(fontSize: 20.sp, fontStyle: FontStyle.italic),),
              ),
            ),
          ),
          Card(
            color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(movie.overview),
              )),
          SizedBox(height: 8.h,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                height: 300.h,
                child: Image.network(movie.poster_path),
              ),
              SizedBox(width: 50.w,),
              Expanded(child: Text('Vote: ${movie.vote_average}', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),)),
            ],
          ),
          if(videoData.errorMessage.isNotEmpty) Center(child: Text(videoData.errorMessage)),

        ],
      ),
    );
  }
}
