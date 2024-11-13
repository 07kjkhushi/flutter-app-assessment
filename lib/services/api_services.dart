import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  final String apiUrl = "https://jsonplaceholder.typicode.com/users";


  // Method to fetch the list of users
  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Parse the response body and convert it to a list of UserModel
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((user) => UserModel.fromJson(user)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } 
  }
}
