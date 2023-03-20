import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/searchMovieProvider.dart';

class SearchPage extends ConsumerWidget {
  final searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context, ref) {
    final movieData = ref.watch(searchProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

         // title:  Text("Movie ", style: TextStyle(color: const Color(0xFFE50914),fontSize: 30.sp),),
        // actions: [
        //   Center(child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Text("SEARCH", style: TextStyle(fontWeight: FontWeight.bold),),
        //   )),
        // ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchTextController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "search for movies",
                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  )
                ),
                onFieldSubmitted: (val){
                  ref.read(searchProvider.notifier).getSearchMovie(val);

                },
              ),
            ),
            Expanded(
                child: movieData.isLoad ? Center(
              child: CircularProgressIndicator(),
            ) : movieData.errorMessage.isNotEmpty ? Center(child: Text(movieData.errorMessage, style: TextStyle(fontSize: 25.sp),)) :
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: 2/3,
                        crossAxisCount: 3
                    ), itemBuilder:(context,index){
                    return Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: movieData.searchMovies[index].poster_path,
                          placeholder: (context,string){
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
                          errorWidget: (c,s,d){
                            return Center(child: Image.asset('assets/images/movieIcon.png'));
                          },
                        )
                      ],
                    );
                  },
                    itemCount: movieData.searchMovies.length ,),
                )
            ),
          ],
        ),
      ),
    );
  }
}
