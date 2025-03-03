import 'package:equatable/equatable.dart';
import '../../models/pokemon.dart';

abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object?> get props => [];
}

class PokemonInitial extends PokemonState {}

class PokemonLoading extends PokemonState {}

class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemonList;
  final bool isLoadingMore;

  const PokemonLoaded(this.pokemonList, {this.isLoadingMore = false});

  @override
  List<Object?> get props => [pokemonList, isLoadingMore];
}

class PokemonError extends PokemonState {
  final String message;

  const PokemonError(this.message);

  @override
  List<Object?> get props => [message];
}