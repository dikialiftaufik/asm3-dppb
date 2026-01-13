import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/reservation_model.dart';
import 'api_service.dart'; // To reuse helper methods if needed, or we implement shared helpers

class ReservationService {
  // Helper: Get Token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Helper: Headers
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Create Reservation
  Future<bool> createReservation({
    required String name,
    required String date,
    required String time,
    required String partySize,
    String? notes,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/reservations'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'reservation_date': date, // Ensure backend expects this format (Y-m-d)
          'reservation_time': time,
          'party_size': partySize,
          'special_request': notes,
        }),
      );

      print("Create Reservation Status: ${response.statusCode}");
      print("Create Reservation Body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print("Create Reservation Error: $e");
    }
    return false;
  }

  // Get User Reservations
  Future<List<ReservationModel>> getUserReservations() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/reservations/user'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => ReservationModel.fromJson(json)).toList();
      }
    } catch (e) {
      print("Get Reservations Error: $e");
    }
    return [];
  }
}
