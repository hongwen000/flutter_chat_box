import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chatgpt/controller/settings.dart';
import 'package:flutter_chatgpt/repository/conversation.dart';
import 'package:get_storage/get_storage.dart';

abstract class LLM {
  getResponse(List<Message> messages, ValueChanged<Message> onResponse,
      ValueChanged<Message> errorCallback, ValueChanged<Message> onSuccess);
}

class ChatGpt extends LLM {
  @override
  getResponse(
      List<Message> messages,
      ValueChanged<Message> onResponse,
      ValueChanged<Message> errorCallback,
      ValueChanged<Message> onSuccess) async {
    List<OpenAIChatCompletionChoiceMessageModel> openAIMessages = [];
    //将messages反转
    messages = messages.reversed.toList();
    // 将messages里面的每条消息的内容取出来拼接在一起
    String content = "";
    String currentModel = SettingsController.to.gptModel.value;
    int maxTokenLength = 1800;
    switch (currentModel) {
      case "gpt-3.5-turbo":
      case "gpt-3.5-turbo-0125":
      case "gpt-3.5-turbo-1106":
      case "gpt-3.5-turbo-16k":
      case "gpt-3.5-turbo-16k-0613":
        maxTokenLength = 16385 ~/ 2;
        break;
      case "gpt-4-0125-preview":
      case "gpt-4-turbo-preview":
      case "gpt-4-1106-preview":
      case "gpt-4-vision-preview":
      case "gpt-4-1106-vision-preview":
        maxTokenLength = 128000 ~/ 2;
        break;
      case "gpt-4":
      case "gpt-4-0613":
        maxTokenLength = 8192 ~/ 2;
        break;
      case "gpt-4-32k":
      case "gpt-4-32k-0613":
        maxTokenLength = 32768 ~/ 2;
        break;
      case "gpt-3.5-turbo-instruct":
      case "gpt-3.5-turbo-0613":
        maxTokenLength = 4096 ~/ 2;
        break;
      default:
        maxTokenLength = 1800;
        break;
    }
    for (Message message in messages) {
      content = content + message.text;
      if (content.length < maxTokenLength || openAIMessages.isEmpty) {
        // 插入到 openAIMessages 第一个位置
        openAIMessages.insert(
          0,
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
              message.text,
              ),
            ],
            role: message.role.asOpenAIChatMessageRole,
          ),
        );
      }
    }
    var message = Message(
        conversationId: messages.first.conversationId,
        text: "",
        role: Role.assistant); //仅仅第一个返回了角色
    if (SettingsController.to.useStream.value) {
      Stream<OpenAIStreamChatCompletionModel> chatStream = OpenAI.instance.chat
          .createStream(
              model: GetStorage().read("gptModel") ?? "gpt-3.5-turbo",
              messages: openAIMessages);
      chatStream.listen(
        (chatStreamEvent) {
          if (chatStreamEvent.choices.first.delta.content != null) {
            final contentItemModel = chatStreamEvent.choices.first.delta.content!;
            // ContentItemModel should has at least one item
            if (contentItemModel.isNotEmpty) {
              final String contentString = contentItemModel.first!.text!;
              message.text = message.text + contentString;
              onResponse(message);
            }
          }
        },
        onError: (error) {
          try {
            message.text = error.message;
          } catch (_) {
            message.text = error.toString();
          }
          errorCallback(message);
        },
        onDone: () {
          onSuccess(message);
        },
      );
    } else {
      try {
        var response = await OpenAI.instance.chat.create(
          model: GetStorage().read("gptModel") ?? "gpt-3.5-turbo",
          messages: openAIMessages,
        );
        final contentItemModel = response.choices.first.message.content;
        // ContentItemModel should has at least one item
        if (contentItemModel!.isNotEmpty) {
          final String contentString = contentItemModel.first.text!;
          message.text = message.text + contentString;
          onSuccess(message);
        }
      } catch (e) {
        message.text = e.toString();
        errorCallback(message);
      }
    }
  }
}
