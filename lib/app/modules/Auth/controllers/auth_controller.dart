import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_socialmedia_app/app/data/Constants/constants.dart';
import 'package:my_socialmedia_app/app/modules/Auth/providers/login_provider.dart';
import 'package:my_socialmedia_app/app/modules/Auth/providers/register_provider.dart';
import 'package:my_socialmedia_app/app/routes/app_pages.dart';

class AuthController extends GetxController {
  var _isLoading = false.obs;
  get isLoading => _isLoading;

  set isLoading(var value) => _isLoading = value;

  var _registerProvider = RegisterProvider();
  get registerProvider => _registerProvider;

  set registerProvider(var value) => _registerProvider = value;

  var _loginProvider = LoginProvider();
  get loginProvider => _loginProvider;

  set loginProvider(var value) => _loginProvider = value;

  Future<String?> registerUser(
    String email,
    String password,
    String name,
  ) async {
    try {
      _isLoading.value = true;
      final userInfo = {'email': email, 'password': password, 'name': name};
      final data = await _registerProvider.registerUser(userInfo);
      if (data != null) {
        await GetStorage().write(Constants.idKey, data['user']['id']);
        await GetStorage().write(Constants.tokenKey, data['token']);
        Get.offAllNamed(Routes.HOME);
        return null;
      } else {
        return 'Registration failed';
      }
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<String?> loginUser(String email, String password) async {
    try {
      _isLoading.value = true;
      final userInfo = {'email': email, 'password': password};
      final data = await _loginProvider.loginUser(userInfo);
      if (data != null) {
        await GetStorage().write(Constants.idKey, data['user']['id']);
        await GetStorage().write(Constants.tokenKey, data['token']);
        Get.offAllNamed(Routes.HOME);
        return null;
      } else {
        return 'Login failed';
      }
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading.value = false;
    }
  }
}
