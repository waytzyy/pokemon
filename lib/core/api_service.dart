import 'package:dio/dio.dart';

class ApiService {
  final dio = Dio();
  int offset = 0;
  final int limit = 10;

  Future<List<dynamic>> fetchPokemonList() async {
    try {
      final response = await dio.get(
        'https://pokeapi.co/api/v2/pokemon',
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
      );
      offset += limit;
      return response.data['results'];
    } catch (e) {
      throw Exception('Failed to fetch pokemon list: $e');
    }
  }

  Future<Map<String, dynamic>> fetchPokemonDetail(String url) async {
    try {
      final response = await dio.get(url);
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch pokemon detail: $e');
    }
  }

  Future<Map<String, dynamic>> fetchPokemonSpecies(int id) async {
    try {
      final response = await dio.get('https://pokeapi.co/api/v2/pokemon-species/$id');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch pokemon species: $e');
    }
  }

  Future<Map<String, dynamic>> fetchEvolutionChain(String url) async {
    try {
      final response = await dio.get(url);
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch evolution chain: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPokemonMoves(int id) async {
    try {
      final response = await dio.get('https://pokeapi.co/api/v2/pokemon/$id');
      final movesList = response.data['moves'] as List;
      return List<Map<String, dynamic>>.from(movesList);
    } catch (e) {
      throw Exception('Failed to fetch pokemon moves: $e');
    }
  }
}