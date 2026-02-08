import 'repo_evidence_model.dart';
import 'repo_scores_model.dart';

class RepoModel {
  final String name;
  final String url;
  final String description;
  final RepoScoresModel scores;
  final int total;
  final RepoEvidenceModel evidence;

  RepoModel({
    required this.name,
    required this.url,
    required this.description,
    required this.scores,
    required this.total,
    required this.evidence,
  });

  factory RepoModel.fromJson(Map<String, dynamic> json) {
    return RepoModel(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
      scores: RepoScoresModel.fromJson(json['scores']),
      total: json['total'] ?? 0,
      evidence: RepoEvidenceModel.fromJson(json['evidence']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'description': description,
      'scores': scores.toJson(),
      'total': total,
      'evidence': evidence.toJson(),
    };
  }
}
