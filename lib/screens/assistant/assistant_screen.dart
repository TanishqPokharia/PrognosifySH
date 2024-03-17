import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class PrognosifyAssistant extends StatefulWidget {
  const PrognosifyAssistant({super.key});

  @override
  State<PrognosifyAssistant> createState() => _PrognosifyAssistantState();
}

final ChatUser currentUser = ChatUser(
    id: "1", firstName: "${FirebaseAuth.instance.currentUser!.displayName}");
final ChatUser bot = ChatUser(id: "2", firstName: "Prognosify Assistant");

class _PrognosifyAssistantState extends State<PrognosifyAssistant> {
  List<ChatMessage> messages = [
    ChatMessage(
        user: bot,
        createdAt: DateTime.now(),
        text:
            "Hi ${FirebaseAuth.instance.currentUser!.displayName}!, how may I assist you?")
  ];
  List<ChatUser> typing = [];

  final user = FirebaseAuth.instance.currentUser;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    //get user location permission
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   await Geolocator.openLocationSettings();
    //   return Future.error('Location services are disabled.');
    // }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> getAddressFromPosition(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(position.longitude);
    print(position.latitude);

    print(placemarks);
    print(placemarks.first);
    print(placemarks[0].name);
    // return placemarks[0].locality;
    return placemarks[0].locality!;
  }

  getResponse(ChatMessage message) async {
    setState(() {
      typing.add(bot);
    });
    messages.insert(0, message);
    final location;
    if (message.text.contains("find doctors")) {
      Position position = await _determinePosition();
      location = await getAddressFromPosition(position);
    }

    Map<String, String> data = {
      // "location": message.text.contains("find doctors")
      //     ? await getAddressFromPosition(position)
      //     : "",
      "location": message.text.contains("find doctors") ? "Chennai" : "",
      "chat": message.text
    };
    // Position position = await _determinePosition();
    final header = {"Content-Type": "application/json"};
    final encodedData = jsonEncode(data);
    await http
        .post(Uri.parse("https://prognosifyassistantchatapi.onrender.com/chat"),
            body: encodedData, headers: header)
        .then((value) {
      if (value.statusCode == 200) {
        final receivedMessage = value.body;
        final response = ChatMessage(
            user: bot,
            createdAt: DateTime.now(),
            text: receivedMessage,
            isMarkdown: true);
        messages.insert(0, response);
      } else {
        print(value.body);
      }
    }).catchError((error) => throw error);

    typing.remove(bot);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Prognosify Assistant",
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: DashChat(
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.teal,
          showTime: true,
        ),
        currentUser: currentUser,
        onSend: (message) {
          getResponse(message);
        },
        messages: messages,
        typingUsers: typing,
      ),
    );
  }
}
