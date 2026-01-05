
enum EnquiryStatus { total, client, student }

class Enquiry {
  final String name;
  final DateTime date;
  final EnquiryStatus status;

  Enquiry({
    required this.name,
    required this.date,
    required this.status,
  });
}