import 'repo_model.dart';

class GithubInfoModel {
  final String username;
  final String role;
  final List<RepoModel> repos;

  GithubInfoModel({
    required this.username,
    required this.role,
    required this.repos,
  });

  factory GithubInfoModel.fromJson(Map<String, dynamic> json) {
    return GithubInfoModel(
      username: json['username'] ?? '',
      role: json['role'] ?? '',
      repos: (json['repos'] as List<dynamic>?)
              ?.map((e) => RepoModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'role': role,
      'repos': repos.map((e) => e.toJson()).toList(),
    };
  }
}
