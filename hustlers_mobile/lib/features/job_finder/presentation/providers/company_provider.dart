import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/company_remote_datasource.dart';
import '../../data/models/company_model.dart';
import '../../data/models/company_insight_model.dart';

final companyRemoteDataSourceProvider = Provider((ref) {
  return CompanyRemoteDataSource(client: http.Client());
});

class CompanySearchState {
  final String location;
  final String companyType;
  final String searchType;
  final AsyncValue<List<CompanyModel>> companies;

  CompanySearchState({
    required this.location,
    required this.companyType,
    required this.searchType,
    required this.companies,
  });

  CompanySearchState copyWith({
    String? location,
    String? companyType,
    String? searchType,
    AsyncValue<List<CompanyModel>>? companies,
  }) {
    return CompanySearchState(
      location: location ?? this.location,
      companyType: companyType ?? this.companyType,
      searchType: searchType ?? this.searchType,
      companies: companies ?? this.companies,
    );
  }
}

class CompanySearchNotifier extends StateNotifier<CompanySearchState> {
  final CompanyRemoteDataSource dataSource;

  // City Coordinates Map
  final Map<String, Map<String, double>> cityCoordinates = {
    "Addis Ababa": {"lat": 9.0192, "lon": 38.7525},
    "Adama": {"lat": 8.5500, "lon": 39.2667},
    "Bahir Dar": {"lat": 11.5742, "lon": 37.3614},
    "Hawassa": {"lat": 7.0504, "lon": 38.4955},
    "Mekelle": {"lat": 13.4969, "lon": 39.4767},
    "Dire Dawa": {"lat": 9.6009, "lon": 41.8542},
    "Gondar": {"lat": 12.6000, "lon": 37.4667},
    "Jimma": {"lat": 7.6667, "lon": 36.8333},
    "Asosa": {"lat": 10.0667, "lon": 34.5333},
  };

  // Find Type Radius Map (in meters)
  final Map<String, int> searchRadius = {
    "Fast Find": 1000,
    "Normal Find": 5000,
    "Deep Large Scale Find": 10000,
  };

  CompanySearchNotifier(this.dataSource)
      : super(CompanySearchState(
          location: 'Addis Ababa',
          companyType: 'Hotel',
          searchType: 'Normal Find',
          companies: const AsyncValue.loading(),
        )) {
    search();
  }

  Future<void> search() async {
    state = state.copyWith(companies: const AsyncValue.loading());
    try {
      final coords = cityCoordinates[state.location] ?? cityCoordinates["Addis Ababa"]!;
      // Default to 5000 if key not found, as 1000 might be too small
      final radius = searchRadius[state.searchType] ?? 5000;
      
      // debugPrint("Searching: Location=${state.location}, Type=${state.companyType}, Radius=$radius");

      final result = await dataSource.getNearbyCompanies(
        lat: coords["lat"]!,
        lon: coords["lon"]!,
        category: state.companyType,
        radius: radius,
      );
      state = state.copyWith(companies: AsyncValue.data(result));
    } catch (e, stack) {
      state = state.copyWith(companies: AsyncValue.error(e, stack));
    }
  }

  void updateParams({String? location, String? companyType, String? searchType}) {
    state = state.copyWith(
      location: location,
      companyType: companyType,
      searchType: searchType,
    );
    search();
  }
}

final companySearchProvider = StateNotifierProvider<CompanySearchNotifier, CompanySearchState>((ref) {
  final dataSource = ref.watch(companyRemoteDataSourceProvider);
  return CompanySearchNotifier(dataSource);
});
