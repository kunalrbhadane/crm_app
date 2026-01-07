class Enquiry {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String enquiryType;
  final String message;
  final String? notes; // This field is used for 'Other' details
  final String? status;
  final DateTime? createdAt;

  final String? course;
  final String? service;

  // MODIFIED: The redundant 'other' property has been removed.
  Enquiry({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.enquiryType,
    required this.message,
    this.notes,
    this.status,
    this.createdAt,
    this.course,
    this.service,
  });

  factory Enquiry.fromJson(Map<String, dynamic> json) {
    return Enquiry(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      enquiryType: json['enquiryType'],
      message: json['message'],
      notes: json['notes'], // Correctly parses the 'notes' field from the API
      status: json['status'],
      course: json['course'],
      service: json['service'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}