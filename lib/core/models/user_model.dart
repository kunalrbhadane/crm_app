class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      role: json['role'] ?? 'USER',
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class UserSummary {
  final int totalUsers;
  final int activeUsers;

  UserSummary({required this.totalUsers, required this.activeUsers});

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    return UserSummary(
      totalUsers: json['totalUsers'] ?? 0,
      activeUsers: json['activeUsers'] ?? 0,
    );
  }
}


class PaginationModel {
  final int currentPage;
  final int totalPages;
  final int total;
  final int limit;

  PaginationModel({
    required this.currentPage,
    required this.totalPages,
    required this.total,
    required this.limit,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 10,
    );
  }
}