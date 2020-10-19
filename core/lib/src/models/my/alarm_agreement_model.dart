class AlarmAgreementModel {
  AlarmAgreementModel(
      {this.orderAlarm = false,
      this.customerAlarm = false,
      this.marketingAlarm = false});

  factory AlarmAgreementModel.fromJson(Map<String, dynamic> json) {
    return AlarmAgreementModel(
      orderAlarm: json['orderAlarm'] ?? false,
      customerAlarm: json['customerAlarm'] ?? false,
      marketingAlarm: json['marketingAlarm'] ?? false,
    );
  }

  bool customerAlarm;
  bool marketingAlarm;
  bool orderAlarm;

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'orderAlarm': orderAlarm,
      'customerAlarm': customerAlarm,
      'marketingAlarm': marketingAlarm,
    };
  }
}
