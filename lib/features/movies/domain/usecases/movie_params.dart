import 'package:equatable/equatable.dart';

class MovieParams extends Equatable {
  final int page;

  const MovieParams({this.page = 1});

  @override
  List<Object?> get props => [page];
}
