class User {
  final int? id;
  final String name;
  final String phone;
  final String password;
  final String? avatarUrl;
  final int points;
  final int bonuses;
  final DateTime? joinDate;

  User({
    this.id,
    required this.name,
    required this.phone,
    this.password = '',
    this.avatarUrl,
    this.points = 0,
    this.bonuses = 0,
    this.joinDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'password': password,
      'avatarUrl': avatarUrl,
      'points': points,
      'bonuses': bonuses,
      'joinDate': joinDate?.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      avatarUrl: map['avatarUrl'],
      points: map['points'] ?? 0,
      bonuses: map['bonuses'] ?? 0,
      joinDate: map['joinDate'] != null ? DateTime.parse(map['joinDate']) : null,
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? phone,
    String? password,
    String? avatarUrl,
    int? points,
    int? bonuses,
    DateTime? joinDate,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      points: points ?? this.points,
      bonuses: bonuses ?? this.bonuses,
      joinDate: joinDate ?? this.joinDate,
    );
  }
}
