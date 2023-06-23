import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/controller/settings.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SettingPage extends GetResponsiveView<SettingsController> {
  SettingPage({super.key});

  @override
  Widget? builder() {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
      ),
      body: GetX<SettingsController>(builder: (controller) {
        return ListView(
          children: [
            const Divider(),
            ListTile(
              dense: true,
              title: Text('theme'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            RadioListTile(
              title: const Text('跟随系统'),
              value: ThemeMode.system,
              groupValue: controller.themeMode.value,
              onChanged: (value) {
                controller.setThemeMode(ThemeMode.system);
              },
            ),
            RadioListTile(
              title: const Text('暗黑模式'),
              value: ThemeMode.dark,
              groupValue: controller.themeMode.value,
              onChanged: (value) {
                controller.setThemeMode(ThemeMode.dark);
              },
            ),
            RadioListTile(
              title: const Text('白色模式'),
              value: ThemeMode.light,
              groupValue: controller.themeMode.value,
              onChanged: (value) {
                controller.setThemeMode(ThemeMode.light);
              },
            ),
            const Divider(),
            ListTile(
              dense: true,
              title: Text('language'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            RadioListTile(
              title: const Text('中文'),
              value: 'zh',
              groupValue: controller.locale.value.languageCode,
              onChanged: (value) {
                controller.setLocale(const Locale('zh'));
              },
            ),
            RadioListTile(
              title: const Text('英文'),
              value: 'en',
              groupValue: controller.locale.value.languageCode,
              onChanged: (value) {
                controller.setLocale(const Locale('en'));
              },
            ),
            const Divider(),
            SwitchListTile(
                title: Text(
                  "useStreamApi".tr,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                value: controller.useStream.value,
                onChanged: (value) {
                  controller.setUseStream(value);
                }),
            const Divider(),
            DropdownButtonFormField(
              value: controller.llm.value,
              decoration: InputDecoration(
                labelText: 'llmHint'.tr,
                hintText: 'llmHint'.tr,
                labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(Get.context!).colorScheme.primary),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
              items: <String>['OpenAI', 'ChatGlm', 'IF']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue == null) return;
                controller.setLlm(newValue);
              },
            ),
            const Divider(),
            controller.llm.value == "ChatGlm"
                ? TextFormField(
                    initialValue: controller.glmBaseUrl.value,
                    decoration: InputDecoration(
                      labelText: 'gmlBaseUrl'.tr,
                      hintText: 'gmlBaseUrl'.tr,
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(Get.context!).colorScheme.primary),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    maxLines: 1,
                    onEditingComplete: () {},
                    onFieldSubmitted: (value) {
                      controller.setGlmBaseUrl(value);
                    },
                  )
                : const SizedBox(),
            (controller.llm.value == "OpenAI" && !kIsWeb)
                ? TextFormField(
                    initialValue: controller.openAiKey.value,
                    decoration: InputDecoration(
                      labelText: 'enterKey'.tr,
                      hintText: 'enterKey'.tr,
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(Get.context!).colorScheme.primary),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    maxLines: 1,
                    onFieldSubmitted: (value) {
                      controller.setOpenAiKey(value);
                    },
                    obscureText: controller.isObscure.value,
                  )
                : const SizedBox(),
            controller.llm.value == "OpenAI"
                ? const SizedBox(
                    height: 20,
                  )
                : const SizedBox(),
            controller.llm.value == "OpenAI"
                ? DropdownButtonFormField(
                    value: controller.openAiBaseUrl.value,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'setProxyUrlTips'.tr,
                      hintText: 'setProxyUrlTips'.tr,
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(Get.context!).colorScheme.primary),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                    items: <String>[
                      'https://ai.fakeopen.com/',
                      'https://api.aiproxy.io',
                      'https://api.openai.com',
                      'https://api.openai-proxy.com'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value, // 缩短显示文本
                          overflow: TextOverflow.ellipsis, // 超出长度省略号显示
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue == null) return;
                      controller.setOpenAiBaseUrl(newValue);
                    },
                  )
                : const SizedBox(),
            controller.llm.value == "OpenAI"
                ? const SizedBox(
                    height: 20,
                  )
                : const SizedBox(),
            controller.llm.value == "OpenAI"
                ? DropdownButtonFormField(
                    value: controller.gptModel.value,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'gptModel'.tr,
                      hintText: 'gptModel'.tr,
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(Get.context!).colorScheme.primary),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                    items: <String>[
                      'gpt-3.5-turbo',
                      'gpt-3.5-turbo-0301',
                      'gpt-3.5-turbo-16k',
                      'gpt-3.5-turbo-0613',
                      'gpt-3.5-turbo-16k-0613',
                      'gpt-4',
                      'gpt-4-0613',
                      'gpt-4-32k',
                      'gpt-4-32k-0613'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue == null) return;
                      controller.setGptModel(newValue);
                    })
                : const SizedBox(),
          ],
        );
      }),
    );
  }
}
