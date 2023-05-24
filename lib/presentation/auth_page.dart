
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_2/common/snack_show.dart';
import 'package:flutter_app_2/presentation/phone_page.dart';
import 'package:flutter_app_2/states/auth_state.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/ToggleProvider.dart';
import '../providers/auth_provider.dart';
import '../providers/image_provider.dart';
import 'home_page.dart';


class AuthPage extends ConsumerWidget {

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ref) {
    FlutterNativeSplash.remove();

    final isToggle = ref.watch(toggleProvider);
    final image = ref.watch(imageProvider);
    final auth = ref.watch(authProvider);
    ref.listen(authProvider, (previous, next) {
      if (next is AuthState){

        if(next.errorMessage.isNotEmpty){
          SnackShow.showFailure(context, next.errorMessage);
        }else if(next.isSuccess){
          SnackShow.showSuccess(context, 'Login Successful' );
        }else if (next.isLogOut){
          SnackShow.showSuccess(context, 'LogOut Successful');
        }
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.movie_creation_outlined,color: Color(0xFFFFFCB2B),),
            SizedBox(width: 10.w,),
            Text('MoviePlus',style: TextStyle(fontSize: 25.sp, color: Color(0xFFFFFCB2B) ),),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Center(
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text( isToggle ? 'Login Page' : 'Sign up Page',style: TextStyle(fontSize: 25.sp,color: Color(0xFFFFFCB2B),fontWeight: FontWeight.bold),),
                SizedBox(
                  height: 20.h,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.brown,
                    height: 500.h,
                    width: 300.w,
                    child: Column(
                      children: [
                        if (!isToggle) Padding(
                          padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 8),
                          child: TextFormField(
                              controller: userNameController,
                              validator: (val){
                                if(val!.isEmpty){
                                  return 'username is required';
                                }else if(val.length > 20){
                                  return 'maximum character exceeded';
                                }
                                return null;

                              },
                              // style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(

                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                  enabledBorder: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),

                                  // fillColor: Colors.black,
                                  filled: true,
                                  hintText: 'Enter an username', hintStyle: TextStyle(color: Colors.white54)
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 8),
                          child: TextFormField(
                              controller: emailController,
                              validator: (val){
                                if(val!.isEmpty){
                                  return 'username is required';
                                }else if(!val.contains('@')){
                                  return 'please enter valid email';
                                }
                                return null;

                              },

                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),

                                  // fillColor: Colors.black,
                                  filled: true,
                                  hintText: 'E-MAIL', hintStyle: TextStyle(color: Colors.white54)
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 8),
                          child: TextFormField(
                            obscureText: true,
                              controller: passwordController,
                              validator: (val){
                                if(val!.isEmpty){
                                  return 'password is required';
                                }else if(val.length > 30){
                                  return 'password length exceeded';
                                }
                                return null;

                              },

                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  // fillColor: Colors.black,
                                  filled: true,
                                  hintText: 'Password', hintStyle: TextStyle(color: Colors.white54)
                              )
                          ),
                        ),
                       if(!isToggle) InkWell(
                         onTap: (){
                           ref.read(imageProvider.notifier).pickAnImage();
                         },
                          child: Container(
                            height: 150.h,
                            width: 200.w,
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: image == null ? Center(child: Text('select an image', style: TextStyle(color: Colors.black),)) : Image.file(File(image.path)),
                          ),
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.amberAccent,
                              backgroundColor: Colors.grey.shade900,
                            ),
                            onPressed: (){
                              _form.currentState!.save();
                              FocusScope.of(context).unfocus();
                              if(_form.currentState!.validate()){
                                if(isToggle){
                                  ref.read(authProvider.notifier).userLogin(email: emailController.text.trim(), password: passwordController.text.trim());
                                  if(auth.isSuccess){
                                    Get.to(() => HomePage() );
                                  }
                                }

                                else {
                                  if(image == null){
                                    SnackShow.showFailure(context, 'please select an image');
                                  }else {
                                    ref.read(authProvider.notifier).userSignUp(
                                        username: userNameController.text
                                            .trim(),
                                        email: emailController.text.trim(),
                                        password: passwordController.text
                                            .trim(),
                                        image: XFile(image!.path));
                                    if(auth.isSuccess){
                                      Get.to(() => HomePage() );
                                    }
                                  }

                                }
                              }
                            },
                            child: auth.isLoad ? Center(child: CircularProgressIndicator(),) : Text(isToggle ? 'Login' : 'SignUp',style: TextStyle(fontSize: 20.sp),))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isToggle ? 'Don\'t have an account ?' : 'Already have an account ?',style: TextStyle(color: Colors.grey),),
                    TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Color(0xFFFFFCB2B)
                        ),
                        onPressed: (){
                          _form.currentState!.reset();
                          emailController.clear();
                          passwordController.clear();
                          ref.read(toggleProvider.notifier).change();
                        },
                        child: Text(isToggle ? 'Create One' : 'Go to Login Page',))
                  ],
                ),
                SizedBox(height : 10),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFFFFFCB2B),
                  ),
                  onPressed: (){
                    Get.to(() => PhonePage());
                  }, child: Text('Phone Verfication', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                )

              ],

            ),
          ),
        ),
      ),
    );

  }
}