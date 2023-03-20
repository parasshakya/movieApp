
import 'package:flutter_app_2/models/comment.dart';
import 'package:flutter_app_2/services/crud_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../states/crud_state.dart';

final crudProvider = StateNotifierProvider<CrudNotifier, CrudState>((ref) => CrudNotifier(CrudState.empty()));

class CrudNotifier extends StateNotifier<CrudState>{
  CrudNotifier(super.state);

  Future<void> addPost({
    required String title,
    required String detail,
    required String userId,
    required XFile image
  }) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await CrudService.addPost(title: title, detail: detail, userId: userId, image: image);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);
    }
    );
  }

  Future<void> deletePost({
    required String postId,
    required String imageId,
  }) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await CrudService.deletePost(imageId: imageId, postId: postId);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);
    }
    );
  }

  Future<void> updatePost({
    required String title,
    required String detail,
    required String postId,
    required XFile? image,
    required String? oldImageId
  }) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await CrudService.updatePost(title: title, detail: detail, postId: postId, image: image, oldImageId: oldImageId);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);
    }
    );
  }

  Future<void> addLike({
    required int like,
    required List<String> usernames,
    required String postId
})async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await CrudService.addLike(usernames: usernames, like: like, postId: postId);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);
    }
    );
  }

  Future<void> disLike({
    required int like,
    required List<String> usernames,
    required String postId
  })async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await CrudService.disLike(usernames: usernames, like: like, postId: postId);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);
    }
    );
  }


  Future<void> addComment({
   required List<Comment> comments,
    required String postId
  })async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await CrudService.addComment(comments: comments, postId: postId);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);
    }
    );
  }

}