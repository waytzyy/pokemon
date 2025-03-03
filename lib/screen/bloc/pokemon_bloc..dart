import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/pokemon_repository.dart';
import '../../models/pokemon.dart';
import 'pokemon_event.dart';
import 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonRepository repository;

  PokemonBloc(this.repository) : super(PokemonInitial()) {
    on<LoadPokemonList>(_onLoadPokemonList);
    on<LoadMorePokemon>(_onLoadMorePokemon);
  }

  Future<void> _onLoadPokemonList(
      LoadPokemonList event, Emitter<PokemonState> emit) async {
    emit(PokemonLoading());
    try {
      final pokemonList = await repository.getPokemon();
      emit(PokemonLoaded(pokemonList));
    } catch (e) {
      emit(PokemonError(e.toString()));
    }
  }

  Future<void> _onLoadMorePokemon(LoadMorePokemon event, Emitter<PokemonState> emit) async {
    if (state is PokemonLoaded) {
      final currentState = state as PokemonLoaded;
      emit(PokemonLoaded(currentState.pokemonList, isLoadingMore: true));
      
      try {
        final morePokemons = await repository.getPokemon();
        if (morePokemons.isNotEmpty) {
          emit(PokemonLoaded([...currentState.pokemonList, ...morePokemons]));
        } else {
          emit(PokemonLoaded(currentState.pokemonList)); // No more Pokemon to load
        }
      } catch (e) {
        emit(PokemonLoaded(currentState.pokemonList)); // Keep existing list on error
      }
    }
  }
}