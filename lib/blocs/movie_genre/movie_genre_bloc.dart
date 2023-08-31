import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movie_list_app/data/model/movie_genre.dart';

import '../../core/networking/internet_connectivity.dart';
import '../../data/model/movie_list.dart';
import '../../data/repository/remote_data/movie_api_data_repository.dart';

part 'movie_genre_event.dart';
part 'movie_genre_state.dart';

class MovieGenreBloc extends Bloc<MovieGenreEvent, MovieGenreState> {

  final MovieApiDataRepository _apiRepository;

  MovieGenreBloc(this._apiRepository) : super(MovieGenreLoadingState()) {
    on<LoadMovieGenreEvent>(_onLoadMovieGenres);
    on<SelectMovieGenreEvent>(_onSelectMovieGenre);
  }

  Future<void> _onLoadMovieGenres(LoadMovieGenreEvent event, Emitter<MovieGenreState> emit) async{
    emit(MovieGenreLoadingState());
    await _fetchData(emit);
  }

  Future<void> _fetchData(Emitter<MovieGenreState> emit) async{
    bool hasInternet = await InternetConnectivity.checkInternet();
    if(hasInternet){
      await _getGenres(emit);
    }else{
      emit(NoInternetState());
    }
  }

  Future<void> _getGenres(Emitter<MovieGenreState> emit) async {
    final list = await _apiRepository.getMovieGenre();
    if(list.isEmpty) {
      emit(MovieGenreEmptyState());
    }else{
      emit(MovieGenreLoadedState(list, selectedGenre: 2));
    }
  }

  Future<void> _onSelectMovieGenre(SelectMovieGenreEvent event, Emitter<MovieGenreState> emit) async {
    if(state is MovieGenreLoadedState){
      final state = this.state as MovieGenreLoadedState;
      state.selectedGenre = event.selectedMovieGenre;
      await _getMovies(emit, state, 1);
      emit(state);
      //emit(MovieGenreLoadedState(state.genres/*, selectedGenre: event.selectedMovieGenre, movies: const []*/));
    }
  }

  Future<void> _getMovies(Emitter<MovieGenreState> emit, MovieGenreLoadedState? state, int page) async {
    final list = await _apiRepository.getMovieList(state?.genres[state.selectedGenre].id?.toString(), page);
    state?.movies = list;
    final loadedState = state;
    if(list.isNotEmpty) {
      emit(loadedState as MovieGenreLoadedState);
    }else{
      emit(MovieGenreEmptyState());
    }
  }
}
