import 'package:flutter/material.dart';
import 'package:flutter_app_2/common/firebase_instances.dart';
import 'package:flutter_app_2/presentation/contact_us_page.dart';
import 'package:flutter_app_2/presentation/post_page.dart';
import 'package:flutter_app_2/presentation/search_page.dart';
import 'package:flutter_app_2/presentation/settings_page.dart';
import 'package:flutter_app_2/providers/auth_provider.dart';
import 'package:flutter_app_2/widgets/tab_bar_widget.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../models/movie.dart';

class HomePage extends ConsumerWidget {


  @override
  Widget build(BuildContext context,ref) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: Drawer(
            width: 280.w,
            child: ListView(
              padding: EdgeInsets.only(top: 20),
              children: [
                ListTile(
                  onTap: (){
                    Navigator.of(context).pop();
                    Get.to(() => PostPage());
                  },
                  leading: Icon(Icons.feed_outlined),
                  title: Text('Movie Feed'),
                ),
                ListTile(
                  onTap: (){
                    Get.to(() => SettingsPage());
                  },
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
                ListTile(
                  onTap: (){
                    Get.to(() => ContactUsPage());
                  },
                  leading: Icon(Icons.contact_support_outlined),
                  title: Text('Contact us'),
                ),
                ListTile(
                  onTap: (){
                    ref.read(authProvider.notifier).userLogOut();
                  },
                  leading: Icon(Icons.logout),
                  title: Text('LogOut'),
                )
              ],
            ),
          ),
          appBar: AppBar(
            toolbarHeight: 100.h,
            title:  Text("Movie Trailers", style: TextStyle(color: const Color(0xFFE50914), fontSize: 30.sp),),
            actions: [
              IconButton(onPressed: (){
                Get.to(()=> SearchPage(), transition: Transition.leftToRight);
              }, icon:  const Icon(Icons.search, size: 30,)),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Popular' ,),
                Tab(text: 'Upcoming',),
                Tab(text: 'Top Rated',)
              ],
            ),
          ),
          body: TabBarView(children: [
            TabBarWidget(Categories.popular, '1'),
            TabBarWidget(Categories.upcoming, '2'),
            TabBarWidget(Categories.topRated, '3'),
          ]),
        ),
      ),
    );
  }
}
