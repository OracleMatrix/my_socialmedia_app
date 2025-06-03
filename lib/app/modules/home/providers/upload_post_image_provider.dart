import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_socialmedia_app/app/data/Constants/constants.dart';

class UploadPostImageProvider extends GetConnect {
  Future uploadImage(int postId, File image) async {
    try {
      final form = FormData({
        'postPicture': MultipartFile(
          image,
          filename: image.path.split('/').last,
          contentType: 'image/jpeg', // or 'image/png' based on the file
        ),
      });
      final response = await post(
        '${Constants.baseUrl}/api/posts/$postId/picture',
        form,
        headers: {'auth': GetStorage().read(Constants.tokenKey)},
      );
      if (response.body != null) {
        if (response.status.isOk) {
          return response.body;
        } else if (response.status.isServerError) {
          throw response.body['message'];
        } else if (response.status.isNotFound) {
          throw response.body['message'];
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
