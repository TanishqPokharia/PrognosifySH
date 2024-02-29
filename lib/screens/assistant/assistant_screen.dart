import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PrognosifyAssistant extends StatefulWidget {
  const PrognosifyAssistant({super.key});

  @override
  State<PrognosifyAssistant> createState() => _PrognosifyAssistantState();
}

class _PrognosifyAssistantState extends State<PrognosifyAssistant> {
  late IO.Socket socket;
  final header = {'Content-Type': 'application/json'};

  final ChatUser currentUser = ChatUser(id: "1", firstName: "User");
  final ChatUser bot = ChatUser(id: "2", firstName: "Prognosify Assistant");

  List<ChatMessage> messages = [];
  List<ChatUser> typing = [];

  String receivedMessage = "";

  final user = FirebaseAuth.instance.currentUser;
  String sid = "";

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    //get user location permission
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

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

    Position position = await _determinePosition();

    if (message.text.contains("find doctors")) {
      final location = await getAddressFromPosition(position);
      socket.emit('practo_scrap', {
        'message': {'location': "Chennai", 'category': 'general'},
        'sid': sid
      });
    } else if (message.text.contains("how to book appointment")) {
      socket.emit('appointment_info', {'sid': sid});
    } else {
      socket.emit('ask_gemini', {'message': message.text, 'sid': sid});
    }

    socket.on('receive_message', (data) {
      receivedMessage = data['message'];

      final response = ChatMessage(
          user: bot, createdAt: DateTime.now(), text: receivedMessage);

      //NOW HERE YOUU CAN WRITE CODE TO SHOW THE RECEIVED TEXT IN UR CHAT UI
      messages.insert(0, response);
      print(response.text);
      setState(() {});
    });

    socket.on('receive_sid', (data) {
      sid = data['message'];

      //STORE THE RECEIVED SID IN THE DATABASE FOR EACH USER, IF ALREADY EXISTS, UPDATE IT!!!

      print(sid);
    });

    typing.remove(bot);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    socket = IO.io(
        'https://prognosifysocketserver-103f.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
    });

    //WARNING: CONNECT ONLY ONCE WITH THE SERVER, IF RECONNECTED AGAIN NO PROBLEM BUT, SID WILL CHANGE AND YOU GOTTA UPDATE IT IN THE DATABASE
    socket.onConnect((_) {
      print('Connected to server');
    });
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
