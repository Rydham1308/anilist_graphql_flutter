enum ApiStatus { isLoaded, isLoading, isError, networkError }

class ApiHelper {
  final ApiStatus status;
  List<dynamic>? mediaModel;

  ApiHelper({
    required this.status,
    this.mediaModel,
  });
}

class MediaModel {
  final String siteUrl;
  final String description;
  final TitleModel title;

  MediaModel(
      {required this.siteUrl, required this.description, required this.title});

  MediaModel.fromJson(Map<String, dynamic> json)
      : siteUrl = json['siteUrl'],
        description = json['description'],
        title = TitleModel.fromJson(json['title']);
}

class TitleModel {
  final String? english;
  final String? native;

  TitleModel(this.english,  this.native);

  TitleModel.fromJson(Map<String, dynamic> json): english = json['english'],native = json['native'];
}
