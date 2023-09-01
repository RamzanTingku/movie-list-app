part of 'movie_genre_bloc.dart';

@immutable
abstract class MovieGenreEvent extends Equatable {
  const MovieGenreEvent();
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoadMovieGenreEvent extends MovieGenreEvent {
  const LoadMovieGenreEvent();

  @override
  List<Object> get props => [];
}

class SelectMovieGenreEvent extends MovieGenreEvent {
  final int? selectedMovieGenreId;
  const SelectMovieGenreEvent(this.selectedMovieGenreId);

  @override
  List<Object> get props => [];
}