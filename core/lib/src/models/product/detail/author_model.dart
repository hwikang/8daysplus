import '../../../../core.dart';

class AuthorModel {
  AuthorModel({this.name, this.introduction, this.profileImage});

  factory AuthorModel.fromJson(dynamic json) {
    return AuthorModel(
        name: json['name'],
        introduction: json['introduction'],
        profileImage: ImageViewModel.fromJson(json['profileImage']));
  }

  String introduction;
  String name;
  ImageViewModel profileImage;
}
