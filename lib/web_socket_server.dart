import 'dart:io';
import 'dart:async';



main() {
  runZoned(() async {
    var server = await HttpServer.bind('127.0.0.1', 8080);
    await for (var req in server) {
      var socket = await WebSocketTransformer.upgrade(req);
      socket.listen((msg){
        print('Message received: $msg');
        socket.add(msg.toString().toUpperCase());
        sleep(Duration(seconds:2));
        socket.add((msg.toString()+"Again").toUpperCase());
      });
    }
  },
      onError: (e) => print("An error occurred."));
}