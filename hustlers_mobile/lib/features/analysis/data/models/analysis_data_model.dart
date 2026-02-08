import 'github_info_model.dart';
import 'resume_info_model.dart';
import 'suggestions_model.dart';

class AnalysisDataModel {
  final ResumeInfoModel resume;
  final GithubInfoModel github;
  final SuggestionsModel suggestions;

  AnalysisDataModel({
    required this.resume,
    required this.github,
    required this.suggestions,
  });

  factory AnalysisDataModel.fromJson(Map<String, dynamic> json) {
    return AnalysisDataModel(
      resume: ResumeInfoModel.fromJson(json['resume']),
      github: GithubInfoModel.fromJson(json['github']),
      suggestions: SuggestionsModel.fromJson(json['suggestions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resume': resume.toJson(),
      'github': github.toJson(),
      'suggestions': suggestions.toJson(),
    };
  }
}
