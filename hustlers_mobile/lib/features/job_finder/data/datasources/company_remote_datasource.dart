import 'dart:convert';
import 'package:flutter/material.dart';
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
    // debugPrint('🧠🧠🧠🧠🧠Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((json) => CompanyModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load companies: ${response.statusCode}');
    }
  }

  Future<CompanyInsightModel> getCompanyInsights({
    required CompanyModel company,
  }) async {
    final response = await client.post(
      Uri.parse('https://hustlers-production.up.railway.app/api/v1/map/company/insights'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(company.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      
      dynamic data = jsonResponse['data'];

      if (data is String) {
        // Handle case where data is a string containing JSON (common with LLM responses)
        String cleanedData = data.trim();
        if (cleanedData.startsWith('```json')) {
          cleanedData = cleanedData.replaceAll('```json', '').replaceAll('```', '');
        } else if (cleanedData.startsWith('```')) {
          cleanedData = cleanedData.replaceAll('```', '');
        }
        
        try {
          final parsedData = json.decode(cleanedData);
          return CompanyInsightModel.fromJson(parsedData);
        } catch (e) {
             debugPrint('Failed to parse string data as JSON: $e');
             throw Exception('Failed to parse insights data');
        }
      } else if (data is Map<String, dynamic>) {
         return CompanyInsightModel.fromJson(data);
      } else {
        throw Exception('Unexpected data format: ${data.runtimeType}');
      }
    } else {
      throw Exception('Failed to load company insights: ${response.statusCode}');
    }
  }
}
