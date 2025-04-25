import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 2), () => controller.checkToken());
    });
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: Center(
        child: LoadingAnimationWidget.dotsTriangle(
          color: Colors.blue,
          size: Get.height * 0.12,
        ),
      ),
    );
  }
}
