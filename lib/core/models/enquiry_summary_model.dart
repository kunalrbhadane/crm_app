class EnquirySummaryModel {
  final int totalEnquiries;
  final int students;
  final int clients;
  final int others;

  EnquirySummaryModel({
    this.totalEnquiries = 0,
    this.students = 0,
    this.clients = 0,
    this.others = 0,
  });

  factory EnquirySummaryModel.fromJson(Map<String, dynamic> json) {
    return EnquirySummaryModel(
      totalEnquiries: json['totalEnquiries'] ?? 0,
      students: json['students'] ?? 0,
      clients: json['clients'] ?? 0,
      others: json['others'] ?? 0,
    );
  }
}