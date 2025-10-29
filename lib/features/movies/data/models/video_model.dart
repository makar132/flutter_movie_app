
import '../../domain/entities/movie_details.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.key,
    required super.name,
    required super.site,
    required super.type,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
    );
  }
}