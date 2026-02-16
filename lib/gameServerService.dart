import 'dart:async';
import 'dart:convert';
import 'dart:io';

class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => message;
}

// Message types for server communication
class MessageType {
  static const String request = "REQUEST";
  static const String response = "RESPONSE";
  static const String notify = "NOTIFY";
}

// Base message class
class BaseMessage {
  final String msgType;
  final String sender;

  BaseMessage({required this.msgType, required this.sender});

  Map<String, dynamic> toJson() => {
    'msgType': msgType,
    'sender': sender,
  };
}

// Request message class
class RequestMessage extends BaseMessage {
  final String requestType;
  final String? requestBody;

  RequestMessage({
    required this.requestType,
    required String sender,
    this.requestBody,
  }) : super(msgType: MessageType.request, sender: sender);

  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'requestType': requestType,
    'requestBody': requestBody,
  };
}

// Response message class
class ResponseMessage extends BaseMessage {
  final String responseType;
  final String? responseBody;

  ResponseMessage({
    required this.responseType,
    required this.responseBody,
    required String sender,
  }) : super(msgType: MessageType.response, sender: sender);

  factory ResponseMessage.fromJson(Map<String, dynamic> json) {
    return ResponseMessage(
      responseType: json['responseType'],
      responseBody: json['responseBody'],
      sender: json['sender'],
    );
  }
}

// Notify message class
class NotifyMessage extends BaseMessage {
  final String notifyType;
  final String? notifyBody;

  NotifyMessage({
    required this.notifyType,
    required this.notifyBody,
    required String sender,
  }) : super(msgType: MessageType.notify, sender: sender);

  factory NotifyMessage.fromJson(Map<String, dynamic> json) {
    return NotifyMessage(
      notifyType: json['notifyType'],
      notifyBody: json['notifyBody'],
      sender: json['sender'],
    );
  }
}

// Game server service class
class GameServerService {
  static const String serverHost = "172.25.11.210"; // Replace with your server IP
  static const int serverPort = 35398;

  Socket? _socket;
  final StreamController<ResponseMessage> _responseController =
  StreamController<ResponseMessage>.broadcast();
  final StreamController<NotifyMessage> _notifyController =
  StreamController<NotifyMessage>.broadcast();
  String? _clientName;

  Stream<ResponseMessage> get responseStream => _responseController.stream;
  Stream<NotifyMessage> get notifyStream => _notifyController.stream;

  Future<void> connect() async {
    print('Attempting to connect to the server...');
    try {
      _socket = await Socket.connect(serverHost, serverPort);
      print('Connected to the server.');

      _socket!.listen(
            (List<int> data) {
          print('Data received from server: ${utf8.decode(data)}');
          _handleIncomingMessage(utf8.decode(data));
        },
        onError: (error) {
          print('Socket error: $error');
          _cleanup();
        },
        onDone: () {
          print('Server connection closed.');
          _cleanup();
        },
      );
    } catch (e) {
      print('Failed to connect to the server: $e');
      rethrow;
    }
  }

  void _handleIncomingMessage(String data) {
    try {
      for (String message in data.split('\n')) {
        if (message.trim().isEmpty) continue;

        Map<String, dynamic> json = jsonDecode(message);
        String msgType = json['msgType'];

        switch (msgType) {
          case MessageType.response:
            var response = ResponseMessage.fromJson(json);
            if (response.responseType == 'BADREQUEST') {
              _responseController.addError(ServerException(
                  response.responseBody ?? 'Unknown server error'));
            } else {
              _responseController.add(response);
            }
            break;
          case MessageType.notify:
            _notifyController.add(NotifyMessage.fromJson(json));
            break;
          default:
            print('Unknown message type: $msgType');
        }
      }
    } catch (e) {
      print('Error processing message: $e');
      _responseController
          .addError(ServerException('Message processing error: $e'));
    }
  }

  Future<void> sendRequest(RequestMessage request) async {
    if (_socket == null) {
      throw ServerException('Not connected to the server');
    }

    try {
      String jsonString = jsonEncode(request.toJson());
      _socket!.write(jsonString + '\n');
      await _socket!.flush();
      print('Request sent: $jsonString');
    } catch (e) {
      print('Error sending request: $e');
      throw ServerException('Failed to send request: $e');
    }
  }

  Future<void> setName(String name) async {
    _clientName = name;
    await sendRequest(RequestMessage(
      requestType: 'SETNAME',
      sender: 'null',
      requestBody: name,
    ));
  }

  Future<void> sendChat(String message) async {
    if (_clientName == null) {
      throw ServerException('Client name not set. Please set a name first.');
    }

    if (message.trim().isEmpty) {
      throw ServerException('Chat message cannot be empty.');
    }

    await sendRequest(RequestMessage(
      requestType: 'CHAT',
      sender: _clientName!,
      requestBody: message,
    ));
  }

  void _cleanup() {
    _socket?.close();
    _socket = null;
  }

  void dispose() {
    _cleanup();
    _responseController.close();
    _notifyController.close();
  }
}