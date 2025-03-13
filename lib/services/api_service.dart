import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class ApiService {
  static const String baseUrl = "https://jsonplaceholder.typicode.com/posts";

  Future<List<Post>> fetchPosts(int page, int limit) async {
    final response = await http.get(Uri.parse("$baseUrl?_page=$page&_limit=$limit"));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load posts");
    }
  }
}
