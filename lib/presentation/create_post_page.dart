import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app_2/common/firebase_instances.dart';
import 'package:flutter_app_2/common/snack_show.dart';
import 'package:flutter_app_2/providers/crud_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/image_provider.dart';
import '../states/crud_state.dart';



class CreatePost extends ConsumerWidget {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;

  @override
  Widget build(BuildContext context, ref) {
    final crud = ref.watch(crudProvider);
    final image = ref.watch(imageProvider);
    ref.listen(crudProvider, (previous, next) {
      if (next is CrudState){
        if(next.errorMessage.isNotEmpty){
          SnackShow.showFailure(context, next.errorMessage);
        }else if(next.isSuccess){
          SnackShow.showSuccess(context, 'Post Created' );

        }
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,

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
                Text( 'Create Movie Post',style: TextStyle(fontSize: 25.sp,color: Color(0xFFFFFCB2B),fontWeight: FontWeight.bold),),
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
                   Padding(
                          padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 8),
                          child: TextFormField(
                              controller: titleController,
                              validator: (val){
                                if(val!.isEmpty){
                                  return 'Movie title is required';
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
                                  hintText: 'Enter movie title', hintStyle: TextStyle(color: Colors.white54)
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 8),
                          child: TextFormField(
                              controller: descriptionController,
                              validator: (val){
                                if(val!.isEmpty){
                                  return 'Movie description is required';
                                }else if(val.length > 700){
                                  return 'Maximum words reached';
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
                                  hintText: 'Enter movie description', hintStyle: TextStyle(color: Colors.white54)
                              )
                          ),
                        ),

                        InkWell(
                          onTap: (){
                            ref.read(imageProvider.notifier).pickAnImage();
                          },
                          child: Container(
                            height: 150.h,
                            width: 200.w,
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: image == null ? Center(child: Text('select a movie poster', style: TextStyle(color: Colors.black),)) : Image.file(File(image.path)),
                          ),
                        ),
                        SizedBox(height: 10.h,),

                        TextButton(

                            onPressed: (){
                            _form.currentState!.save();
                            FocusScope.of(context).unfocus();
                            if(_form.currentState!.validate()){

                            if(image == null){
                            SnackShow.showFailure(context, 'please select an image');
                            }else {

                              ref.read(crudProvider.notifier).addPost(title: titleController.text.trim(), detail: descriptionController.text.trim(), userId: uid , image: image);

                            }

                            }
                            },

                            child: crud.isLoad ? Center(child: CircularProgressIndicator(),) :
                            Text('Create Post',style: TextStyle(fontSize: 20.sp),))

                      ],
                    ),
                  ),
                ),

              ],

            ),
          ),
        ),
      ),
    );

  }
}