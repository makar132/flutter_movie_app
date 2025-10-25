import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../movies/domain/entities/movie.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
}
