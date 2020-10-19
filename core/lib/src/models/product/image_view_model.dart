class ImageViewModel {
  const ImageViewModel({
    this.url = '',
    this.width = 0,
    this.height = 0,
  });

  factory ImageViewModel.fromJson(Map<String, dynamic> json) => ImageViewModel(
        url: json['url'] ?? '',
        width: json['width'] ?? 0,
        height: json['height'] ?? 0,
      );

  final int height;
  final String url;
  final int width;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'url': url,
        'width': width,
        'height': height,
      };
}
