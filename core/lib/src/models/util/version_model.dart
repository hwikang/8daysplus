class VersionModel {
  VersionModel({
    this.isForceUpdate,
    this.isUpdate,
    this.version,
    this.downloadURL,
    this.comment,
  });

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(
      isForceUpdate: json['isForceUpdate'],
      isUpdate: json['isUpdate'],
      downloadURL: json['downloadURL'],
      version: json['version'],
      comment: json['comment'],
    );
  }

  String comment;
  String downloadURL;
  bool isForceUpdate;
  bool isUpdate;
  String version;
}
