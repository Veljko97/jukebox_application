import 'package:flutter/material.dart';
import 'package:jukebox_application/ui/providers/data_provider.dart';
import 'package:jukebox_application/ui/screens/connect_screen.dart';
import 'package:jukebox_application/ui/screens/music_screen.dart';
import 'package:jukebox_application/utils/constants.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: MaterialApp(
        title: 'Local Jukebox',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes:{
          Constants.ROUTE_CONNECTION_SCREEN: (_) => ConnectScreen(),
          Constants.ROUTE_MUSIC_SCREEN: (_) => MusicScreen(),
        },
        initialRoute: Constants.ROUTE_CONNECTION_SCREEN,
      ),
    );
  }
}
