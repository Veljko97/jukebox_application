import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jukebox_application/repository/model/music/current_song_description_model.dart';
import 'package:jukebox_application/repository/model/music/next_song_started_model.dart';
import 'package:jukebox_application/repository/model/music/song_pick_model.dart';
import 'package:jukebox_application/ui/providers/data_provider.dart';
import 'package:jukebox_application/ui/screen_controllers/music_screen_controller.dart';
import 'package:jukebox_application/utils/utils.dart';
import 'package:provider/provider.dart';

class MusicScreen extends StatefulWidget {
  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  BuildContext context;
  DataProvider _dataProvider;

  SongPickModels _songs;
  int _selectedSongId;
  bool _first = true;

  int _currentSongId;
  int _songTime;
  int _songEndTime;
  int samplesPerSec = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_dataProvider.musicChannel == null) {
        _dataProvider.setMusicChannel(MusicScreenController().getWebSocket());
      }
      getServerTimeDifference();
      getCurrentSong();
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_first) {
      _dataProvider = Provider.of<DataProvider>(context);
      _first = false;
    }
    return Scaffold(
      body: Builder(builder: (buildContext) {
        this.context = buildContext;
        return buildBody();
      }),
    );
  }

  Widget buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
          stream: playingSong(),
          builder: (context, snapshot) {
            if (snapshot.hasData && _songTime != null) {
              String strValue = (_songTime/samplesPerSec).toStringAsFixed(0);
              int intValue = int.parse(strValue);
             return Column(
               children: [
                 LinearProgressIndicator(
                    minHeight: 20,
                    value: snapshot.data / 100,
                    backgroundColor: Colors.red,
                  ),
                 Text(formatDuration(Duration(seconds: _songTime != null ? intValue : 0)))
               ],
             );
            } else {
              return Container();
            }
          },
        ),
        StreamBuilder(
          stream: _dataProvider.musicChannel?.stream ?? null,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var nextSongStarted =  NextSongStartedModel.fromJson(jsonDecode(snapshot.data));
              if(nextSongStarted.votingList != null)
                _songs = nextSongStarted.votingList;{
                _songs.songList.sort((el1, el2) => el1.songId - el2.songId);
              }
              if(nextSongStarted.nextSong != null && _currentSongId != nextSongStarted.nextSong.songId) {
                parsSong(nextSongStarted.nextSong);
              }
            } else {
              if (_songs == null || _songs.songList.isEmpty) {
                return Container();
              }
            }
            return Container(
              height: 200,
              child: ListView.builder(
                itemCount: _songs.songList.length,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    title: Text(_songs.songList[index].songName),
                    value: _songs.songList[index].songId,
                    groupValue: _selectedSongId,
                    onChanged: (int value) {
                      setState(() {
                        _selectedSongId = value;
                      });
                      voteOnSong(value);
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void voteOnSong(int songId){
    MusicScreenController().voteOnSong(songId, (responseModel) {
      if(responseModel != null){
        if (responseModel.error != null){
          showSnackBar(this.context, responseModel.error);
        }
      }
    });
  }

  void getServerTimeDifference(){
    var start = DateTime.now().millisecondsSinceEpoch;
    MusicScreenController().getCurrentSong((responseModel) {
      if (responseModel != null) {
        if (responseModel.error != null) {
          showSnackBar(context, responseModel.error);
        } else {
          int end = DateTime.now().millisecondsSinceEpoch;
          int requestTime = end - start;
          _dataProvider.setStandardTimeDiff(end - requestTime - responseModel.response.timestamp);
        }
      }
    });
  }

  void getCurrentSong() {
    MusicScreenController().getCurrentSong((responseModel) {
      if (responseModel != null) {
        if (responseModel.error != null) {
          print("${responseModel.error}");
        } else {
          setState(() {
            parsSong(responseModel.response);
          });
        }
      }
    });
  }


  void parsSong(CurrentSongDescriptionModel currentSongDescription, {isStream = false}){
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    var diff = currentTime - currentSongDescription.timestamp;
    diff = diff - _dataProvider.standardTimeDiff;

    //TODO: calculate diff based on sample rate

    int songTime = currentSongDescription.songCurrentSample + diff;
    int songEndTime = currentSongDescription.songMaxSample;
//    print("secs ${songTime} current $_songTime and diff $diff, sampleRate ${currentSongDescription.sampleRate}");

    if(_songTime != null) {
      String strValue = (_songTime/currentSongDescription.sampleRate).toStringAsFixed(0);
//      int intValue = int.parse(strValue);
//      print("${intValue}");
//      print("${songTime - _songTime}");
    }
    _currentSongId = currentSongDescription.songId;
    samplesPerSec = currentSongDescription.sampleRate;
    _songTime = songTime;
    _songEndTime = songEndTime;
  }

  Stream<double> playingSong() async* {
    while(_songTime <= _songEndTime){
      await Future.delayed(Duration(seconds: 1));
      yield _songTime/_songEndTime * 100;
      _songTime += samplesPerSec;
    }
    _songTime = null;
    _songEndTime = null;
  }
}
