class EnquiryModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String enquiryType; // 'student', 'client', 'other'
  final String? course;
  final String? service;
  final String message;
  final String status; // 'New', etc
  final String createdAt;
  final String? addedBy;

  EnquiryModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.enquiryType,
    this.course,
    this.service,
    required this.message,
    required this.status,
    required this.createdAt,
    this.addedBy,
  });

  factory EnquiryModel.fromJson(Map<String, dynamic> json) {
    // Handle cases where name might be null or inside a nested object if populated
    String extractName() {
      if (json['name'] != null) return json['name'];
      return "Unknown Contact";
    }

    return EnquiryModel(
      id: json['_id'] ?? '',
      name: extractName(),
      email: json['email'] ?? 'No Email',
      phone: json['phone'] ?? 'No Phone',
      enquiryType: json['enquiryType'] ?? 'other',
      course: json['course'],
      service: json['service'],
      message: json['message'] ?? '',
      status: json['status'] ?? 'New',
      createdAt: json['createdAt'] ?? '',
      addedBy: json['addedBy'] is Map ? json['addedBy']['name'] : (json['addedBy'] ?? '-'),
    );
  }

   // Helper to get the Course/Service string for the PDF
  String get courseOrService {
    if (course != null && course!.isNotEmpty) return course!;
    if (service != null && service!.isNotEmpty) return service!;
    return "-";
  }
}

class EnquiryPagination {
  final int currentPage;
  final int total;
  final int totalPages;

  EnquiryPagination({required this.currentPage, required this.total, required this.totalPages});

  factory EnquiryPagination.fromJson(Map<String, dynamic> json) {
    return EnquiryPagination(
      currentPage: json['currentPage'] ?? 1,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}