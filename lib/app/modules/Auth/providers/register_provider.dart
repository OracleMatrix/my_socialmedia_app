import 'package:get/get.dart';
import 'package:my_socialmedia_app/app/data/Constants/constants.dart';

class RegisterProvider extends GetConnect {
  Future registerUser(Map<String, dynamic> data) async {
    try {
      final response = await post(
        '${Constants.baseUrl}/api/auth/register',
        data,
      );
      if (response.body != null) {
        if (response.status.isOk) {
          return response.body;
        } else if (response.status.isServerError) {
          throw 'Server is not reachable\nPlease try again later';
        } else if (response.status.isNotFound) {
          throw 'Not Found!';
        } else if (response.status.isForbidden) {
          throw 'Bad request\nCheck data and try again...';
        } else {
          throw response.body['message'] ?? response.bodyString;
        }
      } else {
        throw 'Something went wrong!\nPlease try again later';
      }
    } catch (e) {
      rethrow;
    }
  }
}
