import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        additionalSignupFields: [
          UserFormField(
            keyName: 'name',
            displayName: 'name',
            icon: Icon(Icons.person),
            userType: LoginUserType.name,
          ),
        ],
        onSignup: (value) async {
          final result = await controller.registerUser(
            value.name!,
            value.password!,
            value.additionalSignupData!['name'] ?? '',
          );
          return result;
        },
        onLogin: (value) async {
          final result = await controller.loginUser(value.name, value.password);
          return result;
        },
        onRecoverPassword: (value) {
          return null;
        },
        messages: LoginMessages(signUpSuccess: 'Welcome'),
      ),
    );
  }
}
