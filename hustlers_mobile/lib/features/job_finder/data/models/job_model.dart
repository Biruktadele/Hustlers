class JobModel {
  final int id;
  final String jobName;
  final String jobType;
  final String price;
  final String deepLink;
  final String jobDescription;
  final String? expireDate;
  final String? postedAt;

  JobModel({
    required this.id,
    required this.jobName,
    required this.jobType,
    required this.price,
    required this.deepLink,
    required this.jobDescription,
    this.expireDate,
    this.postedAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] as int,
      jobName: json['jobname'] as String,
      jobType: json['jobtype'] as String,
      price: json['price'] as String,
      deepLink: json['deep_link'] as String,
      jobDescription: json['jobdescrbiton'] as String,
      expireDate: json['expierdate'] as String?,
      postedAt: json['posted_at'] as String?,
    );
  }
}
