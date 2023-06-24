import 'dart:typed_data';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt/controller/auth.dart';
import 'package:flutter_chatgpt/controller/conversation.dart';
import 'package:flutter_chatgpt/controller/message.dart';
import 'package:flutter_chatgpt/controller/prompt.dart';
import 'package:flutter_chatgpt/controller/settings.dart';
import 'package:flutter_chatgpt/pages/unknown.dart';
import 'package:flutter_chatgpt/configs/translations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_chatgpt/route.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

Future<ByteData> fetchFont() async {
  var url = Uri.parse(
      'https://gstatic.loli.net/s/sourcecodepro/v6/mrl8jkM18OlOQN8JLgasD9Rl0pGnog23EMYRrBmUzJQ.ttf');
  final response = await get(url,
      headers: <String, String>{
        'Content-Type' : 'application/x-www-form-urlencoded; charset=UTF-8'
      },
  );

  if (response.statusCode == 200) {
    return ByteData.view(response.bodyBytes.buffer);
  } else {
    throw Exception('Failed to load font');
  }
}

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb) {
    var fontLoader = FontLoader("wqy");
          fontLoader.addFont(fetchFont());
          await fontLoader.load();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());
    Get.put(ConversationController());
    Get.put(MessageController());
    Get.put(PromptController());
    Get.put(AuthController()); // Add this line
    if (kIsWeb) {
      return GetMaterialApp(
        initialRoute: '/',
        getPages: routes,
        unknownRoute:
            GetPage(name: '/not_found', page: () => const UnknownRoutePage()),
        theme: FlexThemeData.light(scheme: FlexScheme.ebonyClay, fontFamily: "wqy"),
        darkTheme: FlexThemeData.dark(scheme: FlexScheme.ebonyClay, fontFamily: "wqy"),
        themeMode: ThemeMode.system,
        locale: const Locale('zh'),
        translations: MyTranslations(),
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
      );
    } else {
      return GetMaterialApp(
        initialRoute: '/',
        getPages: routes,
        unknownRoute:
            GetPage(name: '/not_found', page: () => const UnknownRoutePage()),
        theme: FlexThemeData.light(scheme: FlexScheme.ebonyClay),
        darkTheme: FlexThemeData.dark(scheme: FlexScheme.ebonyClay),
        themeMode: ThemeMode.system,
        locale: const Locale('zh'),
        translations: MyTranslations(),
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
      );
    }
  }
}
