import 'dart:io' show Platform;
import 'package:websocket/websocket.dart';

class WebSocketManager {
  static final WebSocketManager instance = WebSocketManager();
  final String wsURL = !Platform.isAndroid ? "ws://localhost:7500" : "ws://192.168.1.104";
  final _heartbeatIntervalInSeconds = 5;
  bool _active = true;
  late WebSocket webSocket;

  openWebSocketConnection() async {
    webSocket = await WebSocket.connect(wsURL);
    _startAutoReconnectListener();
  }

  Stream get socketStream => webSocket.stream;

  _startAutoReconnectListener() async {
    while (_active) {
      await Future.delayed(Duration(seconds: _heartbeatIntervalInSeconds));
      if (webSocket.readyState != 1) {
        openWebSocketConnection();
      }
    }
  }

  dispose() {
    _active = false;
  }
}