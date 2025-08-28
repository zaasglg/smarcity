import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatAIPage extends StatefulWidget {
  const ChatAIPage({super.key});

  @override
  State<ChatAIPage> createState() => _ChatAIPageState();
}

class _ChatAIPageState extends State<ChatAIPage> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String _loadingMessage = '';
  // TODO: Replace with your own OpenAI API key
  static const String _apiKey = 'YOUR_OPENAI_API_KEY';
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  @override
  void initState() {
    super.initState();
    // Initialize chat with welcome message
    _messages.add({
      'text': 'Привет! Я ваш AI ассистент. Чем могу помочь?',
      'isUser': false,
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Чат',
          style: TextStyle(
            color: Color(0xFF0A1837),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0A1837)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isLoading) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _loadingMessage,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final message = _messages[index];
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: 1.0,
                    child: Align(
                      alignment: message['isUser']
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: message['isUser']
                              ? const Color(0xFF6F86FF)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(
                            color: message['isUser']
                                ? Colors.white
                                : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Input field
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Введите сообщение...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      onSubmitted: (text) {
                        if (text.trim().isNotEmpty) {
                          _sendMessage(text);
                          _messageController.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isLoading ? Colors.grey : const Color(0xFF6F86FF),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isLoading ? Icons.hourglass_empty : Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: _isLoading
                          ? null
                          : () {
                              final text = _messageController.text;
                              if (text.trim().isNotEmpty) {
                                _sendMessage(text);
                                _messageController.clear();
                              }
                            },
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

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
