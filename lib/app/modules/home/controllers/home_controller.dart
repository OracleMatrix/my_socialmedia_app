import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_socialmedia_app/app/data/Constants/constants.dart';
import 'package:my_socialmedia_app/app/modules/home/Models/get_all_posts_model.dart';
import 'package:my_socialmedia_app/app/modules/home/providers/comment_on_post_provider.dart';
import 'package:my_socialmedia_app/app/modules/home/providers/create_post_provider.dart';
import 'package:my_socialmedia_app/app/modules/home/providers/delete_post_provider.dart';
import 'package:my_socialmedia_app/app/modules/home/providers/dislike_post_provider.dart';
import 'package:my_socialmedia_app/app/modules/home/providers/get_all_posts_provider.dart';
import 'package:my_socialmedia_app/app/modules/home/providers/like_post_provider.dart';

class HomeController extends GetxController {
  var _isLoading = false.obs;
  get isLoading => _isLoading.value;

  set isLoading(var value) => _isLoading = value;

  var _getAllPostsProvider = GetAllPostsProvider();
  get getAllPostsProvider => _getAllPostsProvider;

  set getAllPostsProvider(var value) => _getAllPostsProvider = value;

  var _createPostProvider = CreatePostProvider();
  get createPostProvider => _createPostProvider;

  set createPostProvider(var value) => _createPostProvider = value;

  var postsData = GetAllPostsModel().obs;

  var _titleController = TextEditingController().obs;
  var _contentController = TextEditingController().obs;
  var _commentController = TextEditingController().obs;

  get commentController => _commentController;

  set commentController(var value) => _commentController = value;

  get titleController => _titleController;

  set titleController(value) => _titleController = value;

  get contentController => _contentController;

  set contentController(value) => _contentController = value;

  var _deletePostProvider = DeletePostProvider();
  get deletePostProvider => _deletePostProvider;

  set deletePostProvider(var value) => _deletePostProvider = value;

  var _likePostProvider = LikePostProvider();
  get likePostProvider => _likePostProvider;

  set likePostProvider(var value) => _likePostProvider = value;

  var _commentOnPostProvider = CommentOnPostProvider();
  get commentOnPostProvider => _commentOnPostProvider;

  set commentOnPostProvider(var value) => _commentOnPostProvider = value;

  var _dislikePostProvider = DislikePostProvider();
  get dislikePostProvider => _dislikePostProvider;

  set dislikePostProvider(var value) => _dislikePostProvider = value;

  Future getAllPosts() async {
    try {
      _isLoading.value = true;
      final data = await _getAllPostsProvider.getAllPosts();
      if (data != null) {
        postsData.value = data;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future refreshPosts() async {
    try {
      final data = await _getAllPostsProvider.getAllPosts();
      if (data != null) {
        postsData.value = data;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    }
  }

  Future sendPost() async {
    try {
      _isLoading.value = true;
      final postData = {
        'title': _titleController.value.text,
        'content': _contentController.value.text,
        'userId': await GetStorage().read(Constants.idKey),
      };
      final data = await _createPostProvider.createPost(postData);
      if (data != null) {
        Get.snackbar(
          'Successfull',
          'Post sent successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
        _contentController.value.clear();
        _titleController.value.clear();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future deletePost(int postId) async {
    try {
      _isLoading.value = true;
      final data = await _deletePostProvider.deletePost(postId);
      if (data != null) {
        Get.snackbar(
          'Successfull',
          'Post deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
        refreshPosts();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future likePost(int postId) async {
    try {
      final data = {
        'userId': await GetStorage().read(Constants.idKey),
        'postId': postId,
      };
      final response = await _likePostProvider.likePost(data);
      if (response != null) {
        refreshPosts();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    }
  }

  Future createComment(int postId) async {
    try {
      final data = {
        'userId': await GetStorage().read(Constants.idKey),
        'postId': postId,
        'content': _commentController.value.text,
      };
      final response = await _commentOnPostProvider.createComment(data);
      if (response != null) {
        Get.snackbar(
          'Successfull',
          'Comment sent successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
        _commentController.value.clear();
        refreshPosts();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    }
  }

  Future disLikePost(int likeId) async {
    try {
      final data = await _dislikePostProvider.dislikePost(likeId);
      if (data != null) {
        refreshPosts();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    }
  }
}
