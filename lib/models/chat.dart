class Chat {
  final int? id;
  final String avatarUrl;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;

  Chat({
    this.id,
    required this.avatarUrl,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'avatarUrl': avatarUrl,
      'name': name,
      'lastMessage': lastMessage,
      'time': time,
      'unreadCount': unreadCount,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      avatarUrl: map['avatarUrl'],
      name: map['name'],
      lastMessage: map['lastMessage'],
      time: map['time'],
      unreadCount: map['unreadCount'],
    );
  }
}
