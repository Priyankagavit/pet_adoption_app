// lib/data/repositories/pet_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/pet_model.dart';

class PetRepository {
  final String _baseUrl = "https://rickandmortyapi.com/api";

  Future<PetModel> fetchPets({
    int page = 1,
    String query = '',
    String status = '',
    String gender = '',
    String species = '',
  }) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/character/?page=$page&status=$status&gender=$gender&species=$species&search=$query'));
    if (response.statusCode == 200) {

      return  PetModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load pets');
    }
  }
}
