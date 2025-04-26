import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_socialmedia_app/app/data/Constants/constants.dart';
import 'package:my_socialmedia_app/app/modules/home/Models/get_user_by_email_model.dart';

class GetUserByEmailProvider extends GetConnect {
  Future<List<GetUserByEmailModel>?> getUserByEmail(String email) async {
    try {
      final response = await get(
        '${Constants.baseUrl}/api/users/search/',
        query: {'email': email},
        headers: {'auth': GetStorage().read(Constants.tokenKey)},
      );
      if (response.body != null) {
        if (response.status.isOk) {
          return getUserByEmailModelFromJson(response.bodyString!);
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
