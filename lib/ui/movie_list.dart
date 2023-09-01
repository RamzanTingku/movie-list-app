import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/movie_genre/movie_genre_bloc.dart';

class MovieList extends StatelessWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieGenreBloc, MovieGenreState>(
      builder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text("Movie List")),
          body: SafeArea(child: showDataWithSate(state)));
    },);
  }

  Widget showDataWithSate(MovieGenreState state) {
    return state is MovieGenreLoadingState ? const Center(child: Text("Loading..."))
        : state is MovieGenreEmptyState ? const Center(child: Text("No Data Found"))
        : state is NoInternetState ? const Center(child: Text("Please check your internet"))
        : state is MovieGenreLoadedState ? showMovieGenres(state)
        : const SizedBox.shrink();
  }

  Widget showMovieGenres(MovieGenreLoadedState state) {
    return Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          height: 32,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.genres.length,
              itemBuilder: (context, index) {
                return loadGenreItem(context, state, index);
              }),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
              itemCount: state.movies?.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white, border: Border.all(color: Colors.grey, width: 1)
                  ),
                  child: Column(
                    children: [
                      Text(state.movies?[index].title ?? '', style: const TextStyle(color: Colors.black)),
                      const SizedBox(height: 4),
                      Text(state.movies?[index].voteCount?.toString() ?? '', style: const TextStyle(color: Colors.black)),
                      const SizedBox(height: 4),
                      Text(state.movies?[index].releaseDate ?? '', style: const TextStyle(color: Colors.black)),
                      const SizedBox(height: 4),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget loadGenreItem(BuildContext context, MovieGenreLoadedState state,
      int index) {
    bool selected = state.selectedGenreId == state.genres[index].id;
    return GestureDetector(
      onTap: () {
        context.read<MovieGenreBloc>().add(SelectMovieGenreEvent(state.genres[index].id));
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selected ? Colors.indigo : Colors.grey
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(right: 8),
        child: Text(state.genres[index].name ?? '',
            style: TextStyle(color: selected ? Colors.white : Colors.black),
            textAlign: TextAlign.center),
      ),
    );
  }
}
