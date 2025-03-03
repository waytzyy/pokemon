import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_mobile_apps/screen/bloc/pokemon_bloc..dart';
import 'package:pokemon_mobile_apps/screen/bloc/pokemon_event.dart';
import 'package:pokemon_mobile_apps/screen/home_screen.dart';
import 'core/api_service.dart';
import 'repositories/pokemon_repository.dart';


void main() {
  final apiService = ApiService();
  final repository = PokemonRepository(apiService);

  runApp(
    BlocProvider(
      create: (context) => PokemonBloc(repository)..add(LoadPokemonList()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}