import 'dart:convert';

class DeviceInfoModel {
  const DeviceInfoModel(
      {this.uuid = '',
      this.os = '',
      this.av = '',
      this.osVer = '',
      this.deviceModel = ''});

  final String av;
  final String deviceModel;
  final String os;
  final String osVer;
  final String uuid;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'uuid': json.encode(uuid),
        'os': json.encode(os),
        'av': json.encode(av),
        'osVer': json.encode(osVer),
        'deviceModel': json.encode(deviceModel),
      };
}
