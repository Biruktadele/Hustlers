class ResumeInfoModel {
  final String name;
  final String email;
  final String phone;
  final List<String> skills;
  final List<String> experience;
  final List<String> education;
  final List<String> projects;

  ResumeInfoModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.skills,
    required this.experience,
    required this.education,
    required this.projects,
  });

  factory ResumeInfoModel.fromJson(Map<String, dynamic> json) {
    return ResumeInfoModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      experience: List<String>.from(json['experience'] ?? []),
      education: List<String>.from(json['education'] ?? []),
      projects: List<String>.from(json['projects'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'skills': skills,
      'experience': experience,
      'education': education,
      'projects': projects,
    };
  }
}
