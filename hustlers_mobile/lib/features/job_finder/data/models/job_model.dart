class JobModel {
  final String jobTitle;
  final String jobType;
  final String location;
  final String sex;
  final String salary;
  final String deadline;
  final String description;
  final String moreInfo;
  final String deeplink;

  JobModel({
    required this.jobTitle,
    required this.jobType,
    required this.location,
    required this.sex,
    required this.salary,
    required this.deadline,
    required this.description,
    required this.moreInfo,
    required this.deeplink,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      jobTitle: json['job_title'] as String? ?? '',
      jobType: json['job_type'] as String? ?? '',
      location: json['location'] as String? ?? '',
      sex: json['sex'] as String? ?? '',
      salary: json['salary'] as String? ?? '',
      deadline: json['deadline'] as String? ?? '',
      description: json['description'] as String? ?? '',
      moreInfo: json['more_info'] as String? ?? '',
      deeplink: json['deeplink'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'job_title': jobTitle,
      'job_type': jobType,
      'location': location,
      'sex': sex,
      'salary': salary,
      'deadline': deadline,
      'description': description,
      'more_info': moreInfo,
      'deeplink': deeplink,
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      jobTitle: map['job_title'] as String? ?? '',
      jobType: map['job_type'] as String? ?? '',
      location: map['location'] as String? ?? '',
      sex: map['sex'] as String? ?? '',
      salary: map['salary'] as String? ?? '',
      deadline: map['deadline'] as String? ?? '',
      description: map['description'] as String? ?? '',
      moreInfo: map['more_info'] as String? ?? '',
      deeplink: map['deeplink'] as String? ?? '',
    );
  }
}
