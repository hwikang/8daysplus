class UpdatePasswordModel {
  UpdatePasswordModel({this.newPassword, this.oldPassword});

  String newPassword;
  // factory UpdatePasswordModel.fromJson(Map<String,dynamic>){

  // }

  String oldPassword;

  Map<String, String> toJSON() =>
      <String, String>{'oldPassword': oldPassword, 'newPassword': newPassword};
}
