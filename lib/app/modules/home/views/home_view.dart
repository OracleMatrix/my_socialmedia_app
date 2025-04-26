import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_socialmedia_app/app/data/Constants/constants.dart';
import 'package:my_socialmedia_app/app/modules/home/Models/get_all_posts_model.dart';
import 'package:my_socialmedia_app/app/routes/app_pages.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:searchfield/searchfield.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/home_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getAllPosts(); // Fetch posts on build

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(
                Routes.PROFILE,
                arguments: {'userId': GetStorage().read(Constants.idKey)},
              );
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () async {
              try {
                await GetStorage().remove(Constants.tokenKey);
                await GetStorage().remove(Constants.idKey);
                Get.offAllNamed(Routes.AUTH);
              } catch (e) {
                Get.snackbar(
                  'Error on logout',
                  e.toString(),
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  icon: Icon(Icons.error, color: Colors.white),
                );
              }
            },
            icon: Icon(Icons.logout_rounded),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(Get.width, Get.height * 0.08),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchField(
              searchInputDecoration: SearchInputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
              suggestionsDecoration: SuggestionDecoration(
                border: Border.all(color: Colors.grey.shade800),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade700,
              ),
              onSearchTextChanged: (value) {
                if (value.length >= 3) {
                  controller.getUserByEmail(value);
                }
                return controller.userDataByEmail
                    .map(
                      (element) =>
                          SearchFieldListItem(element.email!, item: element),
                    )
                    .toList();
              },
              suggestions:
                  controller.userDataByEmail
                      .map((e) => SearchFieldListItem(e.email!, item: e))
                      .toList(),
              onSuggestionTap: (value) {
                final user = value.item;
                if (user != null && user.id != null) {
                  Get.toNamed(Routes.PROFILE, arguments: {'userId': user.id});
                }
              },
              hint: 'Search users...',
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.getAllPosts(),
        child: Obx(() {
          if (controller.isLoading) {
            return Center(
              child: LoadingAnimationWidget.twoRotatingArc(
                color: Colors.blue,
                size: 80,
              ),
            );
          }

          final posts = controller.postsData.value.posts ?? [];

          if (posts.isEmpty) {
            return const Center(
              child: Text('No posts available', style: TextStyle(fontSize: 18)),
            );
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final user = post.user;
              final likesCount = post.likes?.length ?? 0;
              final commentsCount = post.comments?.length ?? 0;
              final liked = (post.likes ?? []).any(
                (element) =>
                    element.user?.id == GetStorage().read(Constants.idKey),
              );
              final isPostOwner =
                  post.user?.id == GetStorage().read(Constants.idKey);
              return Card(
                color:
                    isPostOwner
                        ? Colors.lightBlue.shade800
                        : Colors.grey.shade900,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User info row
                      userInfoSection(user, post),
                      const SizedBox(height: 12),
                      // Post title
                      if (post.title != null && post.title!.isNotEmpty)
                        Text(
                          post.title!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      if (post.title != null && post.title!.isNotEmpty)
                        const SizedBox(height: 8),
                      // Post content
                      if (post.content != null && post.content!.isNotEmpty)
                        Text(
                          post.content!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      const SizedBox(height: 12),
                      // Likes and comments row
                      LikesAndCommentsSection(
                        liked: liked,
                        controller: controller,
                        post: post,
                        likesCount: likesCount,
                        commentsCount: commentsCount,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              heroTag: 'addPost',
              backgroundColor: Colors.blue,
              onPressed: () {},
              child: AddPostSection(controller: controller),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              heroTag: 'refreshPosts',
              backgroundColor: Colors.blue,
              onPressed: () {
                controller.getAllPosts();
              },
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }

  Row userInfoSection(User? user, Post post) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(Routes.PROFILE, arguments: {'userId': user?.id});
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            child: RandomAvatar('saytoonz'),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            Get.toNamed(Routes.PROFILE, arguments: {'userId': user?.id});
          },
          child: Text(
            user?.name != null
                ? user!.name.toString().split('.').last
                : 'Unknown',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const Spacer(),
        Text(
          post.createdAt != null
              ? timeago.format(post.createdAt ?? DateTime.now())
              : '',
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        PullDownButton(
          itemBuilder: (context) {
            return [
              PullDownMenuItem(
                onTap: () async {
                  final params = ShareParams(
                    text: post.content,
                    title: post.title,
                    subject: post.user!.name,
                  );

                  final result = await SharePlus.instance.share(params);

                  if (result.status == ShareResultStatus.success) {
                    Get.snackbar(
                      'Shared',
                      'Post shared successfully',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      icon: Icon(Icons.check, color: Colors.white),
                    );
                  }
                },
                title: 'Share',
                icon: CupertinoIcons.share,
              ),
              if (post.user!.id == GetStorage().read(Constants.idKey))
                PullDownMenuItem(
                  onTap: () {
                    Get.defaultDialog(
                      title: 'Delete Post',
                      middleText: 'Are you sure you want to delete this post?',
                      onCancel: () => Get.back(),
                      onConfirm: () async {
                        Get.back();
                        await controller.deletePost(post.id ?? 0);
                      },
                    );
                  },
                  title: 'Delete',
                  icon: CupertinoIcons.delete,
                  isDestructive: true,
                ),
            ];
          },
          buttonBuilder: (context, showMenu) {
            return IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: showMenu,
            );
          },
        ),
      ],
    );
  }
}

class LikesAndCommentsSection extends StatelessWidget {
  const LikesAndCommentsSection({
    super.key,
    required this.liked,
    required this.controller,
    required this.post,
    required this.likesCount,
    required this.commentsCount,
  });

  final bool liked;
  final HomeController controller;
  final Post post;
  final int likesCount;
  final int commentsCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (liked) {
              controller.disLikePost(
                post.likes
                        ?.firstWhere(
                          (element) =>
                              element.user?.id ==
                              GetStorage().read(Constants.idKey),
                        )
                        .id ??
                    0,
              );
            } else {
              controller.likePost(post.id ?? 0);
            }
          },
          child: Icon(
            Icons.favorite,
            color: liked ? Colors.red[400] : Colors.grey,
            size: 20,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$likesCount',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 16),
        CommentsSection(
          post: post,
          controller: controller,
          commentsCount: commentsCount,
        ),
      ],
    );
  }
}

class CommentsSection extends StatelessWidget {
  const CommentsSection({
    super.key,
    required this.post,
    required this.controller,
    required this.commentsCount,
  });

  final Post post;
  final HomeController controller;
  final int commentsCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          backgroundColor: Colors.grey.shade900,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Comments',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                if ((post.comments ?? []).isEmpty)
                  SizedBox(
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(Icons.comments_disabled, size: 80),
                          const Text('No comments yet'),
                        ],
                      ),
                    ),
                  ),
                if ((post.comments ?? []).isNotEmpty)
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: post.comments!.length,
                      itemBuilder: (context, index) {
                        final comment = post.comments![index];
                        final commenterName = comment.user?.name ?? 'Unknown';
                        final commentContent = comment.content ?? '';
                        return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                child: Text(
                                  commenterName.isNotEmpty
                                      ? commenterName.split('.').last[0]
                                      : '?',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              title: Text(
                                commenterName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(commentContent),
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.commentController.value,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        if (controller.commentController.value.text
                            .trim()
                            .isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Comment cannot be empty',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            icon: Icon(Icons.error, color: Colors.white),
                          );
                          return;
                        }
                        Get.back();
                        await controller.createComment(post.id ?? 0);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Send',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          isScrollControlled: true,
        );
      },
      child: Row(
        children: [
          Icon(Icons.comment, color: Colors.grey[500], size: 20),
          const SizedBox(width: 4),
          Text(
            '$commentsCount',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class AddPostSection extends StatelessWidget {
  const AddPostSection({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.post_add),
      onPressed: () {
        Get.bottomSheet(
          backgroundColor: Colors.grey.shade800,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.post_add, color: Colors.blue, size: 80),
                ),
                TextField(
                  controller: controller.titleController.value,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.contentController.value,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (controller.titleController.value.text.isEmpty ||
                        controller.contentController.value.text.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please fill in all fields',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        icon: Icon(Icons.error, color: Colors.white),
                      );
                      return;
                    }
                    Get.back();
                    await controller.sendPost();
                    await controller.getAllPosts();
                  },
                  label: const Text(
                    'Post',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
          isScrollControlled: true,
        );
      },
    );
  }
}
