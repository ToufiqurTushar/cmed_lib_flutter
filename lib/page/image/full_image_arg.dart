class FullImageArg {
  FullImageArg({
      required this.image,
      this.isLocalFile,});

  FullImageArg.fromJson(dynamic json) {
    image = json['image']??'';
    isLocalFile = json['isLocalFile'];
  }
  String image = "";
  bool? isLocalFile;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = image;
    map['isLocalFile'] = isLocalFile;
    return map;
  }

}