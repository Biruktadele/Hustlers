import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart'; // Import MockClient from http/testing.dart
import 'package:hustlers_mobile/features/job_finder/data/datasources/company_remote_datasource.dart';
import 'package:hustlers_mobile/features/job_finder/data/models/company_model.dart';

void main() {
  late CompanyRemoteDataSource dataSource;
  late MockClient mockClient;

  group('getNearbyCompanies', () {
    final tLat = 9.0192;
    final tLon = 38.7525;
    final tCategory = 'hotel';
    final tRadius = 1000;

    final tJsonResponse = """
    {
      "status_code": 200,
      "status": "success",
      "data": [
        {
          "id": 722475375,
          "name": "Finfine Adarash Hotel",
          "description": "",
          "type": "hotel",
          "website": "",
          "phone": "",
          "email": "",
          "address": "",
          "latitude": 9.0175679,
          "longitude": 38.7581026
        },
        {
          "id": 1594538584,
          "name": "Lido Hotel",
          "description": "",
          "type": "hotel",
          "website": "",
          "phone": "+251115514488",
          "email": "",
          "address": "",
          "latitude": 9.0166075,
          "longitude": 38.7474707
        },
        {
          "id": 42981906,
          "name": "Fle woha",
          "description": "",
          "type": "hotel",
          "website": "",
          "phone": "",
          "email": "",
          "address": "",
          "latitude": 9.0185622,
          "longitude": 38.7586065
        }
      ]
    }
    """;

    test('should return list of CompanyModel when the response code is 200', () async {
      // arrange
      mockClient = MockClient((request) async {
         return http.Response(tJsonResponse, 200);
      });
      dataSource = CompanyRemoteDataSource(client: mockClient);

      // act
      final result = await dataSource.getNearbyCompanies(
        lat: tLat,
        lon: tLon,
        category: tCategory,
        radius: tRadius,
      );

      // assert
      expect(result, isA<List<CompanyModel>>());
      expect(result.length, 3);
      expect(result[0].name, 'Finfine Adarash Hotel');
      expect(result[0].id, 722475375);
      expect(result[1].name, 'Lido Hotel');
      expect(result[2].name, 'Fle woha');
    });
  });
}
