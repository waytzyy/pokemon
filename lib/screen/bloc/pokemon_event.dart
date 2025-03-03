import 'package:equatable/equatable.dart';

abstract class PokemonEvent {}

class FetchPokemonEvent extends PokemonEvent {}

class LoadPokemonList extends PokemonEvent {}

class LoadMorePokemon extends PokemonEvent {}