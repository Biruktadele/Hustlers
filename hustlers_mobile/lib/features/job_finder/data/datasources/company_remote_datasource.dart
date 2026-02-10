import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/company_insight_model.dart';
import '../models/company_model.dart';

class CompanyRemoteDataSource {
  final http.Client client;

  CompanyRemoteDataSource({required this.client});

  Future<List<CompanyModel>> getNearbyCompanies({
    required double lat,
    required double lon,
    required String category,
    required int radius,
  }) async {
    final uri = Uri.parse(
            'https://hustlers-production.up.railway.app/api/v1/map/search/nearby')
        .replace(queryParameters: {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'category': category.toLowerCase(),
      'radius': radius.toString(),
    });

    final response = await client.get(
      uri,
      headers: {'accept': 'application/json'},
    );
    // debugPrint('Request URL: ${uri.toString()}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => CompanyModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load companies: ${response.statusCode}');
    }
  }

  Future<CompanyInsightModel> getCompanyInsights({

    required String location,
    required String companyType,
    required String searchType,
  }) async {
    final response = await client.post(
      Uri.parse('https://hustlers-production.up.railway.app/api/v1/map/company/insights'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'location': location,
        'company_type': companyType,
        'search_type': searchType,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return CompanyInsightModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load company insights: ${response.statusCode}');
    }
  }
}
