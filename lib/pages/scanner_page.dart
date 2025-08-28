import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:hugeicons/hugeicons.dart';

const String apiKey = "AIzaSyDYgxAqt5g6xvJkOomVCWDXhHo8DYYJ3M4";

const String apiUrl =
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

class ChatMessage {
  final String id;
  final String text;
  final bool isUserMessage;
  final MessageType type;
  final File? imageFile;
  final List<Map<String, dynamic>>? foodInfo;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUserMessage,
    this.type = MessageType.text,
    this.imageFile,
    this.foodInfo,
  });
}

enum MessageType { text, image, loading, error, foodInfo }

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  List<Map<String, dynamic>> _foodDatabase = [];

  @override
  void initState() {
    super.initState();

    if (apiKey == "ВАШЕ_API_КЛЮЧ" || apiKey.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Ошибка: API ключ Google AI не установлен или пуст! Проверьте код.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }

    // Add text controller listener for real-time UI updates
    _textController.addListener(() {
      setState(() {});
    });

    _loadFoodDatabase();
    _addBotMessage(
        "Здравствуйте! Я помогу вам узнать информацию о продуктах питания. Напишите название продукта или отправьте фотографию.",
        type: MessageType.text);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadFoodDatabase() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/food_database.json';
      final file = File(filePath);

      if (await file.exists()) {
        final String content = await file.readAsString();
        if (content.isNotEmpty) {
          final List<dynamic> decodedList = jsonDecode(content);
          _foodDatabase = List<Map<String, dynamic>>.from(decodedList);
          print("Загружено ${_foodDatabase.length} продуктов из базы данных.");
        }
      } else {
        // Создаем базовую базу данных если она не существует
        _foodDatabase = [
          {
            "name": "Яблоко",
            "calories": 52,
            "proteins": 0.3,
            "fats": 0.4,
            "carbs": 14,
            "vitamins": ["C", "A", "E", "K"],
            "benefits": "Улучшает пищеварение, богато антиоксидантами",
            "storage": "В прохладном месте до 3 недель",
            "daily_norm": "1-2 штуки в день",
            "image_path": "",
            "tags": ["фрукт", "яблоко", "свежий", "антиоксиданты", "клетчатка"]
          },
          {
            "name": "Банан",
            "calories": 89,
            "proteins": 1.1,
            "fats": 0.3,
            "carbs": 22.8,
            "vitamins": ["B6", "C", "калий", "магний"],
            "benefits": "Источник энергии, улучшает настроение",
            "storage": "При комнатной температуре 3-5 дней",
            "daily_norm": "1-2 штуки в день",
            "image_path": "",
            "tags": ["фрукт", "банан", "калий", "энергия", "углеводы"]
          },
          {
            "name": "Морковь",
            "calories": 41,
            "proteins": 0.9,
            "fats": 0.2,
            "carbs": 9.6,
            "vitamins": ["A", "K", "бета-каротин", "B6"],
            "benefits": "Улучшает зрение, укрепляет иммунитет",
            "storage": "В холодильнике до 3 недель",
            "daily_norm": "1 средняя морковь в день",
            "image_path": "",
            "tags": ["овощ", "морковь", "бета-каротин", "зрение", "витамин А"]
          }
        ];
        await file.writeAsString(jsonEncode(_foodDatabase));
        print(
            "Создана базовая база данных с ${_foodDatabase.length} продуктами.");
      }
    } catch (e) {
      print("Ошибка загрузки базы данных продуктов: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки базы данных продуктов: $e')),
        );
      }
    }
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.insert(0, message);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addBotMessage(String text,
      {MessageType type = MessageType.text,
      List<Map<String, dynamic>>? foodInfo}) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _addMessage(ChatMessage(
      id: id,
      text: text,
      isUserMessage: false,
      type: type,
      foodInfo: foodInfo,
    ));
  }

  void _addUserMessage(String text, {File? imageFile}) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _addMessage(ChatMessage(
      id: id,
      text: text,
      isUserMessage: true,
      type: imageFile != null ? MessageType.image : MessageType.text,
      imageFile: imageFile,
    ));
  }

  void _showLoading(bool loading) {
    setState(() {
      _isLoading = loading;
      _messages.removeWhere((msg) => msg.type == MessageType.loading);
      if (loading) {
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        _messages.insert(
            0,
            ChatMessage(
                id: id,
                text: "...",
                isUserMessage: false,
                type: MessageType.loading));
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
    });
  }

  Future<String?> _sendToGeminiApi(Map<String, dynamic> requestBody) async {
    if (apiKey == "ВАШЕ_API_КЛЮЧ" || apiKey.isEmpty) {
      throw Exception("API кілті жоқ немесе бос.");
    }

    final fullUrl = Uri.parse('$apiUrl?key=$apiKey');

    try {
      final response = await http.post(
        fullUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse['candidates'] != null &&
            decodedResponse['candidates'].isNotEmpty &&
            decodedResponse['candidates'][0]['content'] != null &&
            decodedResponse['candidates'][0]['content']['parts'] != null &&
            decodedResponse['candidates'][0]['content']['parts'].isNotEmpty &&
            decodedResponse['candidates'][0]['content']['parts'][0]['text'] !=
                null) {
          return decodedResponse['candidates'][0]['content']['parts'][0]
              ['text'];
        } else {
          print("API жауап құрылымы күткендей емес: ${response.body}");
          throw Exception("API жауабынан мәтінді алу мүмкін болмады.");
        }
      } else {
        print("API қатесі (${response.statusCode}): ${response.body}");
        throw Exception("API қатесі: ${response.statusCode}. ${response.body}");
      }
    } catch (e) {
      print("HTTP сұрау қатесі: $e");
      rethrow;
    }
  }

  Future<void> _handleTextMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    _addUserMessage(text);
    _textController.clear();
    _showLoading(true);

    try {
      final prompt = '''
          Пользователь ищет информацию о продукте питания. Определи из его запроса основные характеристики и теги.
          Например: название продукта, калории, способ хранения, польза, вред, содержащиеся витамины, суточная норма потребления.
          Верни ответ только в виде тегов, разделенных запятой.
          Запрос: "$text"
          Теги:''';

      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      };

      final String? responseText = await _sendToGeminiApi(requestBody);

      if (responseText == null) {
        throw Exception("API жауабы бос келді.");
      }

      final extractedTags = responseText
          .split(',')
          .map((tag) => tag.trim().toLowerCase())
          .where((tag) => tag.isNotEmpty)
          .toList();

      print("Анықталған тегтер: $extractedTags");

      if (extractedTags.isEmpty) {
        _addBotMessage(
            "Извините, не могу определить конкретные характеристики из вашего запроса. Попробуйте описать иначе.");
      } else {
        final foodInfoPrompt = '''
          Предоставь информацию о продукте питания: $text
          Включи следующие данные (если информация неизвестна, напиши "нет данных"):
          1. Название: полное название продукта
          2. Калорийность: калории на 100г
          3. БЖУ: белки, жиры, углеводы на 100г
          4. Витамины и минералы: основные витамины и минералы в продукте
          5. Польза: полезные свойства продукта
          6. Хранение: как правильно хранить
          7. Суточная норма: рекомендуемое количество в день
          
          Ответ должен быть информативным, но кратким.
        ''';

        final foodInfoRequestBody = {
          "contents": [
            {
              "parts": [
                {"text": foodInfoPrompt}
              ]
            }
          ]
        };

        final String? foodInfoResponse =
            await _sendToGeminiApi(foodInfoRequestBody);

        if (foodInfoResponse == null) {
          throw Exception("Не удалось получить информацию о продукте.");
        }

        Map<String, dynamic> foodInfo =
            _parseFoodInfo(foodInfoResponse, extractedTags);

        // Поиск в базе данных
        final matchedFoods = _searchFoodByTags(extractedTags);

        _addBotMessage(foodInfoResponse,
            type: MessageType.foodInfo,
            foodInfo: matchedFoods.isNotEmpty ? matchedFoods : [foodInfo]);
      }
    } catch (e) {
      print("Ошибка текстового запроса: $e");
      _addBotMessage("Извините, произошла ошибка при обработке вашего запроса.",
          type: MessageType.error);
    } finally {
      _showLoading(false);
    }
  }

  Map<String, dynamic> _parseFoodInfo(String response, List<String> tags) {
    Map<String, dynamic> result = {
      "name": "Неизвестный продукт",
      "calories": 0,
      "proteins": 0,
      "fats": 0,
      "carbs": 0,
      "vitamins": [],
      "benefits": "Нет данных",
      "storage": "Нет данных",
      "daily_norm": "Нет данных",
      "tags": tags
    };

    // Попытка извлечь название
    final nameMatch =
        RegExp(r'(?:Название|1\.|Продукт):\s*([^\n]+)', caseSensitive: false)
            .firstMatch(response);
    if (nameMatch != null) result["name"] = nameMatch.group(1)!.trim();

    // Попытка извлечь калории
    final caloriesMatch =
        RegExp(r'(?:Калорийность|2\.|калории):\s*(\d+)', caseSensitive: false)
            .firstMatch(response);
    if (caloriesMatch != null) {
      result["calories"] = int.tryParse(caloriesMatch.group(1)!) ?? 0;
    }

    // Попытка извлечь БЖУ
    final bjuMatch = RegExp(
            r'(?:БЖУ|3\.|Белки,\s*жиры,\s*углеводы):\s*([^\n]+)',
            caseSensitive: false)
        .firstMatch(response);
    if (bjuMatch != null) {
      final bjuText = bjuMatch.group(1)!;
      final proteinsMatch =
          RegExp(r'белки[^0-9]*(\d+(?:[,.]\d+)?)', caseSensitive: false)
              .firstMatch(bjuText);
      final fatsMatch =
          RegExp(r'жиры[^0-9]*(\d+(?:[,.]\d+)?)', caseSensitive: false)
              .firstMatch(bjuText);
      final carbsMatch =
          RegExp(r'углеводы[^0-9]*(\d+(?:[,.]\d+)?)', caseSensitive: false)
              .firstMatch(bjuText);

      if (proteinsMatch != null) {
        result["proteins"] =
            double.tryParse(proteinsMatch.group(1)!.replaceAll(',', '.')) ?? 0;
      }
      if (fatsMatch != null) {
        result["fats"] =
            double.tryParse(fatsMatch.group(1)!.replaceAll(',', '.')) ?? 0;
      }
      if (carbsMatch != null) {
        result["carbs"] =
            double.tryParse(carbsMatch.group(1)!.replaceAll(',', '.')) ?? 0;
      }
    }

    // Попытка извлечь витамины
    final vitaminsMatch = RegExp(
            r'(?:Витамины|4\.|Витамины и минералы):\s*([^\n]+)',
            caseSensitive: false)
        .firstMatch(response);
    if (vitaminsMatch != null) {
      final vitaminsText = vitaminsMatch.group(1)!.trim();
      if (!vitaminsText.contains("нет данных")) {
        result["vitamins"] = vitaminsText
            .split(',')
            .map((vitamin) => vitamin.trim())
            .where((vitamin) => vitamin.isNotEmpty)
            .toList();
      }
    }

    // Попытка извлечь пользу
    final benefitsMatch =
        RegExp(r'(?:Польза|5\.):\s*([^\n]+)', caseSensitive: false)
            .firstMatch(response);
    if (benefitsMatch != null)
      result["benefits"] = benefitsMatch.group(1)!.trim();

    // Попытка извлечь хранение
    final storageMatch =
        RegExp(r'(?:Хранение|6\.):\s*([^\n]+)', caseSensitive: false)
            .firstMatch(response);
    if (storageMatch != null) result["storage"] = storageMatch.group(1)!.trim();

    // Попытка извлечь суточную норму
    final normMatch =
        RegExp(r'(?:Суточная норма|7\.):\s*([^\n]+)', caseSensitive: false)
            .firstMatch(response);
    if (normMatch != null) result["daily_norm"] = normMatch.group(1)!.trim();

    return result;
  }

  Future<void> _handleImageMessage(File imageFile) async {
    _addUserMessage("Фото продукта", imageFile: imageFile);
    _showLoading(true);

    try {
      final imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      final promptText = '''
            Это фотография продукта питания. Определи, что это за продукт, и напиши его название на РУССКОМ.
            Также дай краткую информацию о нем (на РУССКОМ).
            В конце укажи основные теги для этого продукта, разделенные запятыми (например: фрукт, яблоко, свежий).
            Дай ответ в следующем формате:
            Название: [Русское название продукта]
            Информация: [Краткая информация на русском]
            Теги: [теги, разделенные запятыми]
            ''';

      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": promptText},
              {
                "inlineData": {"mimeType": "image/jpeg", "data": base64Image}
              }
            ]
          }
        ]
      };

      final String? responseText = await _sendToGeminiApi(requestBody);

      if (responseText == null) {
        throw Exception("API жауабы бос келді.");
      }

      String name = "Не определено";
      String description = "Нет информации";
      List<String> extractedTags = [];

      final nameMatch = RegExp(r'Название:\s*(.*)', caseSensitive: false)
          .firstMatch(responseText);
      if (nameMatch != null) name = nameMatch.group(1)!.trim();

      final descMatch = RegExp(r'Информация:\s*(.*)', caseSensitive: false)
          .firstMatch(responseText);
      if (descMatch != null) description = descMatch.group(1)!.trim();

      final tagsMatch = RegExp(r'Теги:\s*(.*)', caseSensitive: false)
          .firstMatch(responseText);
      if (tagsMatch != null) {
        extractedTags = tagsMatch
            .group(1)!
            .split(',')
            .map((tag) => tag.trim().toLowerCase())
            .where((tag) => tag.isNotEmpty)
            .toList();
      }

      print("Определено по фото: Название=$name, Теги=$extractedTags");

      _addBotMessage(
          "Определено по фото:\n\nНазвание: $name\nИнформация: $description");

      if (extractedTags.isEmpty) {
        _addBotMessage(
            "К сожалению, не удалось определить точные характеристики продукта.");
      } else {
        // Получаем детальную информацию о продукте
        final foodInfoPrompt = '''
          Предоставь полную информацию о продукте питания: $name
          Включи следующие данные (если информация неизвестна, напиши "нет данных"):
          1. Калорийность: калории на 100г
          2. БЖУ: белки, жиры, углеводы на 100г
          3. Витамины и минералы: основные витамины и минералы
          4. Польза: полезные свойства продукта
          5. Хранение: как правильно хранить
          6. Суточная норма: рекомендуемое количество в день
          
          Ответ должен быть информативным, но кратким.
        ''';

        final foodInfoRequestBody = {
          "contents": [
            {
              "parts": [
                {"text": foodInfoPrompt}
              ]
            }
          ]
        };

        final String? foodInfoResponse =
            await _sendToGeminiApi(foodInfoRequestBody);

        if (foodInfoResponse != null) {
          final results = _searchFoodByTags(extractedTags);

          // Создаем информацию о продукте на основе результата API
          Map<String, dynamic> parsedFoodInfo =
              _parseFoodInfo(foodInfoResponse, extractedTags);
          parsedFoodInfo["name"] = name;

          _addBotMessage(foodInfoResponse,
              type: MessageType.foodInfo,
              foodInfo: results.isNotEmpty ? results : [parsedFoodInfo]);
        } else {
          _addBotMessage(
              "К сожалению, не удалось получить детальную информацию о продукте.");
        }
      }
    } catch (e) {
      print("Ошибка обработки изображения: $e");
      _addBotMessage("Извините, произошла ошибка при обработке изображения.",
          type: MessageType.error);
    } finally {
      _showLoading(false);
    }
  }

  List<Map<String, dynamic>> _searchFoodByTags(List<String> searchTags) {
    if (searchTags.isEmpty || _foodDatabase.isEmpty) {
      return [];
    }
    final List<Map<String, dynamic>> matchedFoods = [];
    final searchTagsLower = searchTags.map((t) => t.toLowerCase()).toSet();

    for (final food in _foodDatabase) {
      final foodTags = food['tags'];
      bool match = false;

      // Проверяем совпадение по названию продукта
      if (food['name'] != null) {
        final String foodName = food['name'].toString().toLowerCase();
        for (final tag in searchTagsLower) {
          if (foodName.contains(tag)) {
            match = true;
            break;
          }
        }
      }

      // Проверяем совпадение по тегам
      if (!match && foodTags is List) {
        final foodTagsLower =
            foodTags.map((t) => t.toString().toLowerCase()).toSet();
        if (foodTagsLower.intersection(searchTagsLower).isNotEmpty) {
          match = true;
        }
      }

      if (match) {
        matchedFoods.add(food);
      }
    }

    print(
        "Результат поиска ($searchTags): найдено ${matchedFoods.length} продуктов.");
    return matchedFoods;
  }

  Future<void> _pickAndSendImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        _handleImageMessage(File(pickedFile.path));
      }
    } catch (e) {
      print("Ошибка выбора изображения: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при выборе изображения: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (apiKey == "ВАШЕ_API_КЛЮЧ" || apiKey.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
            ),
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'API ключ не настроен',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Проверьте настройки Google AI API',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Modern App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(HugeIcons.strokeRoundedArrowLeft01,
                        color: Color(0xFF666666)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 5),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Сканер',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        Text(
                          'Анализ питательности продуктов',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Color(0xFF666666)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Chat Messages Area
            Expanded(
              child: _messages.isEmpty
                  ? _buildEmptyState()
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return AnimatedContainer(
                            duration:
                                Duration(milliseconds: 300 + (index * 50)),
                            curve: Curves.easeOutBack,
                            child: _buildModernChatMessage(message),
                          );
                        },
                      ),
                    ),
            ),

            // Modern Input Area
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Image Picker Button
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _isLoading ? null : _pickAndSendImage,
                          child: Container(
                            width: 48,
                            height: 48,
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Text Input Field
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _textController,
                          enabled: !_isLoading,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF333333),
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Введите название продукта...',
                            hintStyle: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                          ),
                          textInputAction: TextInputAction.send,
                          onSubmitted: _isLoading
                              ? null
                              : (value) => _handleTextMessage(value),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Send Button
                    Container(
                      decoration: BoxDecoration(
                        gradient: _textController.text.trim().isNotEmpty &&
                                !_isLoading
                            ? const LinearGradient(
                                colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                              )
                            : null,
                        color: _textController.text.trim().isEmpty || _isLoading
                            ? Colors.grey[300]
                            : null,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _isLoading ||
                                  _textController.text.trim().isEmpty
                              ? null
                              : () => _handleTextMessage(_textController.text),
                          child: Container(
                            width: 48,
                            height: 48,
                            child: Icon(
                              Icons.send_rounded,
                              color: _textController.text.trim().isNotEmpty &&
                                      !_isLoading
                                  ? Colors.white
                                  : Colors.grey[500],
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Empty state widget for when there are no messages
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
              ),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.eco,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Добро пожаловать!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Отправьте фото продукта или введите его название\nдля получения информации о питательности',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildQuickActionButton(
                icon: Icons.camera_alt_rounded,
                label: 'Сканировать',
                onTap: _pickAndSendImage,
              ),
              const SizedBox(width: 16),
              _buildQuickActionButton(
                icon: Icons.edit_rounded,
                label: 'Написать',
                onTap: () {
                  // Focus on text field
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF4CAF50),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4CAF50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern chat message widget
  Widget _buildModernChatMessage(ChatMessage message) {
    if (message.type == MessageType.loading) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.eco,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Анализирую...',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (message.type == MessageType.foodInfo) {
      return _buildModernFoodInfoWidget(message.text, message.foodInfo);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isUserMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUserMessage) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.eco,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: message.isUserMessage
                    ? const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                      )
                    : null,
                color: message.isUserMessage
                    ? null
                    : (message.type == MessageType.error
                        ? const Color(0xFFFFEBEE)
                        : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: message.isUserMessage
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: message.isUserMessage
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
                border: message.type == MessageType.error
                    ? Border.all(color: Colors.red.withOpacity(0.3))
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.type == MessageType.image &&
                      message.imageFile != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          message.imageFile!,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  SelectableText(
                    message.text,
                    style: TextStyle(
                      color: message.isUserMessage
                          ? Colors.white
                          : (message.type == MessageType.error
                              ? Colors.red[700]
                              : const Color(0xFF333333)),
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUserMessage) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.person,
                color: Colors.grey[600],
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChatMessageWidget(ChatMessage message) {
    if (message.type == MessageType.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Center(
            child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }
    if (message.type == MessageType.foodInfo) {
      return _buildFoodInfoWidget(message.text, message.foodInfo);
    }
    return Align(
      alignment:
          message.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        decoration: BoxDecoration(
          color: message.isUserMessage
              ? Colors.green[700]
              : (message.type == MessageType.error
                  ? Colors.red.shade100
                  : Colors.grey[300]),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
            bottomLeft: message.isUserMessage
                ? const Radius.circular(16.0)
                : Radius.zero,
            bottomRight: message.isUserMessage
                ? Radius.zero
                : const Radius.circular(16.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: message.isUserMessage
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (message.type == MessageType.image && message.imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  message.imageFile!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            if (message.type == MessageType.image) const SizedBox(height: 5),
            SelectableText(
              message.text,
              style: TextStyle(
                color: message.isUserMessage
                    ? Colors.white
                    : (message.type == MessageType.error
                        ? Colors.red.shade900
                        : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern food info widget
  Widget _buildModernFoodInfoWidget(
      String mainText, List<Map<String, dynamic>>? foodInfoList) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.eco,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border.all(
                  color: const Color(0xFF4CAF50).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.restaurant_menu_rounded,
                          color: Color(0xFF4CAF50),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Информация о продукте',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Main text
                  SelectableText(
                    mainText,
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),

                  if (foodInfoList != null && foodInfoList.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFE0E0E0)),
                    const SizedBox(height: 16),

                    // Food info cards
                    ...foodInfoList
                        .map((food) => _buildModernFoodCard(food))
                        .toList(),
                  ] else ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Дополнительная информация недоступна',
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFoodCard(Map<String, dynamic> food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4CAF50).withOpacity(0.05),
            const Color(0xFF2E7D32).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food name
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  food['name'] ?? "Неизвестный продукт",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Nutrition info grid
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildNutritionItem(
                      'Калории',
                      '${food['calories'] ?? 'Н/Д'}',
                      'ккал',
                      Icons.local_fire_department_rounded,
                      Colors.orange,
                    ),
                    const SizedBox(width: 12),
                    _buildNutritionItem(
                      'Белки',
                      '${food['proteins'] ?? 'Н/Д'}',
                      'г',
                      Icons.fitness_center_rounded,
                      Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildNutritionItem(
                      'Жиры',
                      '${food['fats'] ?? 'Н/Д'}',
                      'г',
                      Icons.opacity_rounded,
                      Colors.purple,
                    ),
                    const SizedBox(width: 12),
                    _buildNutritionItem(
                      'Углеводы',
                      '${food['carbs'] ?? 'Н/Д'}',
                      'г',
                      Icons.grain_rounded,
                      Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Additional info
          _buildModernInfoRow(
              'Витамины',
              (food['vitamins'] is List)
                  ? food['vitamins'].join(', ')
                  : "Нет данных",
              Icons.medical_services_rounded),
          _buildModernInfoRow('Польза', food['benefits'] ?? "Нет данных",
              Icons.favorite_rounded),
          _buildModernInfoRow('Хранение', food['storage'] ?? "Нет данных",
              Icons.storage_rounded),
          _buildModernInfoRow('Суточная норма',
              food['daily_norm'] ?? "Нет данных", Icons.schedule_rounded),

          // Tags
          if (food['tags'] is List && food['tags'].isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (food['tags'] as List).map<Widget>((tag) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutritionItem(
      String label, String value, String unit, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF4CAF50),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodInfoWidget(
      String mainText, List<Map<String, dynamic>>? foodInfoList) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.green.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            mainText,
            style: const TextStyle(color: Colors.black87),
          ),
          const Divider(height: 15),
          if (foodInfoList == null || foodInfoList.isEmpty)
            const Text("Информация о продукте не найдена.",
                style: TextStyle(fontStyle: FontStyle.italic))
          else
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: foodInfoList.length,
                itemBuilder: (context, index) {
                  final food = foodInfoList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.green.shade200, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food['name'] ?? "Неизвестный продукт",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow("Калорийность",
                              "${food['calories'] ?? 'Н/Д'} ккал на 100г"),
                          _buildInfoRow(
                              "Белки", "${food['proteins'] ?? 'Н/Д'} г"),
                          _buildInfoRow("Жиры", "${food['fats'] ?? 'Н/Д'} г"),
                          _buildInfoRow(
                              "Углеводы", "${food['carbs'] ?? 'Н/Д'} г"),
                          _buildInfoRow(
                              "Витамины",
                              (food['vitamins'] is List)
                                  ? food['vitamins'].join(', ')
                                  : "Нет данных"),
                          _buildInfoRow(
                              "Польза", food['benefits'] ?? "Нет данных"),
                          _buildInfoRow(
                              "Хранение", food['storage'] ?? "Нет данных"),
                          _buildInfoRow("Суточная норма",
                              food['daily_norm'] ?? "Нет данных"),
                          if (food['tags'] is List && food['tags'].isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children:
                                    (food['tags'] as List).map<Widget>((tag) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.green.withOpacity(0.3)),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green[800]),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
} // _ChatScreenState соңы