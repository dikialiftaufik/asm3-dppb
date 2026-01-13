import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models.dart'; // Assuming Order model is here or we need to check

class OrderService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Order>> getHistory() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/orders/history'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // PERHATIAN: Sesuaikan parsing data dengan response Laravel
        // Jika response: { "data": [...] }
        final json = jsonDecode(response.body);
        List<dynamic> list = [];
        if (json is Map && json.containsKey('data')) {
           list = json['data'];
        } else if (json is List) {
           list = json;
        }
        
        return list.map((e) => Order.fromJson(e)).toList(); 
      }
    } catch (e) {
      print("Get History Error: $e");
    }
    return [];
  }
}
