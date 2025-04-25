import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_socialmedia_app/app/data/Constants/constants.dart';
import 'package:my_socialmedia_app/app/routes/app_pages.dart';

class SplashController extends GetxController {
  Future checkToken() async {
    final token = await GetStorage().read(Constants.tokenKey);
    if (token != null) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.AUTH);
    }
  }
}
