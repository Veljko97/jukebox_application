
class CurrentSongDescriptionModel {

  int timestamp;
  int songId;
  String name;
  int songCurrentSample;
  int songMaxSample;
  int sampleRate;

  CurrentSongDescriptionModel.fromJson(Map<String, dynamic> json)
      : timestamp = json['timestamp'],
        songId = json['songId'],
        name = json['name'],
        songCurrentSample= json['songCurrentSample'],
        songMaxSample = json['songMaxSample'],
        sampleRate = json['sampleRate'];

}