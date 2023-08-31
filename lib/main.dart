import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list_app/blocs/movie_genre/movie_genre_bloc.dart';
import 'package:movie_list_app/data/repository/remote_data/movie_api_data_repository.dart';
import 'package:movie_list_app/ui/movie_list.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MovieApiDataRepository>(
          create: (_) => MovieApiDataRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MovieGenreBloc(
              context.read<MovieApiDataRepository>(),
            )..add(const LoadMovieGenreEvent()),
          ),
        ],
        child: MaterialApp(
          title: 'Movie List Demo',
          theme: ThemeData(
            primaryColor: Colors.white,
          ),
          home: const MovieList(),
        ),
      ),
    );
  }
}
