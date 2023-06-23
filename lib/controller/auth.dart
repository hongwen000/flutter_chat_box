
import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class AuthController extends GetxController {
  RxBool isLoggedIn = false.obs;

  Future<bool> login(String username, String password) async {
    // Your existing login logic
    final response = await http.post(
      Uri.parse('http://proxy.lixinrui000.cn:38591/login'),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if(response.statusCode == 200){
      isLoggedIn.value = true;
    }
    return response.statusCode == 200;
  }

  void logout() {
    isLoggedIn.value = false;
  }
}
