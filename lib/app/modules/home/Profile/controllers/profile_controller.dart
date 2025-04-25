import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_socialmedia_app/app/modules/home/Profile/Models/user_data_model.dart';
import 'package:my_socialmedia_app/app/modules/home/Profile/providers/delete_user_provider.dart';
import 'package:my_socialmedia_app/app/modules/home/Profile/providers/get_user_by_id_provider.dart';
import 'package:my_socialmedia_app/app/modules/home/Profile/providers/update_user_data_provider.dart';
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

  Future getUserData() async {
    try {
      _isLoading.value = true;
      var response = await _getUserDataProvider.getUserData();
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

  Future updateUserData() async {
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
        getUserData();
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
}
