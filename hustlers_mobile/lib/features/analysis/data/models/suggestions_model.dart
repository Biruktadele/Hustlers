class SuggestionsModel {
  final String resumeSummary;
  final List<String> strengths;
  final List<String> gaps;
  final List<String> skillsToAdd;
  final List<String> projectImprovements;
  final List<String> bulletRewrites;
  final List<String> githubHighlights;
  final List<String> nextSteps;

  SuggestionsModel({
    required this.resumeSummary,
    required this.strengths,
    required this.gaps,
    required this.skillsToAdd,
    required this.projectImprovements,
    required this.bulletRewrites,
    required this.githubHighlights,
    required this.nextSteps,
  });

  factory SuggestionsModel.fromJson(Map<String, dynamic> json) {
    return SuggestionsModel(
      resumeSummary: json['resume_summary'] ?? '',
      strengths: List<String>.from(json['strengths'] ?? []),
      gaps: List<String>.from(json['gaps'] ?? []),
      skillsToAdd: List<String>.from(json['skills_to_add'] ?? []),
      projectImprovements: List<String>.from(json['project_improvements'] ?? []),
      bulletRewrites: List<String>.from(json['bullet_rewrites'] ?? []),
      githubHighlights: List<String>.from(json['github_highlights'] ?? []),
      nextSteps: List<String>.from(json['next_steps'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resume_summary': resumeSummary,
      'strengths': strengths,
      'gaps': gaps,
      'skills_to_add': skillsToAdd,
      'project_improvements': projectImprovements,
      'bullet_rewrites': bulletRewrites,
      'github_highlights': githubHighlights,
      'next_steps': nextSteps,
    };
  }
}
