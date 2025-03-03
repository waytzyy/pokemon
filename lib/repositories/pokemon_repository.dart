import 'package:pokemon_mobile_apps/core/api_service.dart';
import 'package:pokemon_mobile_apps/models/pokemon.dart';
import 'dart:math' as math;

class PokemonRepository {
  final ApiService apiService;
  final Set<int> loadedPokemonIds = {}; 

  PokemonRepository(this.apiService);

  Future<List<Pokemon>> getPokemon() async {
    final data = await apiService.fetchPokemonList();
    List<Pokemon> pokemonList = [];
    
    for (var item in data) {
      try {
        final details = await apiService.fetchPokemonDetail(item['url']);
        if (loadedPokemonIds.contains(details['id'])) continue;
        loadedPokemonIds.add(details['id']);

        final speciesData = await apiService.fetchPokemonSpecies(details['id']);
        
        Map<String, dynamic>? evolutionData;
        if (speciesData['evolution_chain']?['url'] != null) {
          final evolutionUrl = speciesData['evolution_chain']['url'];
          evolutionData = await apiService.fetchEvolutionChain(evolutionUrl);
        }
        
        final moves = await apiService.fetchPokemonMoves(details['id']);
        
        pokemonList.add(Pokemon.fromJson(
          details,
          speciesJson: speciesData,
          evolutionChainJson: evolutionData,
          movesJson: moves,
        ));
      } catch (e) {
        print('Error fetching pokemon data: $e');
        continue;
      }
    }
    
    return pokemonList;
  }
}