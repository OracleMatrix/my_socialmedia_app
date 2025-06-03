import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_socialmedia_app/app/modules/home/Profile/Models/user_data_model.dart';
import 'package:my_socialmedia_app/app/modules/home/Profile/providers/add_profile_photo_provider.dart';
import 'package:my_socialmedia_app/app/modules/home/Profile/providers/delete_user_provider.dart';
import 'package:my_socialmedia_app/app/modules/home/Profile/providers/follow_user_provider.dart';
import 'package:my_socialmedia_app/app/modules/home/Profile/providers/get_user_by_id_provider.dart';
import 'package:my_socialmedia_app/app/modules/home/Profile/providers/un_follow_user_provider.dart';
import 'package:my_socialmedia_app/app/modules/home/Profile/providers/update_user_data_provider.dart';
import 'package:my_socialmedia_app/app/modules/home/providers/delete_post_provider.dart';
import 'package:my_socialmedia_app/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  var nameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var confirmPasswordController = TextEditingController().obs;
  var isPasswordVisible = false.obs;

  var _isLoading = true.obs;

  get isLoading => _isLoading.value;

  set isLoading(var value) => _isLoading = value;

  var _getUserDataProvider = GetUserByIdProvider();

  get getUserDataProvider => _getUserDataProvider;

  set getUserDataProvider(var value) => _getUserDataProvider = value;

  var userData = UserDataModel().obs;

  var _updateUserProvider = UpdateUserDataProvider();

  get updateUserProvider => _updateUserProvider;

  var _deleteUserProvider = DeleteUserProvider();

  get deleteUserProvider => _deleteUserProvider;

  set deleteUserProvider(var value) => _deleteUserProvider = value;

  set updateUserProvider(var value) => _updateUserProvider = value;

  var _followUserProvider = FollowUserProvider();

  get followUserProvider => _followUserProvider;

  set followUserProvider(var value) => _followUserProvider = value;

  var _unFollowUserProvider = UnFollowUserProvider();

  get unFollowUserProvider => _unFollowUserProvider;

  set unFollowUserProvider(var value) => _unFollowUserProvider = value;

  var _deletePostProvider = DeletePostProvider();

  get deletePostProvider => _deletePostProvider;

  set deletePostProvider(var value) => _deletePostProvider = value;

  final AddProfilePhotoProvider _addProfilePhotoProvider =
      AddProfilePhotoProvider();

  var selectedImage = Rxn<File>();

  var isFollowing = false.obs;

  Future getUserData(int userId) async {
    try {
      _isLoading.value = true;
      var response = await _getUserDataProvider.getUserData(userId);
      if (response != null) {
        userData.value = response;
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

  Future updateUserData(int userId) async {
    try {
      _isLoading.value = true;
      final data = {
        'name': nameController.value.text,
        'email': emailController.value.text,
        'password': passwordController.value.text,
      };
      var response = await _updateUserProvider.updateUser(data);
      if (response != null) {
        Get.snackbar(
          'Success',
          'User data updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check, color: Colors.white),
        );
        getUserData(userId);
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
        await getUserData(userData.value.id!);
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

  Future deleteUser() async {
    try {
      _isLoading.value = true;
      var response = await _deleteUserProvider.deleteUser();
      if (response != null) {
        Get.snackbar(
          'Success',
          'User deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check, color: Colors.white),
        );
        Get.offAllNamed(Routes.AUTH);
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

  Future<bool> followUser(int followerId, int followingId) async {
    try {
      _isLoading.value = true;
      final data = {'followerId': followerId, 'followingId': followingId};
      var response = await _followUserProvider.followUser(data);
      if (response != null) {
        Get.snackbar(
          'Success',
          'User followed successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check, color: Colors.white),
        );
        isFollowing.value = true;
        return true;
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
    return false;
  }

  Future<bool> unFollowUser(int followerId, int followingId) async {
    try {
      _isLoading.value = true;
      var response = await _unFollowUserProvider.unFollowUser(
        followerId,
        followingId,
      );
      if (response != null) {
        Get.snackbar(
          'Success',
          'User unfollowed successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check, color: Colors.white),
        );
        isFollowing.value = false;
        return true;
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
    return false;
  }

  Future addProfilePhoto(File image) async {
    try {
      _isLoading.value = true;
      final response = await _addProfilePhotoProvider.addProfilePhoto(image);
      if (response != null) {
        getUserData(userData.value.id!);
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
}
