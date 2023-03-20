import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_2/common/firebase_instances.dart';
import 'package:flutter_app_2/providers/auth_provider.dart';
import 'package:flutter_app_2/providers/proPicProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountPage extends ConsumerWidget{

  final currentUser = FirebaseInstances.firebaseAuth.currentUser;
  final String _profilePictureUrl =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png';

  @override
  Widget build(BuildContext context, ref) {
    final proPic = ref.watch(proPicProvider);
    final singleUser = ref.watch(singleUserStream(currentUser!.uid));
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Column(

        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 200.w,
              height: 200.h,
              child: singleUser.when(data: (data){

                if(proPic == null) {
                  return Image.network(data.imageUrl!);
                }else{
                  return Image.file(File(proPic.path));
                }
              }, error: (error,stack){

              }, loading: () {
              }),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            child: Text('Change Profile Picture'),
            onPressed: () {
              ref.read(proPicProvider.notifier).pickAnImage();

              // TODO: Implement logic to change profile picture
            },

          ),
    ElevatedButton(
    child: Text('Change Account Password'),
    onPressed: () {
      _showChangePasswordDrawer(context);
    // TODO: Implement logic to change profile picture
    },)
        ],
      ),
    );
  }
  void _showChangePasswordDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement change password logic
                      Navigator.pop(context);
                    },
                    child: Text('Change Password'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}