import 'dart:convert';
import 'package:flutter_chatgpt/controller/prompt.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;


const RAW_FILE_URL = "https://raw.githubusercontent.com/";
const MIRRORF_FILE_URL = "https://gh-proxy.com/https://raw.githubusercontent.com";

Future<List<Prompt>> getPrompts() async {
  final List<Prompt> prompts = [];
  if(kIsWeb) {
      final data = await rootBundle.loadString("assets/static/prompts-zh.json");
      final jsonResult = jsonDecode(data.toString());
      for (var item in jsonResult) {
        prompts.add(Prompt(item['act'], item['prompt']));
      }
  } else {
    final response = await http.get(
      Uri.parse(
          '$MIRRORF_FILE_URL/hongwen000/awesome-chatgpt-prompts-zh/main/prompts-zh.json'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      for (var item in jsonResponse) {
        prompts.add(Prompt(item['act'], item['prompt']));
      }
    } else {
      throw Exception('Failed to load prompts');
    }
  }
  return prompts;
}
