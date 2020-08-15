
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class DataProvider extends ChangeNotifier {

  int standardTimeDiff;
  IOWebSocketChannel musicChannel;


  setStandardTimeDiff(int standardTimeDiff){
    this.standardTimeDiff = standardTimeDiff;
    notifyListeners();
  }

  setMusicChannel(IOWebSocketChannel musicChannel){
    this.musicChannel = musicChannel;
    notifyListeners();
  }

}