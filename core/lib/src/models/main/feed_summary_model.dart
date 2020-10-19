class FeedSummaryModel {
  FeedSummaryModel({
    this.name,
    this.score,
  });

  factory FeedSummaryModel.fromJson(Map<String, dynamic> json) {
    // print('promotion $json');

    return FeedSummaryModel(
      name: json['name'],
      score: json['score'],
    );
  }

  String name;
  int score;
}
