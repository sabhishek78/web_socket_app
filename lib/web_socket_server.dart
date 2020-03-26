import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';


//this code receives message from client and sends it back instantly and aftr 2 seconds after converting to uppercase
main() {
  List<WebSocket>connections=[];
  List<String>uripathList=[];
//  List<String> messagesList=[];

  File file = new File("G:\messages.txt");
  String message;
  runZoned(() async {
    var server = await HttpServer.bind('127.0.0.1', 8080);
    print("Websocket started . Listening on port 8080");
    await for (var req in server) {
     print('request for connection received');
      var socket = await WebSocketTransformer.upgrade(req);
      connections.add(socket);
      uripathList.add((req.uri.path).toString());
      file.readAsString().then((String contents) {
        print("sending file to new connection");
        String temp="";//send file to new connection
        if(contents.length!=0){
          for(int i=0;i<contents.length;i++){
            print("browsing through contents");
            if(contents[i]!='\n'){
              print("contents[i=${contents[i]}");
              temp=temp+contents[i];
              print("temp=$temp");
            }
            if(contents[i]=='\n'){
              print("sending $temp to socket");
              socket.add(temp);
              temp='';
            }

          }
        }

       // socket.add(contents);
      });
      socket.listen((msg){
       message=msg;
      //  messagesList.add(msg);
       print('Message received: $msg');
        writeToFile(file,msg);
        print("Printing file contents...");
        printFile(file);
        if(msg!=null)for(int i=0;i<connections.length;i++){ //send message to all except the sender
          if(connections[i]!=socket && uripathList[i]==(req.uri.path).toString())
        connections[i].add(message.toUpperCase());
//          file.readAsString().then((String contents) {
//            connections[i].add(contents);
//          });
        }
        //Future.delayed(Duration(milliseconds: 2000),(){socket.add((msg.toString()+"Again").toUpperCase());});
      });
    }
    },
      onError: (e) => (){}//print("An error occurred.")
  );
}
writeToFile(File file,String msg)async{
 print("writing to file");
  await file.writeAsString(msg+'\n', mode: FileMode.append);
  print("successfully written on file");
}
void printFile(File file){
  file.readAsString().then((String contents) {
    print(contents);
  });
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
