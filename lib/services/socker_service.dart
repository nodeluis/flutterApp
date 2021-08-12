import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{
  ServerStatus _serverStatus= ServerStatus.Connecting;


  get serverStatus=>this._serverStatus;

  SocketService(){
    this._initConfig();
  }

  void _initConfig(){
    IO.Socket socket = IO.io('http://192.168.1.8:3000',{
      'transports':['websocket'],
      'autoConnect':false
    });
    socket.connect();
    socket.onConnect((_) {
      this._serverStatus=ServerStatus.Online;
      notifyListeners();
    });

    socket.onDisconnect((_) {
      this._serverStatus=ServerStatus.Offline;
      notifyListeners();
    });

    socket.on('nuevo-mensaje',(payload){
      print('nombre mensaje '+payload['name']);
    });

  }

}
