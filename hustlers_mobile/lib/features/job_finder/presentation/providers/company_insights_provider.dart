
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hustlers_mobile/features/job_finder/data/models/company_insight_model.dart';
import 'package:hustlers_mobile/features/job_finder/presentation/providers/company_provider.dart';
import 'package:hustlers_mobile/features/job_finder/data/models/company_model.dart';

final companyInsightsProvider = FutureProvider.family<CompanyInsightModel, CompanyModel>((ref, company) async {
  final dataSource = ref.watch(companyRemoteDataSourceProvider);
  return dataSource.getCompanyInsights(company: company);
});

