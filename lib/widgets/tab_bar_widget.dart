import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../models/movie.dart';
import '../presentation/detail_page.dart';
import '../providers/movie_provider.dart';

class TabBarWidget extends StatelessWidget {
  final Categories categories;
  final String keys;
  TabBarWidget(this.categories,  this.keys);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: OfflineBuilder(
          child: Container(),
          connectivityBuilder: (context,connectivityResult, widget) {
            final bool connected = connectivityResult != ConnectivityResult.none;
            return connected ? Consumer(
              builder: (context, ref, child) {
                final movieData = ref.watch(movieProvider(categories));
                final data = categories == Categories.topRated ? movieData
                    .topRatedMovies : categories == Categories.upcoming
                    ? movieData.upcomingMovies
                    : movieData.popularMovies;
                return movieData.isLoad ? Center(
                  child: CircularProgressIndicator(),) : movieData.errorMessage
                    .isNotEmpty
                    ? Center(child: Text(movieData.errorMessage),)
                    : Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: ( scrollNotification) {

                      //this is rabyn sir's code
                      // final before = onNotification.metrics.extentBefore;
                      // final justBefore = onNotification.metrics.
                      // final max = onNotification.metrics.maxScrollExtent;
                      // if (before == max) {
                      //   ref.read(movieProvider(categories).notifier).loadMore();
                      // }

                      //this is the code from chatGPT to execute the loadMore() function quicker i.e before the scroll position reaches the end of the GriView.builder's list of movies
                      final offset = 150.0;
                      if (scrollNotification.depth == 0 &&
                          scrollNotification.metrics.pixels >=
                              scrollNotification.metrics.maxScrollExtent - offset) {
                        // code to run when the user scrolls just before the end of the list
                        // ...
                        ref.read(movieProvider(categories).notifier).loadMore();
                      }
                      return true;
                    },
                    child: GridView.builder(
                      key: PageStorageKey(keys),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: 2 / 3,
                          crossAxisCount: 3
                      ), itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () =>
                            Get.to(() => DetailPage(data[index]),
                                transition: Transition.leftToRight),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: data[index].poster_path,
                              placeholder: (context, string) {
                                return SizedBox(
                                  height: 150.h,
                                  child: Center(
                                    child: SpinKitCircle(
                                      size: 30.w,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                );
                              },
                              errorWidget: (c, s, d) {
                                return Image.asset(
                                    'assets/images/movieIcon.png');
                              },
                            )
                          ],
                        ),
                      );
                    },
                      itemCount: data.length,),
                  ),
                );
              },
            ) : Center(child: Text('No internet'),);
          }
        )
    );
  }
}
