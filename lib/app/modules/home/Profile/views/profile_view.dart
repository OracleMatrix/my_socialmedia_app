import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_socialmedia_app/app/data/Constants/constants.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final userId = arguments['userId'];
    final accessToken = arguments['accessToken'];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getUserData(userId);
    });
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => controller.getUserData(userId),
        child: Icon(Icons.refresh),
      ),
      appBar: AppBar(title: Text('Profile view'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading) {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: Colors.blue,
              size: 60,
            ),
          );
        }
        controller.isFollowing.value =
            controller.userData.value.following!
                .map((e) => e.followerId)
                .where(
                  (element) => element == GetStorage().read(Constants.idKey),
                )
                .isNotEmpty;
        final currentUserId = GetStorage().read(Constants.idKey);
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                child: CachedNetworkImage(
                  imageUrl:
                      '${Constants.baseUrl}/api/users/download/profilePicture/${userId}',
                  httpHeaders: {'auth': accessToken},
                  progressIndicatorBuilder:
                      (context, url, progress) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.person, color: Colors.grey),
                      ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                controller.userData.value.name ?? 'No Name',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                controller.userData.value.email ?? 'No Email',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCountColumn(
                    'Posts',
                    controller.userData.value.posts?.length ?? 0,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showFollowersDetails(context, accessToken);
                    },
                    child: _buildCountColumn(
                      'Followers',
                      controller.userData.value.follower?.length ?? 0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showFollowingDetails(context, accessToken);
                    },
                    child: _buildCountColumn(
                      'Following',
                      controller.userData.value.following?.length ?? 0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (userId == currentUserId)
                UpdateProfileSheet(controller: controller, userId: userId),
              if (userId != currentUserId)
                Obx(
                  () => MaterialButton(
                    onPressed: () async {
                      if (controller.isFollowing.value) {
                        final result = await controller.unFollowUser(
                          currentUserId,
                          userId,
                        );
                        if (result) {
                          controller.isFollowing.value = false;
                        }
                      } else {
                        final result = await controller.followUser(
                          currentUserId,
                          userId,
                        );
                        if (result) {
                          controller.isFollowing.value = true;
                        }
                      }
                    },
                    color:
                        controller.isFollowing.value ? Colors.red : Colors.blue,
                    child: Text(
                      controller.isFollowing.value ? 'Unfollow' : 'Follow',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

              Divider(),
              _buildPostsGrid(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCountColumn(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildPostsGrid() {
    return Obx(() {
      var posts = controller.userData.value.posts ?? [];
      if (posts.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('No posts yet', style: TextStyle(color: Colors.grey)),
        );
      }
      return ResponsiveBuilder(
        builder:
            (context, sizingInformation) => GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: sizingInformation.isDesktop ? 4 : 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                var post = posts[index];
                return GestureDetector(
                  onTap: () {
                    _showPostDetail(context, post);
                  },
                  child: Container(
                    color: Colors.grey[400],
                    child: Center(
                      child: Text(
                        post.title ?? 'No Title',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: sizingInformation.isDesktop ? 18 : 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      );
    });
  }

  void _showPostDetail(BuildContext context, post) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Post Details'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Title: ${post.title ?? 'No Title'}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Content: ${post.content ?? 'No Content'}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Divider(),
                //show likes and comments
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Likes: ${post.likes?.length ?? 0}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Comments: ${post.comments?.length ?? 0}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showFollowersDetails(BuildContext context, String accessToken) {
    var followers = controller.userData.value.follower ?? [];
    if (followers.isEmpty) {
      Get.snackbar(
        'Info',
        'No followers to show',
        colorText: Colors.white,
        icon: Icon(Icons.info, color: Colors.white),
      );
      return;
    }
    Get.bottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      Container(
        height: Get.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: followers.length,
          itemBuilder: (context, index) {
            var follower = followers[index];
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 60,
                    child: CachedNetworkImage(
                      imageUrl:
                          '${Constants.baseUrl}/api/users/download/profilePicture/${follower.id}',
                      httpHeaders: {'auth': accessToken},
                      progressIndicatorBuilder:
                          (context, url, progress) => Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.person, color: Colors.grey),
                          ),
                    ),
                  ),
                  title: Text(follower.following?.name ?? 'No Name'),
                  subtitle: Text(follower.following?.email ?? 'No Email'),
                ),
                Divider(color: Colors.white),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showFollowingDetails(BuildContext context, String accessToken) {
    var following = controller.userData.value.following ?? [];
    if (following.isEmpty) {
      Get.snackbar(
        'Info',
        'No following to show',
        colorText: Colors.white,
        icon: Icon(Icons.info, color: Colors.white),
      );
      return;
    }
    Get.bottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      Container(
        height: Get.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: following.length,
          itemBuilder: (context, index) {
            var followings = following[index];
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 60,
                    child: CachedNetworkImage(
                      imageUrl:
                          '${Constants.baseUrl}/api/users/download/profilePicture/${followings.id}',
                      httpHeaders: {'auth': accessToken},
                      progressIndicatorBuilder:
                          (context, url, progress) => Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.person, color: Colors.grey),
                          ),
                    ),
                  ),
                  title: Text(followings.follower?.name ?? 'No Name'),
                  subtitle: Text(followings.follower?.email ?? 'No Email'),
                ),
                Divider(color: Colors.white),
              ],
            );
          },
        ),
      ),
    );
  }
}

class UpdateProfileSheet extends StatelessWidget {
  const UpdateProfileSheet({
    super.key,
    required this.controller,
    required this.userId,
  });

  final ProfileController controller;
  final int userId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              controller.nameController.value.text =
                  controller.userData.value.name ?? '';
              controller.emailController.value.text =
                  controller.userData.value.email ?? '';
              controller.passwordController.value.text = '';
              controller.confirmPasswordController.value.text = '';
              controller.isPasswordVisible.value = false;

              Get.bottomSheet(
                backgroundColor: Colors.grey.shade800,
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Update User Data',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: controller.nameController.value,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: controller.emailController.value,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 15),
                        Obx(
                          () => TextField(
                            controller: controller.passwordController.value,
                            obscureText: !controller.isPasswordVisible.value,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  controller.isPasswordVisible.value =
                                      !controller.isPasswordVisible.value;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Obx(
                          () => TextField(
                            controller:
                                controller.confirmPasswordController.value,
                            obscureText: !controller.isPasswordVisible.value,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () async {
                            if (controller.passwordController.value.text !=
                                controller
                                    .confirmPasswordController
                                    .value
                                    .text) {
                              Get.snackbar(
                                'Error',
                                'Passwords do not match',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                icon: Icon(Icons.error, color: Colors.white),
                              );
                              return;
                            } else if (controller
                                    .nameController
                                    .value
                                    .text
                                    .isEmpty ||
                                controller.emailController.value.text.isEmpty) {
                              Get.snackbar(
                                'Error',
                                'Name and Email cannot be empty',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                icon: Icon(Icons.error, color: Colors.white),
                              );
                            } else if (controller
                                    .passwordController
                                    .value
                                    .text
                                    .length <
                                6) {
                              Get.snackbar(
                                'Error',
                                'Password must be at least 6 characters long',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                icon: Icon(Icons.error, color: Colors.white),
                              );
                            }
                            Get.back();
                            await controller.updateUserData(userId);
                          },
                          child: Text('Update'),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                isScrollControlled: true,
              );
            },
            label: Text('Edit', style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.edit, color: Colors.white),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Get.defaultDialog(
                title: 'Confirm Delete',
                middleText:
                    'Are you sure you want to delete your account? This action cannot be undone.',
                textConfirm: 'Delete',
                textCancel: 'Cancel',
                confirmTextColor: Colors.white,
                onConfirm: () async {
                  Get.back();
                  await controller.deleteUser();
                },
                onCancel: () {},
              );
            },
            label: Text(
              'Delete account',
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
