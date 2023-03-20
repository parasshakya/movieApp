import 'package:flutter_app_2/presentation/auth_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../providers/auth_provider.dart';
import 'home_page.dart';

class StatusPage extends ConsumerWidget{

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FlutterNativeSplash.remove();
    final authStream = ref.watch(authStreamProvider);
    // TODO: implement build
    return Container(
      child: authStream.when(data: (data){
        if(data == null){
          return AuthPage();
        }else{
          return HomePage();
        }
      }, error: (error, stackTrace){
        return Center(child: Text('$error'),);
      }, loading: (){
        return Center(child: CircularProgressIndicator(),);
      })
    );
  }

}