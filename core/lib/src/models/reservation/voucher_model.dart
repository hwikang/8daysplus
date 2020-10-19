class VoucherModel {
  VoucherModel({this.barcode, this.filePath, this.templete});

  factory VoucherModel.fromVoucherPays(Map<String, dynamic> json) {
    return VoucherModel(
      barcode: json['barcode'],
      templete: VoucherTempleteModel.fromJson(json['templete']),
    );
  }

  factory VoucherModel.fromVoucherUrlPath(Map<String, dynamic> json) {
    return VoucherModel(
      filePath: json['filePath'],
      barcode: json['barcode'],
    );
  }

  String barcode;
  String filePath;
  VoucherTempleteModel templete;
}

class VoucherTempleteModel {
  VoucherTempleteModel({
    this.color,
    this.left,
    this.right,
  });

  factory VoucherTempleteModel.fromJson(Map<String, dynamic> json) {
    return VoucherTempleteModel(
      color: json['color'],
      left: VoucherTempleteLeftModel.fromJson(json['left']),
      right: VoucherTempleteRightModel.fromJson(json['right']),
    );
  }

  String color;
  VoucherTempleteLeftModel left;
  VoucherTempleteRightModel right;
}

class VoucherTempleteRightModel {
  VoucherTempleteRightModel({this.url});

  factory VoucherTempleteRightModel.fromJson(Map<String, dynamic> json) {
    return VoucherTempleteRightModel(
      url: json['url'],
    );
  }

  String url;
}

class VoucherTempleteLeftModel {
  VoucherTempleteLeftModel({this.url});

  factory VoucherTempleteLeftModel.fromJson(Map<String, dynamic> json) {
    return VoucherTempleteLeftModel(
      url: json['url'],
    );
  }

  String url;
}
