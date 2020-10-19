class InquiryListModel {
  InquiryListModel(
      {this.id,
      this.title,
      this.type,
      this.message,
      this.createdAt,
      this.replies});

  factory InquiryListModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonList = json['replies'];
    var replies = <InquiryReplyModel>[];

    if (jsonList.isNotEmpty) {
      replies = jsonList.map((dynamic reply) {
        return InquiryReplyModel.fromJson(reply);
      }).toList();
    }
    return InquiryListModel(
        id: json['id'],
        title: json['title'],
        type: json['type'],
        message: json['message'],
        createdAt: json['createdAt'],
        replies: replies);
  }

  String createdAt;
  String id;
  String message;
  List<InquiryReplyModel> replies;
  String title;
  String type;
}

class InquiryReplyModel {
  InquiryReplyModel({
    this.message,
    this.createdAt,
  });

  factory InquiryReplyModel.fromJson(Map<String, dynamic> json) {
    return InquiryReplyModel(
      message: json['message'],
      createdAt: json['createdAt'],
    );
  }

  String createdAt;
  String message;
}
