

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_2/common/firebase_instances.dart';
import 'package:flutter_app_2/services/auth_service.dart';
import 'package:flutter_app_2/states/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

final authStreamProvider = StreamProvider.autoDispose((ref) => FirebaseInstances.firebaseAuth.authStateChanges());
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(AuthState.empty()));
final multiUserStream = StreamProvider.autoDispose((ref) => FirebaseInstances.firebaseChatCore.users());
final singleUserStream = StreamProvider.family.autoDispose((ref, String userId){
  final CollectionReference userCollection = FirebaseInstances.firebaseFirestore.collection('users');
  return userCollection.doc(userId).snapshots().map((e) {
    final data = e.data() as Map<String, dynamic>;
   return types.User(
      id: e.id,
      firstName: data['firstName'],
      imageUrl: data['imageUrl'],
      metadata: {
        'email' : data['metadata']['email'],
        'token' : data['metadata']['token']
      },
  ); });
});
class AuthNotifier extends StateNotifier<AuthState>{
  AuthNotifier(super.state);

  Future<void> userSignUp({
    required String username,
    required String email,
    required String password,
    required XFile image
  }) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false, isLogOut: false);
    final response = await AuthService.userSignup(username: username, email: email, password: password, image: image);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false, isLogOut: false);
      }, (r) {
              state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);
            }
    );
  }

  Future<void> userLogin({
    required String email,
    required String password
  }) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false, isLogOut: false);
    final response = await AuthService.userLogin(email: email, password: password);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false, isLogOut: false);
    }, (r) {
      state = state.copyWith(isLoad: false,errorMessage:'', isSuccess: true, isLogOut:false);
    });

  }

  Future<void> userLogOut() async{
    state = state.copyWith(isLoad:true, errorMessage: '', isSuccess: false, isLogOut: false);
    final response = await AuthService.userLogOut();
    response.fold((l) {
      state = state.copyWith(isSuccess: false, errorMessage: l, isLoad: false, isLogOut:false);
    }, (r) {
      state = state.copyWith(isSuccess: false, errorMessage: '', isLoad: false, isLogOut: true);
    });
  }

}