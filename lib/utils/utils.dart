

import 'package:flutter/material.dart';

String formatDuration(Duration duration){
  return "${duration.inMinutes.remainder(60)}:${duration.inSeconds.remainder(60)}";
}


void showSnackBar(BuildContext context, String message){
  final snackBar = SnackBar(content: Text(message));
  Scaffold.of(context).showSnackBar(snackBar);
}

String getServerKeyFromLink(String link){
    List<String> tokens = link.split('/');
    return tokens.last;
}