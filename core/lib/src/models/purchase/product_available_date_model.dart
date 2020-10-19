import '../../../core.dart';
import 'product_time_schedule_model.dart';

class ProductAvailableDateModel {
  ProductAvailableDateModel({this.day, this.options, this.timeSchedules});

  factory ProductAvailableDateModel.fromJson(Map<String, dynamic> json) {
    List<ProductOptionsModel> optionList;
    List<ProductTimeScheduleModel> timeScheduleList;

    final List<dynamic> list = json['options'];
    optionList = list.map((dynamic item) {
      return ProductOptionsModel.fromJson(item);
    }).toList();

    final List<dynamic> timeScheduleJson = json['timeSchedules'];
    timeScheduleList = timeScheduleJson.map((dynamic item) {
      return ProductTimeScheduleModel.fromJson(item);
    }).toList();

    return ProductAvailableDateModel(
        day: json['day'], options: optionList, timeSchedules: timeScheduleList);
  }

  String day;
  List<ProductOptionsModel> options;
  List<ProductTimeScheduleModel> timeSchedules;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'day': day,
        'options': options,
        'timeSchedules': timeSchedules,
      };
}
