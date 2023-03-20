import 'dart:io';

import 'package:flutter_app_2/common/snack_show.dart';
import 'package:flutter_app_2/models/comment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_2/common/firebase_instances.dart';
import 'package:flutter_app_2/presentation/create_post_page.dart';

import 'package:flutter_app_2/providers/auth_provider.dart';
import 'package:flutter_app_2/providers/crud_provider.dart';
import 'package:flutter_app_2/providers/icon_provider.dart';
import 'package:flutter_app_2/providers/updatedImageProvider.dart';
import 'package:flutter_app_2/services/crud_service.dart';
import 'package:flutter_app_2/widgets/bottomNavigationBarWidget.dart';
import 'package:flutter_app_2/widgets/commentWidget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../providers/image_provider.dart';



class PostPage extends ConsumerWidget {


  final currentUserUid = FirebaseInstances.firebaseAuth.currentUser?.uid;
  late String currentUserName;
  late String currentUserImageUrl;
  final _form = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context,ref) {

    final crud = ref.watch(crudProvider);
    final usersStream = ref.watch(multiUserStream);
    final moviePostStream = ref.watch(moviePostStreamProvider);
    final singleUser = ref.watch(singleUserStream(currentUserUid!));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Movie Feed'),
        actions: [
        Container(
          width: 40.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child:   singleUser.when(data: (data) {
            currentUserName = data.firstName!;
            currentUserImageUrl = data.imageUrl!;

            return CircleAvatar(
              radius: 15,
              backgroundImage: CachedNetworkImageProvider(data.imageUrl!),
            );
          }, error: (err,stack){
            return Text('$err');
          }, loading: (){
            return CircularProgressIndicator();
          }),
        ),
          IconButton(onPressed: (){
            Get.to(() => CreatePost());
          }, icon: Icon(Icons.add, size: 30,))
        ],
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 110.h,
            child: usersStream.when(data: (data){
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                  itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 25,
                          backgroundImage: CachedNetworkImageProvider(data[index].imageUrl!) ),
                      SizedBox(height: 10.h,),
                      Align(
                        alignment: Alignment.center,
                        child: Text(data[index].firstName!),
                      )
                    ],
                  ),
                );
              });
            }, error: (err, stack){
              return Center(child: Text('$err'),);
            },
                loading: (){
              return Center(child: CircularProgressIndicator(),);
            }) ,

          ),
          Expanded(
            child: moviePostStream.when(

                data: (data) {

                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context,index)  {
                        final post = data[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: Column(

                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${post.title}'),

                                   if(post.userId == currentUserUid) PopupMenuButton<String>(
                                      onSelected: (String value) {
                                      if(value == 'delete'){
                                        ref.read(crudProvider.notifier).deletePost(postId: post.id, imageId: post.imageId);
                                        SnackShow.showSuccess(context,'Post Deleted Successfully');
                                      }
                                      if(value == 'edit'){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            final titleController = TextEditingController(text: '${post.title}');
                                            final descController = TextEditingController(text: '${post.detail}');



                                            return Consumer(
                                              builder: (context, ref, child) {


                                                final updatedImage = ref.watch(updatedImageProvider);
                                                return  Form(

                                                  key: _form,
                                                  child: AlertDialog(

                                                    title: Text('Edit Post'),
                                                    content: SizedBox(
                                                      height: 300.h,
                                                      child: Column(
                                                        children: [
                                                          TextFormField(
                                                            validator: (val){
                                                              if(val!.isEmpty){
                                                                return 'title is required';
                                                              }else if(val.length > 15){
                                                                return 'Title is too long';
                                                              }
                                                              return null;
                                                            },
                                                            controller: titleController,
                                                            decoration: InputDecoration(
                                                              hintText: 'Type your movie title here',
                                                            ),
                                                          ),
                                                          TextFormField(
                                                            controller: descController,
                                                            decoration: InputDecoration(
                                                              hintText: 'Type your movie description here',
                                                            ),
                                                            validator: (val){
                                                              if(val!.isEmpty){
                                                                return 'You must enter the description';
                                                              }else if(val.length>700){
                                                                return 'description is too long';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                          InkWell(
                                                            onTap: (){
                                                              ref.read(updatedImageProvider.notifier).pickAnImage();

                                                            },
                                                            child: Container(
                                                              height: 100.h,
                                                              width: 100.w,
                                                              color: Colors.white,
                                                              margin: EdgeInsets.symmetric(vertical: 20),
                                                              child: updatedImage == null ? Image.network('${post.imageUrl}') : Image.file(File(updatedImage.path)) ,
                                                            ),
                                                          ),


                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text('Cancel'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                      ElevatedButton(
                                                        child: crud.isLoad ? Center(child: CircularProgressIndicator(),) :
                                                        Text('Update Post',style: TextStyle(fontSize: 20.sp),),
                                                        onPressed: () {
                                                          _form.currentState!.save();
                                                          FocusScope.of(context).unfocus();
                                                          if(_form.currentState!.validate()){

                                                              ref.read(crudProvider.notifier).updatePost(title: titleController.text.trim(), detail: descController.text.trim(), postId: post.id, image: updatedImage, oldImageId: post.imageId);
                                                              Navigator.of(context).pop();
                                                              SnackShow.showSuccess(context, 'Post Updated Successfully');
                                                              titleController.clear();
                                                              descController.clear();


                                                          }


                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }
                                      },
                                      itemBuilder: (BuildContext context) => [
                                        PopupMenuItem<String>(
                                          value: 'edit',
                                          child: Text('Edit'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'delete',
                                          child: Text('Delete'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'share',
                                          child: Text('Share'),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),

                              Container(
                                child: crud.isLoad ? Center(child: CircularProgressIndicator(),) : Image.network(post.imageUrl),
                                height: 280.h,
                                width: double.infinity,
                                color: Colors.grey.shade900,

                              ),
                              SizedBox(height: 8.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                Container(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5.0,),
                                      Icon(Icons.thumb_up_alt, size: 22,),
                                      SizedBox(width: 5.0,),
                                      Text('${post.likes.likes}'),
                                    ],
                                  ),
                                ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text('${post.comment.length}'),
                                        SizedBox(width: 5.0,),
                                        Text('comments'),
                                        SizedBox(width: 5.0,),
                                        Container(
                                          width: 4,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[400],
                                          ),
                                        ),

                                        SizedBox(width: 5.0,),
                                        Text('2'),
                                        SizedBox(width: 5.0,),
                                        Text('shares'),
                                        SizedBox(width: 5.0,),

                                      ],
                                    ),
                                  )


                                ],
                              ),
                              SizedBox(height: 8.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        if(post.likes.usernames.contains(currentUserName)){

                                          ref.read(crudProvider.notifier)
                                              .disLike(like: post.likes.likes,
                                              usernames: post.likes.usernames,
                                              postId: post.id);

                                        }else {
                                          post.likes.usernames.add(currentUserName);
                                          ref.read(crudProvider.notifier)
                                              .addLike(like: post.likes.likes,
                                              usernames: post.likes.usernames,
                                              postId: post.id);
                                        }
                                      },
                                      icon: post.likes.toggleLike ? Icon(Icons.thumb_up) : Icon(Icons.thumb_up_alt_outlined),
                                      label: Text('Like'),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(0),
                                        ),
                                          backgroundColor: Colors.grey.shade800,
                                        elevation: 0
                                      ),

                                    ),
                                  ),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            String commentText = '';

                                            return AlertDialog(
                                              title: Text('Add a Comment'),
                                              content: TextField(


                                                onChanged: (value) {
                                                  commentText = value;
                                                },
                                                decoration: InputDecoration(
                                                  hintText: 'Type your comment here',
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                ElevatedButton(
                                                  child: Text('Post'),
                                                  onPressed: () {
                                                    if(commentText.isEmpty){
                                                      SnackShow.showFailure(context, 'Please enter a comment');

                                                    }else{
                                                      final commentUserName = currentUserName;
                                                      final commentUid = currentUserUid;
                                                      final comment = Comment(username: commentUserName , imageUrl: currentUserImageUrl, comment: commentText, uid: commentUid!);
                                                      post.comment.add(comment);

                                                      ref.read(crudProvider.notifier).addComment(comments: post.comment, postId: post.id);
                                                      // Do something with the comment text
                                                      Navigator.of(context).pop();
                                                      SnackShow.showSuccess(context, 'Comment Added Successfully');
                                                    }


                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                      },
                                      icon: Icon(Icons.comment_outlined),
                                      label: Text('Comment'),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(0),
                                        ),
                                        backgroundColor: Colors.grey.shade800,
                                        elevation: 0
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.share_outlined),
                                      label: Text('Share'),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(0),
                                        ),
                                          backgroundColor: Colors.grey.shade800,
                                        elevation: 0

                                      ),
                                    ),
                                  ),

                                ],
                              ),

                             if(post.comment.isNotEmpty)
                               ListView.builder(
                                 shrinkWrap: true,
                                 physics: NeverScrollableScrollPhysics(),
                                 itemCount: post.comment.length,
                                 itemBuilder: (context, index) {
                                   return Column(
                                     children: [
                                       Divider(
                                         color: Colors.grey[400], // set the color of the line
                                         height: 1, // set the height of the line
                                         thickness: 1, // set the thickness of the line
                                         indent: 20, // set the left indent of the line
                                         endIndent: 20, // set the right indent of the line
                                       ),
                                       CommentWidget(commenterName: post.comment[index].username , commenterProfilePicUrl: post.comment[index].imageUrl, commentText: post.comment[index].comment),
                                     ],
                                   );
                                 }, )

                            ],
                          ),
                        );
                      });
                },
                error: (err,stack) => Center(child: Text('$err')),
                loading: () => Center(child: CircularProgressIndicator(),)),
          )
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}
