import 'package:flutter/material.dart';
import '../../data/models/analysis_response_model.dart';
import '../../data/models/analysis_data_model.dart';
import '../../data/models/suggestions_model.dart';
import '../../data/models/github_info_model.dart';
import '../../data/models/repo_model.dart';

class AnalysisResultPage extends StatelessWidget {
  final AnalysisResponseModel analysisResponse;

  const AnalysisResultPage({super.key, required this.analysisResponse});

  @override
  Widget build(BuildContext context) {
    final data = analysisResponse.data;
    final suggestions = data.suggestions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Analysis Result'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummarySection(suggestions),
            const SizedBox(height: 16),
             _buildSectionTitle('Strengths & Gaps'),
            const SizedBox(height: 8),
            _buildStrengthsAndGaps(suggestions),
            const SizedBox(height: 16),
            _buildSectionTitle('Skills to Add'),
            const SizedBox(height: 8),
            _buildSkillsToAdd(suggestions),
            const SizedBox(height: 16),
             _buildSectionTitle('GitHub Analysis'),
            const SizedBox(height: 8),
            if (suggestions.githubHighlights.isNotEmpty) ...[
              _buildListCard('GitHub Highlights', suggestions.githubHighlights, Colors.blue),
              const SizedBox(height: 12),
            ],
            _buildGithubSection(data.github),
            const SizedBox(height: 16),
            _buildSectionTitle('Recommended Next Steps'),
            const SizedBox(height: 8),
            _buildNextSteps(suggestions),
            const SizedBox(height: 16),
            _buildSectionTitle('Bullet Point Rewrites'),
            const SizedBox(height: 8),
            _buildBulletRewrites(suggestions),
             const SizedBox(height: 16),
            _buildSectionTitle('Project Improvements'),
            const SizedBox(height: 8),
            _buildProjectImprovements(suggestions),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }

  Widget _buildSummarySection(SuggestionsModel suggestions) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.amber[700]),
                const SizedBox(width: 8),
                const Text(
                  'Resume Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              suggestions.resumeSummary,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthsAndGaps(SuggestionsModel suggestions) {
    return Column(
      children: [
        _buildListCard('Strengths', suggestions.strengths, Colors.green),
        const SizedBox(height: 12),
        _buildListCard('Gaps Identified', suggestions.gaps, Colors.orange),
      ],
    );
  }

  Widget _buildListCard(String title, List<String> items, Color accentColor) {
    return Card(
      elevation: 2,
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
        leading: Icon(
          accentColor == Colors.green ? Icons.check_circle : Icons.warning_amber_rounded,
          color: accentColor,
        ),
        children: items.map((item) => ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          leading: const Icon(Icons.circle, size: 8, color: Colors.grey),
          title: Text(item),
        )).toList(),
      ),
    );
  }

  Widget _buildSkillsToAdd(SuggestionsModel suggestions) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: suggestions.skillsToAdd.map((skill) {
        return Chip(
          label: Text(skill),
          backgroundColor: Colors.deepPurple.shade50,
          side: BorderSide(color: Colors.deepPurple.shade100),
          avatar: const Icon(Icons.add, size: 16, color: Colors.deepPurple),
        );
      }).toList(),
    );
  }

  Widget _buildGithubSection(GithubInfoModel github) {
    if (github.repos.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No GitHub repositories analyzed.'),
        ),
      );
    }
    return Column(
      children: github.repos.map((repo) => _buildRepoCard(repo)).toList(),
    );
  }

  Widget _buildRepoCard(RepoModel repo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    repo.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Total: ${repo.total}/35',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (repo.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(repo.description, style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic)),
            ],
            const Divider(height: 24),
            Text('Scores', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildScoreRow('Relevance', repo.scores.relevance),
            _buildScoreRow('Impact', repo.scores.impact),
            _buildScoreRow('Complexity', repo.scores.complexity),
            _buildScoreRow('Docs & Tests', repo.scores.qualityDocsTests),
            const SizedBox(height: 8),
            const Divider(),
            if (repo.evidence.impact.isNotEmpty)
               Padding(
                 padding: const EdgeInsets.only(top: 8.0),
                 child: Text('Impact: ${repo.evidence.impact}', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
               ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(String label, int score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 12))),
          Expanded(
            child: LinearProgressIndicator(
              value: score / 5.0,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(score)),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text('$score/5', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 4) return Colors.green;
    if (score >= 3) return Colors.blue;
    if (score >= 2) return Colors.orange;
    return Colors.red;
  }

  Widget _buildNextSteps(SuggestionsModel suggestions) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: suggestions.nextSteps.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.deepPurple,
            child: Text('${index + 1}', style: const TextStyle(fontSize: 12, color: Colors.white)),
          ),
          title: Text(suggestions.nextSteps[index]),
        );
      },
    );
  }

  Widget _buildBulletRewrites(SuggestionsModel suggestions) {
    return Column(
      children: suggestions.bulletRewrites.map((rewrite) {
        return Card(
           color: Colors.grey[50],
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.edit, size: 20, color: Colors.blueGrey),
                const SizedBox(width: 12),
                Expanded(child: Text(rewrite)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProjectImprovements(SuggestionsModel suggestions) {
     return Column(
      children: suggestions.projectImprovements.map((item) {
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 8),
           shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue.shade100),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, size: 20, color: Colors.amber[800]),
                const SizedBox(width: 12),
                Expanded(child: Text(item)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
