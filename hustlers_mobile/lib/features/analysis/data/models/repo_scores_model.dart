class RepoScoresModel {
  final int relevance;
  final int impact;
  final int complexity;
  final int qualityDocsTests;
  final int recency;
  final int ownership;
  final int resultsMetrics;

  RepoScoresModel({
    required this.relevance,
    required this.impact,
    required this.complexity,
    required this.qualityDocsTests,
    required this.recency,
    required this.ownership,
    required this.resultsMetrics,
  });

  factory RepoScoresModel.fromJson(Map<String, dynamic> json) {
    return RepoScoresModel(
      relevance: json['relevance'] ?? 0,
      impact: json['impact'] ?? 0,
      complexity: json['complexity'] ?? 0,
      qualityDocsTests: json['quality_docs_tests'] ?? 0,
      recency: json['recency'] ?? 0,
      ownership: json['ownership'] ?? 0,
      resultsMetrics: json['results_metrics'] ?? 0,
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
