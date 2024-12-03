import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Chat Screen Widget
class ccController extends GetxController {
  int selectedIndex = 2;
  int selectedIndexB = 2;

  void changebottem(int index) {
    selectedIndexB = index;
    update();

    // التنقل حسب الاختيار
    switch (selectedIndexB) {
      case 0:
        Get.offNamed("/HomePage");
        break;
      case 1:
        Get.offNamed("/TrainPscreen");
        break;
      case 2:
        Get.offNamed("/ChatScren");
        break;
      case 3:
        Get.offNamed("/TrainPscreen");
        break;
      case 4:
        Get.offNamed("/TrainPscreen");
        break;
    }
  }
}

class ChatbotScreen extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());
  final ccController chatControllr = Get.put(ccController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('رقمن', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          leading: Icon(Icons.arrow_back, color: Colors.black),
        ),
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: [
              // Message Display Area
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    reverse: true,
                    itemCount: chatController.messages.length,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final message =
                          chatController.messages.reversed.toList()[index];
                      final isUser = message['sender'] == 'user';
                      final character = message['character'] ?? 'default';

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: isUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            if (!isUser)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundImage: AssetImage(
                                    chatController.getCharacterImage(character),
                                  ),
                                ),
                              ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? Color(0xFF273470)
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                    bottomLeft:
                                        Radius.circular(isUser ? 12 : 0),
                                    bottomRight:
                                        Radius.circular(isUser ? 0 : 12),
                                  ),
                                ),
                                child: Text(
                                  message['text'] ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isUser ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            if (isUser)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundImage:
                                      AssetImage('assets/images/pro.webp'),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),

              // Suggestion Chips
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        ChipButton(text: "اهلا"),
                        ChipButton(text: "ما معنى رقمن "),
                        ChipButton(text: "IFRS1 ما هو معيار "),
                        ChipButton(text: "IFRS2 ما هو معيار "),
                        ChipButton(text: "IFRS3 ما هو معيار "),
                      ])),
                ),
              ),

              // Message Input Field
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: chatController.textController,
                        decoration: InputDecoration(
                          hintText: 'اكتب رسالتك',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.blueAccent),
                      onPressed: () {
                        final message =
                            chatController.textController.text.trim();
                        if (message.isNotEmpty) {
                          chatController.sendMessage(message);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: GetBuilder<ccController>(
          builder: (_) => BottomNavigationBar(
            backgroundColor: Color(0xFF0F2027),
            currentIndex: chatControllr.selectedIndexB,
            onTap: (index) => chatControllr.changebottem(index),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: "الرئيسية"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.monitor_heart_sharp), label: "تحاليلي"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat, size: 40), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.group), label: "فرصي"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "حسابي"),
            ],
            selectedItemColor: Color.fromARGB(255, 255, 255, 255),
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}

// ChatController for handling chat logic and API interaction

class ChatController extends GetxController {
  var messages = <Map<String, String>>[].obs;
  TextEditingController textController = TextEditingController();

  // System Prompt for defining character and conversation rules
  final String systemPrompt = """
<<SYS>>
  <</SYS>>
  """;

  final String url =
      "https://eu-de.ml.cloud.ibm.com/ml/v1/text/generation?version=2023-05-29";
  final String apiToken =
      "eyJraWQiOiIyMDI0MTEwMTA4NDIiLCJhbGciOiJSUzI1NiJ9.eyJpYW1faWQiOiJJQk1pZC02OTMwMDBGQ0NOIiwiaWQiOiJJQk1pZC02OTMwMDBGQ0NOIiwicmVhbG1pZCI6IklCTWlkIiwianRpIjoiODc1Mzg4NTYtNjVlMS00YTExLTlhZjgtYjIyNDFlYjQ0NWM3IiwiaWRlbnRpZmllciI6IjY5MzAwMEZDQ04iLCJnaXZlbl9uYW1lIjoiU2FsZW0iLCJmYW1pbHlfbmFtZSI6IkFsLUhhbWVkIiwibmFtZSI6IlNhbGVtIEFsLUhhbWVkIiwiZW1haWwiOiJzYWxlbTEyMzQ1NjM2MEBnbWFpbC5jb20iLCJzdWIiOiJzYWxlbTEyMzQ1NjM2MEBnbWFpbC5jb20iLCJhdXRobiI6eyJzdWIiOiJzYWxlbTEyMzQ1NjM2MEBnbWFpbC5jb20iLCJpYW1faWQiOiJJQk1pZC02OTMwMDBGQ0NOIiwibmFtZSI6IlNhbGVtIEFsLUhhbWVkIiwiZ2l2ZW5fbmFtZSI6IlNhbGVtIiwiZmFtaWx5X25hbWUiOiJBbC1IYW1lZCIsImVtYWlsIjoic2FsZW0xMjM0NTYzNjBAZ21haWwuY29tIn0sImFjY291bnQiOnsidmFsaWQiOnRydWUsImJzcyI6ImZkMWU3M2IxNjkxYjQ4MTg5NjNkZDRkYjlkZDNmNTFlIiwiaW1zX3VzZXJfaWQiOiIxMjY3NzUxMyIsImZyb3plbiI6dHJ1ZSwiaW1zIjoiMjc0NzkyNiJ9LCJpYXQiOjE3MzEyNDc2OTAsImV4cCI6MTczMTI1MTI5MCwiaXNzIjoiaHR0cHM6Ly9pYW0uY2xvdWQuaWJtLmNvbS9pZGVudGl0eSIsImdyYW50X3R5cGUiOiJ1cm46aWJtOnBhcmFtczpvYXV0aDpncmFudC10eXBlOmFwaWtleSIsInNjb3BlIjoiaWJtIG9wZW5pZCIsImNsaWVudF9pZCI6ImRlZmF1bHQiLCJhY3IiOjEsImFtciI6WyJwd2QiXX0.IRw-4xp8KrdO_tTypYJzLgrThe-zsImoC-s8EkPMmmZpzQa-1QN2-qEMZero5P-5Nb8B7iGlwgRuCxi11cXaVZ2C-Lahk8Ns1isQ-uN4W_bJUfqN1Sb_5uYMf0dzGnkWeG7YZfMvuZE7yougEPKBQPZUtHbZ3QEak9rzDY7dKXarJL-DSAZQ-DPyCr4wiNe93EfHzqwGKzJpvXN5tHrYPCq8wLCJ3IQ3bXI5n7pIZW1dNckocB9Ugj178yd0JRADJXQOQET8q5oFEl1RpCrBSFoqYsk4rEz2sSckNLQJOXG65iP8nb23GISh0lO5p5SdGw4gKDC0s13S_NNnhV0_lQ";
  Future<void> sendMessage(String message) async {
    String character = detectCharacter(message);
    messages.add({'sender': 'user', 'text': message, 'character': character});

    var body = {
      "input": "<s> [INST] $systemPrompt $message [/INST]",
      "parameters": {
        "decoding_method": "greedy",
        "max_new_tokens": 900,
        "repetition_penalty": 1.0,
      },
      "model_id": "sdaia/allam-1-13b-instruct",
      "project_id": "f3efb0ac-27ab-413a-827a-de0712ca03e1",
    };

    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiToken",
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data != null &&
            data is Map &&
            data.containsKey('results') &&
            data['results'] is List &&
            data['results'].isNotEmpty &&
            data['results'][0].containsKey('generated_text')) {
          String reply = data['results'][0]['generated_text'];
          messages
              .add({'sender': 'bot', 'text': reply, 'character': character});
        } else {
          messages.add(
              {'sender': 'bot', 'text': "No valid response text from server"});
        }
      } else {
        messages.add({
          'sender': 'bot',
          'text':
              "Error: ${response.reasonPhrase} (Status Code: ${response.statusCode})"
        });
      }
    } catch (error) {
      messages.add({'sender': 'bot', 'text': "Failed to connect to server"});
    }

    textController.clear();
  }

  // Method to detect character based on message content
  String detectCharacter(String message) {
    if (message.contains("ابن سينا")) return "ابن سينا";
    if (message.contains("الخوارزمي")) return "الخوارزمي";
    if (message.contains("جابر بن حيان")) return "جابر بن حيان";
    if (message.contains("المتنبي")) return "المتنبي";
    if (message.contains("ابن الهيثم")) return "ابن الهيثم";
    if (message.contains("احمد شوقي")) return "احمد شوقي";
    return "default";
  }

  // Method to get character image
  String getCharacterImage(String character) {
    switch (character) {
      case "ابن سينا":
        return 'assets/images/car2.webp';
      case "الخوارزمي":
        return 'assets/images/car2.webp';
      case "جابر بن حيان":
        return 'assets/images/car2.webp';
      case "المتنبي":
        return 'assets/images/car2.webp';
      case "ابن الهيثم":
        return 'assets/images/car2.webp';
      case "احمد شوقي":
        return 'assets/images/car2.webp';
      default:
        return 'assets/images/car2.webp';
    }
  }
}

class ChipButton extends StatelessWidget {
  final String text;

  ChipButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.find<ChatController>().sendMessage(text);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Color(0xFF273470)),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
