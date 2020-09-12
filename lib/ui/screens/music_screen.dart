import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jukebox_application/repository/model/music/current_song_description_model.dart';
import 'package:jukebox_application/repository/model/music/next_song_started_model.dart';
import 'package:jukebox_application/repository/model/music/song_item_model.dart';
import 'package:jukebox_application/repository/model/music/song_pick_model.dart';
import 'package:jukebox_application/ui/providers/data_provider.dart';
import 'package:jukebox_application/ui/screen_controllers/music_screen_controller.dart';
import 'package:jukebox_application/ui/screens/reusable/MuvingText.dart';
import 'package:jukebox_application/ui/screens/reusable/fiield_button.dart';
import 'package:jukebox_application/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class MusicScreen extends StatefulWidget {
  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  BuildContext context;
  IOWebSocketChannel _webSocketChannel;

  SongPickModels _songs;
  int _selectedSongId;
  bool _first = true;

  int _currentSongId;
  String _currentSongName;
  double _songTime;
  int _songEndTime;
  int samplesPerSec = 1;
  StreamController<double> _songStream = StreamController.broadcast();
  StreamSubscription _streamSub;

  List<SongItemModel> _allSongs = [];

  TabController _tabController;
  List<Tab> tabs = [
    Tab(
      text: "Current Song",
    ),
    Tab(
      text: "All Songs",
    )
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _webSocketChannel = MusicScreenController().getWebSocket();
      _webSocketChannel.stream.listen(webSocketListener);
      getCurrentSong();
      getVotingSongs();
    });
  }

  void webSocketListener(data) {
    if (data != null && data.isNotEmpty) {
      var nextSongStarted = NextSongStartedModel.fromJson(jsonDecode(data));
      if (nextSongStarted.votingList != null) {
        _songs = nextSongStarted.votingList;
        _songs.songList.sort((el1, el2) => el1.songId - el2.songId);
        setState(() {
          _songs;
        });
      }
      if (nextSongStarted.nextSong != null &&
          _currentSongId != nextSongStarted.nextSong.songId &&
          nextSongStarted.nextSong.songId != -1) {
        _selectedSongId = -1;
        parsSong(nextSongStarted.nextSong);
      }
    }
  }

  void tabChangeListener() {
    if (_tabController.index == 1) {
      getTempSongs();
    } else if (_tabController.index == 0) {
      setState(() {
        _allSongs = [];
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        getCurrentSong();
        break;
      case AppLifecycleState.detached:
        _webSocketChannel.sink.close();
        print("detached");
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _songStream.close();
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_first) {
      _tabController = TabController(length: tabs.length, vsync: this);
      _tabController.addListener(tabChangeListener);
      _first = false;
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        bottom: TabBar(controller: _tabController, tabs: tabs),
      ),
      body: Builder(builder: (buildContext) {
        this.context = buildContext;
        return Container(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            controller: _tabController,
            children: [
              buildMusicTab(),
              buildAllMusicTab(),
            ],
          ),
        );
      }),
    );
  }

  Widget buildMusicTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: _songs == null || _songs.songList.isEmpty
              ? Container()
              : Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _songs.songList.length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                "${_songs.songList[index].songVotes}",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                            Expanded(
                                child:
                                    Text("${_songs.songList[index].songName}")),
                          ],
                        ),
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
                ),
        ),
        Container(
          height: 100,
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${_currentSongName}"),
//              MovingText(text:"${_currentSongName}", textStyle: TextStyle(fontSize: 12),),
              _songStream != null
                  ? StreamBuilder(
                      stream: _songStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && _songTime != null) {
                          String currentTime =
                              (_songTime / samplesPerSec).toStringAsFixed(0);
                          int currentIntValue = int.parse(currentTime);
                          String endTime =
                              (_songEndTime / samplesPerSec).toStringAsFixed(0);
                          int endIntValue = int.parse(endTime);
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: LinearProgressIndicator(
                                  minHeight: 10,
                                  value: snapshot.data / 100,
                                  backgroundColor: Theme.of(context).canvasColor,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).accentColor),
                                ),
                              ),
                              Text("${formatDuration(
                                Duration(
                                    seconds:
                                        _songTime != null ? currentIntValue : 0),
                              )}/${formatDuration(
                                Duration(
                                    seconds:
                                        _songEndTime != null ? endIntValue : 0),
                              )}"),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAllMusicTab() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 29,
          child: FilledButton(
            text: "Upload Your Song",
            colorFill: Theme.of(context).buttonColor,
            onCLick: uploadSong,
          ),
        ),
        Expanded(
          child: _allSongs != null && _allSongs.isNotEmpty
              ? ListView.separated(
                  itemCount: _allSongs.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    SongItemModel song = _allSongs[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: Text(song.name),
                    );
                  },
                )
              : Center(
                  child: Text("No Songs to show"),
                ),
        )
      ],
    );
  }

  void voteOnSong(int songId) {
    MusicScreenController().voteOnSong(songId, (responseModel) {
      if (responseModel != null) {
        if (responseModel.error != null) {
          showSnackBar(this.context, responseModel.error);
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

  void getVotingSongs() {
    MusicScreenController().getVotingSongList((responseModel) {
      if (responseModel != null) {
        if (responseModel.error != null) {
          showSnackBar(context, responseModel.error);
        } else {
          if (responseModel.response.songList != null) {
            _songs = responseModel.response;
            _songs.songList.sort((el1, el2) => el1.songId - el2.songId);
            setState(() {
              _songs;
            });
          }
        }
      }
    });
  }

  void getTempSongs() {
    MusicScreenController().getTempSongs((responseModel) {
      if (responseModel != null) {
        if (responseModel.error != null) {
          showSnackBar(context, responseModel.error);
        } else {
          _allSongs.addAll(responseModel.response.songs);
          getAllSongs();
        }
      }
    });
  }

  void getAllSongs() {
    MusicScreenController().getAllSongs((responseModel) {
      if (responseModel != null) {
        if (responseModel.error != null) {
          showSnackBar(context, responseModel.error);
        } else {
          setState(() {
            _allSongs.addAll(responseModel.response.songs);
          });
        }
      }
    });
  }

  void uploadSong() async {
    File file = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ['mp3']);
    if (file != null) {
      MusicScreenController().postUserSong(file, (responseModel) {
        if (responseModel != null) {
          if (responseModel.error != null) {
            showSnackBar(context, responseModel.error);
          }
        }
      });
    }
  }

  void parsSong(CurrentSongDescriptionModel currentSongDescription) {
    _currentSongId = currentSongDescription.songId;
    _currentSongName = currentSongDescription.name;
    samplesPerSec = currentSongDescription.sampleRate;
    _songTime = currentSongDescription.songCurrentSample * 1.0;
    _songEndTime = currentSongDescription.songMaxSample;
    if (_streamSub != null) {
      _streamSub.cancel();
    }

    setState(() {
      _streamSub = playingSong().listen((event) {
        _songStream.sink.add(event);
      });
    });
  }

  Stream<double> playingSong() async* {
    while (_songTime <= _songEndTime) {
      await Future.delayed(Duration(milliseconds: 100));
      yield _songTime / _songEndTime * 100;
      _songTime += samplesPerSec / 10;
    }
    _songTime = null;
    _songEndTime = null;
  }
}
