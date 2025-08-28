import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'chat_ai_page.dart';

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({super.key});

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  final List<Map<String, dynamic>> _messages = [];
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _recognizedText = '';
  String _statusText = 'Инициализация...';
  bool _speechEnabled = false;
  bool _isInitializing = true;
  int _retryCount = 0;
  static const int maxRetries = 3;
  bool _showTips = false;
  bool _hasPermission = false;

  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  // TODO: Replace with your own OpenAI API key
  static const String _apiKey = 'YOUR_OPENAI_API_KEY';
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  String _typingText = '';
  String _loadingMessage = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Initialize chat with welcome message
    _messages.add({
      'text': 'Привет! Я ваш AI ассистент. Чем могу помочь?',
      'isUser': false,
    });

    // Delay initialization to ensure platform channels are ready
    Timer(const Duration(milliseconds: 1000), () {
      _initSpeech();
    });
  }

  Future<void> _initSpeech() async {
    if (!mounted) return;

    setState(() {
      _isInitializing = true;
      _statusText = 'Инициализация распознавания речи...';
    });

    try {
      _speechEnabled = await _speech.initialize(
        onStatus: (status) {
          print('Speech status: $status');
          if (status == 'done') {
            if (mounted) {
              setState(() {
                _isListening = false;
                _statusText = 'Распознавание завершено';
                _showTips = false;
              });
              _animationController.stop();
            }
          } else if (status == 'notListening' && _isListening) {
            // Handle unexpected stop
            if (mounted) {
              setState(() {
                _isListening = false;
                _statusText = 'Распознавание прервано';
                _showTips = false;
              });
              _animationController.stop();
            }
          }
        },
        onError: (error) {
          print('Speech error: $error');
          if (mounted) {
            setState(() {
              _isListening = false;
              _statusText = _getErrorMessage(error);
              if (error.errorMsg == 'error_no_match') {
                _showTips = true;
              } else if (error.errorMsg == 'error_listen_failed') {
                _hasPermission = false;
                _showPermissionRequest();
              }
            });
            _animationController.stop();
          }
        },
      );

      if (!mounted) return;

      // Check if we have permission
      _hasPermission = await _speech.hasPermission;

      setState(() {
        _isInitializing = false;
        if (_speechEnabled && _hasPermission) {
          _statusText = 'Нажмите на микрофон, чтобы начать';
        } else if (!_hasPermission) {
          _statusText = 'Требуется доступ к микрофону';
          _showPermissionRequest();
        } else {
          _statusText = 'Распознавание речи недоступно';
        }
      });
    } catch (e) {
      print('Error initializing speech: $e');
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _statusText = 'Ошибка инициализации распознавания речи';
        });
      }
    }
  }

  void _showPermissionRequest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Доступ к микрофону'),
        content: const Text(
          'Для работы голосового помощника необходим доступ к микрофону. '
          'Пожалуйста, предоставьте разрешение в настройках приложения.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initSpeech(); // Retry initialization
            },
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(SpeechRecognitionError error) {
    switch (error.errorMsg) {
      case 'error_listen_failed':
        return 'Ошибка доступа к микрофону. Проверьте разрешения в настройках.';
      case 'error_no_match':
        return 'Не удалось распознать речь. Попробуйте говорить четче и громче.';
      case 'error_network':
        return 'Ошибка сети. Проверьте подключение.';
      case 'error_network_timeout':
        return 'Таймаут сети. Проверьте подключение.';
      case 'error_audio':
        return 'Ошибка аудио. Проверьте микрофон.';
      case 'error_client':
        return 'Ошибка клиента. Перезапустите приложение.';
      case 'error_permission_denied':
        return 'Нет доступа к микрофону. Проверьте настройки.';
      case 'error_speech_timeout':
        return 'Время ожидания речи истекло.';
      default:
        return 'Произошла ошибка: ${error.errorMsg}';
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_isInitializing) {
      setState(() {
        _statusText = 'Пожалуйста, подождите...';
      });
      return;
    }

    if (!_hasPermission) {
      _showPermissionRequest();
      return;
    }

    if (!_speechEnabled) {
      if (_retryCount < maxRetries) {
        _retryCount++;
        setState(() {
          _statusText = 'Повторная попытка инициализации...';
        });
        await _initSpeech();
        return;
      } else {
        setState(() {
          _statusText = 'Распознавание речи недоступно';
        });
        return;
      }
    }

    if (!_isListening) {
      try {
        setState(() {
          _isListening = true;
          _statusText = 'Слушаю вас...';
          _recognizedText = '';
          _showTips = false;
        });
        _animationController.repeat(reverse: true);

        final available = await _speech.initialize();
        if (!available) {
          throw Exception('Speech recognition not available');
        }

        await _speech.listen(
          onResult: (result) {
            if (mounted) {
              setState(() {
                _recognizedText = result.recognizedWords;
                if (result.recognizedWords.isNotEmpty) {
                  _showTips = false;
                }
              });
            }
          },
          localeId: 'ru_RU',
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
          cancelOnError: true,
          partialResults: true,
        );
      } catch (e) {
        print('Error starting speech recognition: $e');
        if (mounted) {
          setState(() {
            _isListening = false;
            _statusText = 'Ошибка при запуске распознавания';
          });
          _animationController.stop();
        }
      }
    } else {
      try {
        setState(() {
          _isListening = false;
          _statusText = 'Обрабатываю ваш запрос...';
        });
        _animationController.stop();
        await _speech.stop();

        if (_recognizedText.isNotEmpty) {
          // Add user message
          _messages.add({
            'text': _recognizedText,
            'isUser': true,
          });

          // Send to ChatGPT
          try {
            final response = await http.post(
              Uri.parse('https://api.openai.com/v1/chat/completions'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $_apiKey',
              },
              body: jsonEncode({
                'model': 'gpt-4o-mini',
                'messages': [
                  {
                    'role': 'system',
                    'content':
                        'Ты - полезный голосовой ассистент, который отвечает на русском языке. Отвечай кратко и по существу.'
                  },
                  ..._messages
                      .map((msg) => {
                            'role': msg['isUser'] ? 'user' : 'assistant',
                            'content': msg['text'],
                          })
                      .toList(),
                ],
                'temperature': 0.7,
              }),
            );

            if (response.statusCode == 200) {
              final data = jsonDecode(response.body);
              final aiResponse = data['choices'][0]['message']['content'];

              setState(() {
                _messages.add({
                  'text': aiResponse,
                  'isUser': false,
                });
                _statusText = 'Нажмите на микрофон, чтобы начать';
              });
            } else {
              throw Exception('Failed to get response from ChatGPT');
            }
          } catch (e) {
            print('Error getting ChatGPT response: $e');
            setState(() {
              _messages.add({
                'text':
                    'Извините, произошла ошибка при обработке вашего запроса.',
                'isUser': false,
              });
              _statusText = 'Нажмите на микрофон, чтобы начать';
            });
          }
        }
      } catch (e) {
        print('Error stopping speech recognition: $e');
        if (mounted) {
          setState(() {
            _statusText = 'Ошибка при остановке распознавания';
          });
        }
      }
    }
  }

  Widget _buildAssistantAvatar() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFB8B5FF),
                  Color(0xFF6F86FF),
                  Color(0xFFB8F2FF)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB8B5FF).withOpacity(0.4),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'AI Помощник',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionsRu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: [
          _quickActionButton(Icons.image, 'Создать изображение'),
          _quickActionButton(Icons.lightbulb_outline, 'Дать идею'),
          _quickActionButton(Icons.task_alt, 'Выполнить задачу'),
          _quickActionButton(Icons.translate, 'Перевести текст'),
        ],
      ),
    );
  }

  Widget _quickActionButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.deepPurpleAccent, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6F86FF),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFieldRu() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'Спросите меня о чём угодно...',
                style: TextStyle(
                  color: Color(0xFF6F86FF),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB8B5FF), Color(0xFF6F86FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.mic, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Голосовой ассистент".toUpperCase(),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              // Аватар с волной
              Lottie.asset('assets/lotties/chat_ai.json', height: 250),
              const SizedBox(height: 24),
              // Статус
              if (_isInitializing)
                const CircularProgressIndicator()
              else
                Column(
                  children: [
                    Text(
                      _statusText,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (_showTips) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: const [
                            Text(
                              'Советы для лучшего распознавания:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '• Говорите четко и громко\n'
                              '• Убедитесь, что вокруг тихо\n'
                              '• Держите телефон ближе к рту\n'
                              '• Говорите на русском языке',
                              style: TextStyle(
                                color: Colors.blue,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              const SizedBox(height: 32),
              // Распознанный текст
              if (_recognizedText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    _recognizedText,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF0A1837),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const Spacer(),

              // Кнопки управления
              _buildBottomMicBar(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaveAvatar() {
    return Container(
      width: 160,
      height: 160,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF3F6FF),
        boxShadow: [
          BoxShadow(
            color: Color(0x110A1837),
            blurRadius: 24,
            spreadRadius: 2,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _WavePainter(),
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _buildBottomMicBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _circleIcon(HugeIcons.strokeRoundedComment01, () {
            // Navigate to chat page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatAIPage()),
            );
          }),
          const Spacer(),
          GestureDetector(
            onTap: _toggleListening,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isListening ? Colors.red : const Color(0xFF0A1837),
                boxShadow: [
                  BoxShadow(
                    color: (_isListening ? Colors.red : const Color(0xFF0A1837))
                        .withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _isListening ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          const Spacer(),
          _circleIcon(Icons.close, () {
            // Clear messages and reset state
            setState(() {
              _messages.clear();
              _recognizedText = '';
              _statusText = 'Нажмите на микрофон, чтобы начать';
            });
          }),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Color(0xFFF3F6FF),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF0A1837), size: 24),
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Immediately add user message
    setState(() {
      _messages.add({
        'text': message,
        'isUser': true,
      });
      _isLoading = true;
      _loadingMessage = 'AI думает...';
    });

    // Scroll to bottom after adding user message
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content':
                  'Ты - полезный ассистент, который отвечает на русском языке.'
            },
            ..._messages
                .map((msg) => {
                      'role': msg['isUser'] ? 'user' : 'assistant',
                      'content': msg['text'],
                    })
                .toList(),
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['choices'][0]['message']['content'];

        // Add AI response with a small delay for better UX
        await Future.delayed(const Duration(milliseconds: 500));

        setState(() {
          _messages.add({
            'text': aiResponse,
            'isUser': false,
          });
          _isLoading = false;
          _loadingMessage = '';
        });

        // Scroll to bottom after AI response
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      } else {
        throw Exception('Failed to get response from ChatGPT');
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'text': 'Извините, произошла ошибка при обработке вашего запроса.',
          'isUser': false,
        });
        _isLoading = false;
        _loadingMessage = '';
      });
      print('Error sending message: $e');
    }
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, size.height * 0.65);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.55,
        size.width * 0.5, size.height * 0.7);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.85, size.width, size.height * 0.7);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
