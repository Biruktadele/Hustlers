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
  final String location;
  final String sex;
  final String moreInfo;
  final bool appliedCounted; // New

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
    this.location = "Addis Ababa",
    this.sex = "",
    this.moreInfo = "",
    this.appliedCounted = false,
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
      'location': location,
      'sex': sex,
      'more_info': moreInfo,
      'applied_counted': appliedCounted ? 1 : 0,
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
      location: map['location'] as String? ?? "Addis Ababa",
      sex: map['sex'] as String? ?? "",
      moreInfo: map['more_info'] as String? ?? "",
      appliedCounted: (map['applied_counted'] as int? ?? 0) == 1,
    );
  }
}
