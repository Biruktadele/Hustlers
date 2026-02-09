import 'analysis_data_model.dart';

class AnalysisResponseModel {
  final String status;
  final AnalysisDataModel data;

  AnalysisResponseModel({
    required this.status,
    required this.data,
  });

  factory AnalysisResponseModel.fromJson(Map<String, dynamic> json) {
    return AnalysisResponseModel(
      status: json['status'] ?? 'unknown',
      data: AnalysisDataModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}
