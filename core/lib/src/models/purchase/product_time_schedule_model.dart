class ProductTimeScheduleModel {
  ProductTimeScheduleModel({
    this.id,
    this.name,
    this.lessonStartTime,
    this.lessonEndTime,
    this.possibleNumber,
    this.minNum,
    this.maxNum,
    this.remainNum,
    this.regNum,
  });

  factory ProductTimeScheduleModel.fromJson(Map<String, dynamic> json) {
    return ProductTimeScheduleModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      lessonStartTime: json['lessonStartTime'] ?? '',
      lessonEndTime: json['lessonEndTime'] ?? '',
      possibleNumber: json['possibleNumber'] ?? 0,
      minNum: json['minNum'] ?? 0,
      maxNum: json['maxNum'] ?? 0,
      remainNum: json['remainNum'] ?? 0,
      regNum: json['regNum'] ?? 0,
    );
  }

  String id;
  String lessonEndTime;
  String lessonStartTime;
  int maxNum;
  int minNum;
  String name;
  int possibleNumber;
  int regNum;
  int remainNum;

  // Map<String, dynamic> toJSON() => <String, dynamic>{
  //       'day': day,
  //       'options': options,
  //     };

}
