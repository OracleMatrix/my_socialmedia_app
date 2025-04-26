import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_socialmedia_app/app/data/Constants/constants.dart';
import 'package:my_socialmedia_app/app/modules/home/Models/get_all_posts_model.dart';

class GetAllPostsProvider extends GetConnect {
  Future<GetAllPostsModel?> getAllPosts() async {
    try {
      final response = await get(
        '${Constants.baseUrl}/api/posts/${GetStorage().read(Constants.idKey)}',
        headers: {'auth': await GetStorage().read(Constants.tokenKey)},
      );
      if (response.body != null) {
        if (response.status.isOk) {
          return getAllPostsModelFromJson(response.bodyString!);
        } else if (response.status.isServerError) {
          throw 'Server is not reachable\nPlease try again later';
        } else if (response.status.isNotFound) {
          throw 'Not Found!';
        } else if (response.status.isForbidden) {
          throw 'Bad request\nCheck data and try again...';
        } else {
          throw response.body['message'] ??
              response.bodyString ??
              'Unknown error';
        }
      } else {
        throw 'Something went wrong!\nPlease try again later';
      }
    } catch (e) {
      rethrow;
    }
  }
}
