import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';


//this code receives message from client and sends it back instantly and aftr 2 seconds after converting to uppercase
main() {
  List<WebSocket>connections=[];
  List<String>uripathList=[];
  String message;
  runZoned(() async {
    var server = await HttpServer.bind('127.0.0.1', 8080);
    print("Websocket started . Listening on port 8080");
    await for (var req in server) {
      print('request for connection received');
      var socket = await WebSocketTransformer.upgrade(req);
      connections.add(socket);
      uripathList.add((req.uri.path).toString());

      socket.listen((msg){
        message=msg;
        print('Message received: $msg');
        if(msg!=null)for(int i=0;i<connections.length;i++){
          if(connections[i]!=socket && uripathList[i]==(req.uri.path).toString())
        connections[i].add(message.toUpperCase());
        }
        //Future.delayed(Duration(milliseconds: 2000),(){socket.add((msg.toString()+"Again").toUpperCase());});
      });
    }
    },
      onError: (e) => print("An error occurred."));
}

//main() {
//  List<WebSocket>connections=[];
//  String message;
//  runZoned(() async {
//    var server = await HttpServer.bind('127.0.0.1', 8080);
//    print("Websocket started . Listening on port 8080");
//    await for (var req in server) {
//      print('request for connection received');
//      var socket = await WebSocketTransformer.upgrade(req);
//      connections.add(socket);
//      print(connections.length);
//      socket.listen((msg){
//        message=msg;
//        print('Message received: $msg');
//        if(msg!=null)for(int i=0;i<connections.length;i++){ //send to every client
//        connections[i].add(message.toUpperCase());
//        }
//        Future.delayed(Duration(milliseconds: 2000),(){socket.add((msg.toString()+"Again").toUpperCase());});
//      });
//    }
//    },
//      onError: (e) => print("An error occurred."));
//}
