import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  final int? id;
  final String phone;
  final String password;
  final String name;
  final String? avatarUrl;
  final int points;
  final int bonuses;
  final DateTime? joinDate;

  User({
    this.id,
    required this.phone,
    required this.password,
    required this.name,
    this.avatarUrl,
    this.points = 0,
    this.bonuses = 0,
    this.joinDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'password': password,
      'name': name,
      'avatarUrl': avatarUrl,
      'points': points,
      'bonuses': bonuses,
      'joinDate': joinDate?.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      name: map['name'] ?? 'User',
      avatarUrl: map['avatarUrl'],
      points: map['points'] ?? 0,
      bonuses: map['bonuses'] ?? 0,
      joinDate: map['joinDate'] != null ? DateTime.parse(map['joinDate']) : null,
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

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  Database? _db;
  static const int _databaseVersion = 3;

  // Reset database (for development/testing)
  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'qamqor.db');
    await deleteDatabase(path);
    _db = null;
    print('Database reset complete');
  }

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
              phone TEXT UNIQUE,
              password TEXT,
              name TEXT,
              avatarUrl TEXT,
              points INTEGER DEFAULT 0,
              bonuses INTEGER DEFAULT 0,
              joinDate TEXT
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

          print('Database tables created successfully');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          print('Upgrading database from version $oldVersion to $newVersion');
          
          if (oldVersion < 2) {
            // Check if phone column exists
            final columns = await db.rawQuery('PRAGMA table_info(users)');
            final hasPhoneColumn = columns.any((column) => column['name'] == 'phone');
            
            if (!hasPhoneColumn) {
              print('Adding phone column to users table');
              
              // Create new table with phone column
              await db.execute('''
                CREATE TABLE IF NOT EXISTS users_new(
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  phone TEXT UNIQUE,
                  password TEXT,
                  name TEXT,
                  avatarUrl TEXT,
                  points INTEGER DEFAULT 0,
                  bonuses INTEGER DEFAULT 0,
                  joinDate TEXT
                )
              ''');
              
              // Copy data from old table to new table
              final users = await db.rawQuery('SELECT * FROM users');
              for (final user in users) {
                await db.insert('users_new', {
                  'id': user['id'],
                  'phone': user['email'] ?? '',
                  'password': user['password'],
                  'name': user['name'],
                  'avatarUrl': user['avatarUrl'],
                  'points': 100,
                  'bonuses': 0,
                  'joinDate': DateTime.now().toIso8601String(),
                });
              }
              
              // Drop old table and rename new table
              await db.execute('DROP TABLE users');
              await db.execute('ALTER TABLE users_new RENAME TO users');
              
              print('Database migration completed successfully');
            }
          }
          
          if (oldVersion < 3) {
            // Add points, bonuses, and joinDate columns if they don't exist
            final columns = await db.rawQuery('PRAGMA table_info(users)');
            final hasPointsColumn = columns.any((column) => column['name'] == 'points');
            final hasBonusesColumn = columns.any((column) => column['name'] == 'bonuses');
            final hasJoinDateColumn = columns.any((column) => column['name'] == 'joinDate');
            
            if (!hasPointsColumn) {
              await db.execute('ALTER TABLE users ADD COLUMN points INTEGER DEFAULT 0');
              await db.execute('UPDATE users SET points = 100 WHERE points = 0');
            }
            
            if (!hasBonusesColumn) {
              await db.execute('ALTER TABLE users ADD COLUMN bonuses INTEGER DEFAULT 0');
            }
            
            if (!hasJoinDateColumn) {
              await db.execute('ALTER TABLE users ADD COLUMN joinDate TEXT');
              await db.execute('UPDATE users SET joinDate = ? WHERE joinDate IS NULL', 
                  [DateTime.now().toIso8601String()]);
            }
            
            print('Points and bonuses columns added successfully');
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
    try {
      final db = await database;
      return await db.insert('users', user.toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort);
    } catch (e) {
      print('Error inserting user: $e');
      rethrow;
    }
  }

  Future<User?> getUserByPhone(String phone) async {
    try {
      final db = await database;
      final maps = await db.query('users', where: 'phone = ?', whereArgs: [phone]);
      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error in getUserByPhone: $e');
      return null;
    }
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
      where: 'name LIKE ? OR phone LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  // Update user points and bonuses
  Future<void> updateUserPoints(int userId, int points) async {
    final db = await database;
    await db.update(
      'users',
      {'points': points},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> updateUserBonuses(int userId, int bonuses) async {
    final db = await database;
    await db.update(
      'users',
      {'bonuses': bonuses},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> addPointsToUser(int userId, int pointsToAdd) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE users SET points = points + ? WHERE id = ?',
      [pointsToAdd, userId],
    );
  }

  Future<void> addBonusesToUser(int userId, int bonusesToAdd) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE users SET bonuses = bonuses + ? WHERE id = ?',
      [bonusesToAdd, userId],
    );
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
      final chats = await db.rawQuery('''
        SELECT 
          c.id,
          c.userId,
          c.lastMessage,
          c.lastMessageTime,
          c.unreadCount,
          u.phone
        FROM chats c 
        INNER JOIN users u ON c.userId = u.id 
        ORDER BY c.lastMessageTime DESC
      ''');

      print('Retrieved chats: ${chats.length}');
      return chats;
    } catch (e) {
      print('Error getting chats: $e');
      return [];
    }
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

  Future<void> updateChatLastMessage(int chatId, String message) async {
    final db = await database;
    await db.update(
      'chats',
      {
        'lastMessage': message,
        'lastMessageTime': DateTime.now().toString(),
      },
      where: 'id = ?',
      whereArgs: [chatId],
    );
  }
}
