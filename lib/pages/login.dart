import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chatgpt/controller/auth.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  Future<bool> _login(String username, String password) async {
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
    return response.statusCode == 200;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(hintText: '用户名'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: '密码'),
            ),
            ElevatedButton(
              onPressed: () async {
                var username = _usernameController.text;
                var password = _passwordController.text;

                if (await _login(username, password)) {

                  Get.find<AuthController>().isLoggedIn.value = true;
                  Get.offAllNamed('/');  // this will take you to the home page
                } else {
                  EasyLoading.showError('登录失败，请检查用户名或密码');
                }
              },
              child: const Text('登录'),
            ),
          ],
        ),
      ),
    );
  }
}
