import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class VolunteeringPage extends StatefulWidget {
  const VolunteeringPage({super.key});

  @override
  State<VolunteeringPage> createState() => _VolunteeringPageState();
}

class _VolunteeringPageState extends State<VolunteeringPage> {
  final List<Map<String, dynamic>> _initiatives = [
    {
      'title': 'Субботник в парке',
      'desc': 'Уборка территории и посадка деревьев в городском парке.',
      'date': DateTime.now().add(const Duration(days: 2)),
      'participants': 12,
      'color': Color(0xFF4CAF50),
    },
    {
      'title': 'Помощь приюту для животных',
      'desc': 'Сбор корма и уход за животными.',
      'date': DateTime.now().add(const Duration(days: 5)),
      'participants': 7,
      'color': Color(0xFF2196F3),
    },
    {
      'title': 'Благотворительный забег',
      'desc': 'Сбор средств для детей с ОВЗ.',
      'date': DateTime.now().add(const Duration(days: 10)),
      'participants': 25,
      'color': Color(0xFFE91E63),
    },
  ];

  void _createInitiative() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final dateController = TextEditingController();
    DateTime? selectedDate;
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать инициативу'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Название'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: const InputDecoration(hintText: 'Описание'),
                minLines: 2,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(hintText: 'Дата и время'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    selectedDate = picked;
                    dateController.text =
                        '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty &&
                  descController.text.trim().isNotEmpty &&
                  selectedDate != null) {
                Navigator.pop(context, {
                  'title': titleController.text.trim(),
                  'desc': descController.text.trim(),
                  'date': selectedDate,
                  'participants': 1,
                  'color': Colors.deepPurple,
                });
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() {
        _initiatives.insert(0, result);
      });
    }
  }

  void _joinInitiative(int index) {
    setState(() {
      _initiatives[index]['participants'] =
          (_initiatives[index]['participants'] as int) + 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Вы присоединились к инициативе!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(HugeIcons.strokeRoundedArrowLeft01,
              color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Волонтёрство',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade100,
            height: 1,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createInitiative,
        backgroundColor: const Color(0xFF607D8B),
        icon: const Icon(Icons.add),
        label: const Text('Создать инициативу'),
      ),
      body: _initiatives.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(HugeIcons.strokeRoundedBubbleChat,
                      size: 60, color: Colors.grey[300]),
                  const SizedBox(height: 18),
                  const Text(
                    'Нет активных инициатив',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Создайте свою инициативу или присоединяйтесь к существующим',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
              itemCount: _initiatives.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, i) {
                final n = _initiatives[i];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (n['color'] as Color).withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: (n['color'] as Color).withOpacity(0.13),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(14),
                            child: Icon(HugeIcons.strokeRoundedBubbleChat,
                                color: n['color'], size: 28),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Text(
                              n['title'],
                              style: TextStyle(
                                color: n['color'],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.people,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text('${n['participants']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        n['desc'],
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 16, color: Colors.grey[400]),
                          const SizedBox(width: 6),
                          Text(
                            _formatDate(n['date']),
                            style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () => _joinInitiative(i),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: n['color'],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              elevation: 0,
                            ),
                            child: const Text('Присоединиться'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }
}
