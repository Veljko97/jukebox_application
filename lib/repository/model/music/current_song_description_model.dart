
class CurrentSongDescriptionModel {

  int timestamp;
  String name;
  int songCurrentMilliseconds;
  int songMaxMilliseconds;
  int sampleRate;

  CurrentSongDescriptionModel.fromJson(Map<String, dynamic> json)
      : timestamp = json['timestamp'],
        name = json['name'],
        songCurrentMilliseconds= json['songCurrentMilliseconds'],
        songMaxMilliseconds = json['songMaxMilliseconds'],
        sampleRate = json['sampleRate'];

}