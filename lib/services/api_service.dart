import 'dart:convert';
import 'dart:io';
import '../utils/constants.dart';
import '../utils/console.dart';

class ApiService {
  final HttpClient _client = HttpClient();

  Future<dynamic> get(String endpoint) async {
    try {
      final url = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
      Console.log('GET $url');
      
      final request = await _client.getUrl(url);
      final response = await request.close();
      
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      Console.error('GET request failed', e);
      rethrow;
    }
  }
}
