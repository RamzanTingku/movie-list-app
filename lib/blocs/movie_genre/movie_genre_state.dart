part of 'movie_genre_bloc.dart';

@immutable
abstract class MovieGenreState extends Equatable{
  @override
  List<Object?> get props => throw UnimplementedError();
}

class MovieGenreLoadingState extends MovieGenreState {
  @override
  List<Object> get props => [];
}

class MovieGenreLoadedState extends MovieGenreState {
  final List<Genres> genres;
  final int? selectedGenreId;
  final List<MovieData>? movies;
  MovieGenreLoadedState(this.genres, { this.movies, this.selectedGenreId});

  @override
  List<Object?> get props => [genres];
}

class MovieGenreEmptyState extends MovieGenreState {
  @override
  List<Object> get props => [];
}

class MovieGenreLoadErrorState extends MovieGenreState {

  final String error;
  MovieGenreLoadErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class NoInternetState extends MovieGenreState {

  NoInternetState();

  @override
  List<Object> get props => [];
}
