import '../../domain/entities/movie_details.dart';

class CastModel extends Cast {
  const CastModel({
    required super.id,
    required super.name,
    required super.character,
    super.profilePath,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      profilePath: json['profile_path'],
    );
  }
}