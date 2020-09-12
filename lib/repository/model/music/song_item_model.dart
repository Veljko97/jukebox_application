class SongItemModel {
  int id;
  String name;

  SongItemModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}

class SongItemsModel {
  List<SongItemModel> songs;

  SongItemsModel.fromJson(Map<String, dynamic> json)
      : songs = json['songs'] != null
            ? (json['songs'] as List)
                .map((e) => SongItemModel.fromJson(e))
                .toList()
            : [];
}
