class RepoEvidenceModel {
  final String relevance;
  final String impact;
  final String complexity;
  final String qualityDocsTests;
  final String recency;
  final String ownership;
  final String resultsMetrics;

  RepoEvidenceModel({
    required this.relevance,
    required this.impact,
    required this.complexity,
    required this.qualityDocsTests,
    required this.recency,
    required this.ownership,
    required this.resultsMetrics,
  });

  factory RepoEvidenceModel.fromJson(Map<String, dynamic> json) {
    return RepoEvidenceModel(
      relevance: json['relevance'] ?? '',
      impact: json['impact'] ?? '',
      complexity: json['complexity'] ?? '',
      qualityDocsTests: json['quality_docs_tests'] ?? '',
      recency: json['recency'] ?? '',
      ownership: json['ownership'] ?? '',
      resultsMetrics: json['results_metrics'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'relevance': relevance,
      'impact': impact,
      'complexity': complexity,
      'quality_docs_tests': qualityDocsTests,
      'recency': recency,
      'ownership': ownership,
      'results_metrics': resultsMetrics,
    };
  }
}
