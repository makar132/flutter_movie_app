// lib/features/movies/data/models/video_model.dart

import '../../domain/entities/movie_details.dart';

class VideoModel extends Video {
  const VideoModel({
    required String id,
    required String key,
    required String name,
    required String site,
    required String type,
  }) : super(
    id: id,
    key: key,
    name: name,
    site: site,
    type: type,
  );

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