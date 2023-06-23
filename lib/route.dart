import 'package:flutter_chatgpt/controller/auth.dart';
import 'package:flutter_chatgpt/pages/home.dart';
import 'package:flutter_chatgpt/pages/second.dart';
import 'package:flutter_chatgpt/pages/setting.dart';
import 'package:flutter_chatgpt/pages/login.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';


class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final isLoggedIn = Get.find<AuthController>().isLoggedIn.value;
    return isLoggedIn ? null : const RouteSettings(name: '/login');
  }
}

final routes = [
  GetPage(name: '/login', page: () => LoginPage()),
  GetPage(
    name: '/',
    page: () => MyHomePage(),
    middlewares: [
      AuthMiddleware(),
    ],
  ),
  GetPage(
    name: '/second',
    page: () => const SecondPage(),
    middlewares: [
      AuthMiddleware(),
    ],
  ),
  GetPage(
    name: '/setting',
    page: () => SettingPage(),
    middlewares: [
      AuthMiddleware(),
    ],
  ),
];
