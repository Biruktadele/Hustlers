class SavedJobModel {
  final int id;
  final String jobName;
  final String jobType;
  final String price;
  final String deepLink;
  final String jobDescription;
  final String? expireDate;
  final String? postedAt;
  final String status;

  SavedJobModel({
    required this.id,
    required this.jobName,
    required this.jobType,
    required this.price,
    required this.deepLink,
    required this.jobDescription,
    this.expireDate,
    this.postedAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobname': jobName,
      'jobtype': jobType,
      'price': price,
      'deep_link': deepLink,
      'jobdescrbiton': jobDescription,
      'expierdate': expireDate,
      'posted_at': postedAt,
      'status': status,
    };
  }

  factory SavedJobModel.fromMap(Map<String, dynamic> map) {
    return SavedJobModel(
      id: map['id'] as int,
      jobName: map['jobname'] as String,
      jobType: map['jobtype'] as String,
      price: map['price'] as String,
      deepLink: map['deep_link'] as String,
      jobDescription: map['jobdescrbiton'] as String,
      expireDate: map['expierdate'] as String?,
      postedAt: map['posted_at'] as String?,
      status: map['status'] as String,
    );
  }
}
