import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class User {
  final int? id;
  final String email; // We keep this named email for backward compatibility with existing code
  final String password;
  final String name;
  final String? avatarUrl;

  User({
    this.id,
    required this.email, // This field is actually used for phone numbers
    required this.password,
    required this.name,
    this.avatarUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': email, // Map email field to phone column in database
      'password': password,
      'name': name,
      'avatarUrl': avatarUrl,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['phone'] ?? '', // Map phone column to email field
      password: map['password'] ?? '',
      name: map['name'] ?? 'Пользователь',
      avatarUrl: map['avatarUrl'],
    );
  }
}

class Chat {
  final int? id;
  final int userId;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;

  Chat({
    this.id,
    required this.userId,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'unreadCount': unreadCount,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      userId: map['userId'],
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'] ?? DateTime.now().toString(),
      unreadCount: map['unreadCount'] ?? 0,
    );
  }
}

class Message {
  final int? id;
  final int chatId;
  final String message;
  final String time;
  final bool isMe;

  Message({
    this.id,
    required this.chatId,
    required this.message,
    required this.time,
    required this.isMe,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatId': chatId,
      'message': message,
      'time': time,
      'isMe': isMe ? 1 : 0,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      chatId: map['chatId'],
      message: map['message'] ?? '',
      time: map['time'] ?? DateTime.now().toString(),
      isMe: map['isMe'] == 1,
    );
  }
}

class Feedback {
  final int? id;
  final int userId;
  final String text;
  final DateTime date;
  final String status;

  Feedback({
    this.id,
    required this.userId,
    required this.text,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'text': text,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

  factory Feedback.fromMap(Map<String, dynamic> map) {
    return Feedback(
      id: map['id'],
      userId: map['userId'],
      text: map['text'] ?? '',
      date: DateTime.parse(map['date']),
      status: map['status'] ?? 'Рассматривается',
    );
  }
}

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  Database? _db;
  static const int _databaseVersion = 1;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'qamqor.db');

      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: (db, version) async {
          print('Creating database tables...');

          // Create users table
          await db.execute('''
            CREATE TABLE IF NOT EXISTS users(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              email TEXT UNIQUE,
              password TEXT,
              name TEXT,
              avatarUrl TEXT
            )
          ''');

          // Create chats table
          await db.execute('''
            CREATE TABLE IF NOT EXISTS chats(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              userId INTEGER,
              lastMessage TEXT,
              lastMessageTime TEXT,
              unreadCount INTEGER DEFAULT 0,
              FOREIGN KEY (userId) REFERENCES users (id)
            )
          ''');

          // Create messages table
          await db.execute('''
            CREATE TABLE IF NOT EXISTS messages(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              chatId INTEGER,
              message TEXT,
              time TEXT,
              isMe INTEGER,
              FOREIGN KEY (chatId) REFERENCES chats (id)
            )
          ''');

          // Create feedback table
          await db.execute('''
            CREATE TABLE IF NOT EXISTS feedback(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              userId INTEGER,
              text TEXT,
              date TEXT,
              status TEXT,
              FOREIGN KEY (userId) REFERENCES users (id)
            )
          ''');

          print('Database tables created successfully');
        },
        onOpen: (db) async {
          // Verify tables exist and their structure
          final tables = await db.query('sqlite_master',
              where: 'type = ? AND name IN (?, ?, ?, ?)',
              whereArgs: ['table', 'users', 'chats', 'messages', 'feedback']);

          print('Found tables: ${tables.map((t) => t['name']).join(', ')}');

          if (tables.length < 4) {
            print('Some tables are missing, creating them...');
            // Create missing tables
            if (!tables.any((t) => t['name'] == 'users')) {
              await db.execute('''
                CREATE TABLE IF NOT EXISTS users(
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  email TEXT UNIQUE,
                  password TEXT,
                  name TEXT,
                  avatarUrl TEXT
                )
              ''');
              print('Created users table');
            }

            if (!tables.any((t) => t['name'] == 'chats')) {
              await db.execute('''
                CREATE TABLE IF NOT EXISTS chats(
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  userId INTEGER,
                  lastMessage TEXT,
                  lastMessageTime TEXT,
                  unreadCount INTEGER DEFAULT 0,
                  FOREIGN KEY (userId) REFERENCES users (id)
                )
              ''');
              print('Created chats table');
            }

            if (!tables.any((t) => t['name'] == 'messages')) {
              await db.execute('''
                CREATE TABLE IF NOT EXISTS messages(
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  chatId INTEGER,
                  message TEXT,
                  time TEXT,
                  isMe INTEGER,
                  FOREIGN KEY (chatId) REFERENCES chats (id)
                )
              ''');
              print('Created messages table');
            }

            if (!tables.any((t) => t['name'] == 'feedback')) {
              await db.execute('''
                CREATE TABLE IF NOT EXISTS feedback(
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  userId INTEGER,
                  text TEXT,
                  date TEXT,
                  status TEXT,
                  FOREIGN KEY (userId) REFERENCES users (id)
                )
              ''');
              print('Created feedback table');
            }
            print('Missing tables created successfully');
          }

          // Verify table structure
          try {
            final userColumns = await db.query('users', limit: 1);
            print(
                'Users table columns: ${userColumns.isNotEmpty ? userColumns.first.keys.join(', ') : 'No data'}');

            final chatColumns = await db.query('chats', limit: 1);
            print(
                'Chats table columns: ${chatColumns.isNotEmpty ? chatColumns.first.keys.join(', ') : 'No data'}');
          } catch (e) {
            print('Error checking table structure: $e');
          }
        },
      );
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  // User operations
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<User?> getUserByEmail(String phoneNumber) async {
    final db = await database;
    final maps =
        await db.query('users', where: 'phone = ?', whereArgs: [phoneNumber]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<List<User>> searchUsers(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'name LIKE ? OR email LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  // Chat operations
  Future<int> createChat(int userId) async {
    try {
      final db = await database;
      return await db.insert('chats', {
        'userId': userId,
        'lastMessage': '',
        'lastMessageTime': DateTime.now().toString(),
        'unreadCount': 0,
      });
    } catch (e) {
      print('Error creating chat: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getChats() async {
    try {
      final db = await database;

      // Get current user ID from the database
      final currentUser = await db.query('users', limit: 1);
      if (currentUser.isEmpty) {
        print('No current user found');
        return [];
      }
      final currentUserId = currentUser.first['id'];

      // Get chats with user information, excluding current user
      final chats = await db.rawQuery('''
        SELECT 
          c.id,
          c.userId,
          c.lastMessage,
          c.lastMessageTime,
          c.unreadCount,
          u.email
        FROM chats c 
        INNER JOIN users u ON c.userId = u.id 
        WHERE c.userId != ?
        ORDER BY c.lastMessageTime DESC
      ''', [currentUserId]);

      print('Retrieved chats: ${chats.length}');
      if (chats.isNotEmpty) {
        print('First chat data: ${chats.first}');
      }
      return chats;
    } catch (e) {
      print('Error getting chats: $e');
      return [];
    }
  }

  Future<int> updateChatLastMessage(int chatId, String message) async {
    final db = await database;
    return await db.update(
      'chats',
      {
        'lastMessage': message,
        'lastMessageTime': DateTime.now().toString(),
      },
      where: 'id = ?',
      whereArgs: [chatId],
    );
  }

  // Message operations
  Future<int> insertMessage(Message message) async {
    final db = await database;
    return await db.insert('messages', message.toMap());
  }

  Future<List<Message>> getMessages(int chatId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'chatId = ?',
      whereArgs: [chatId],
      orderBy: 'time ASC',
    );
    return List.generate(maps.length, (i) => Message.fromMap(maps[i]));
  }

  Future<int> deleteChat(int id) async {
    final db = await database;
    await db.delete('messages', where: 'chatId = ?', whereArgs: [id]);
    return await db.delete('chats', where: 'id = ?', whereArgs: [id]);
  }

  // Feedback operations
  Future<int> insertFeedback(Feedback feedback) async {
    final db = await database;

    // Make sure table exists
    await _createFeedbackTableIfNeeded(db);

    return await db.insert('feedback', feedback.toMap());
  }

  Future<List<Feedback>> getFeedbackByUserId(int userId) async {
    final db = await database;

    // Make sure table exists
    await _createFeedbackTableIfNeeded(db);

    final List<Map<String, dynamic>> maps = await db.query(
      'feedback',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) => Feedback.fromMap(maps[i]));
  }

  // Initialize feedback table
  Future<void> _createFeedbackTableIfNeeded(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS feedback(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        text TEXT,
        date TEXT,
        status TEXT,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
    print('Feedback table created or verified');
  }
}
