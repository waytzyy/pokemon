class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final String species;
  final double height;
  final double weight;
  final List<String> abilities;
  final Map<String, int> stats;
  final Map<String, dynamic>? speciesData;
  final List<Map<String, dynamic>>? moves;
  final Map<String, dynamic>? evolutionChain;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.species,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.stats,
    this.speciesData,
    this.moves,
    this.evolutionChain,
  });

  String get genderRate {
    final rate = speciesData?['gender_rate'] ?? -1;
    if (rate == -1) return 'Genderless';
    final femaleRate = (rate / 8) * 100;
    final maleRate = 100 - femaleRate;
    return '♂ ${maleRate.toStringAsFixed(1)}% ♀ ${femaleRate.toStringAsFixed(1)}%';
  }

  String get eggGroups {
    final groups = (speciesData?['egg_groups'] as List?)?.map((group) => group['name']) ?? [];
    return groups.join(', ');
  }

  String get hatchCounter {
    final counter = speciesData?['hatch_counter'] ?? 0;
    return '${counter * 255} steps';
  }

  List<String> get movesList {
    if (moves == null || moves!.isEmpty) return [];
    return moves!.map((move) => move['move']['name'].toString()).toList();
  }

  List<Map<String, dynamic>> get evolutionList {
    List<Map<String, dynamic>> evolutions = [];
    if (evolutionChain == null) return evolutions;

    var evoData = evolutionChain!['chain'];
    while (evoData != null) {
      final details = evoData['evolution_details']?.isNotEmpty == true 
          ? evoData['evolution_details'][0] 
          : null;
          
      evolutions.add({
        'name': evoData['species']['name'],
        'min_level': details?['min_level'] ?? 1,
      });

      final evolves_to = evoData['evolves_to'] as List?;
      evoData = evolves_to != null && evolves_to.isNotEmpty ? evolves_to[0] : null;
    }
    
    return evolutions;
  }

  factory Pokemon.fromJson(Map<String, dynamic> json, {
    Map<String, dynamic>? speciesJson,
    Map<String, dynamic>? evolutionChainJson,
    List<Map<String, dynamic>>? movesJson,
  }) {
    final stats = Map<String, int>.fromEntries(
      (json['stats'] as List).map((stat) => MapEntry(
            stat['stat']['name'],
            stat['base_stat'] as int,
          )),
    );

    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
      types: (json['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList(),
      species: json['species']['name'],
      height: json['height'] / 10,
      weight: json['weight'] / 10,
      abilities: (json['abilities'] as List)
          .map((ability) => ability['ability']['name'] as String)
          .toList(),
      stats: stats,
      speciesData: speciesJson,
      moves: movesJson,
      evolutionChain: evolutionChainJson,
    );
  }
}