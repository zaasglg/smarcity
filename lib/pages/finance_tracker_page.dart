import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'dart:math';

class FinanceTrackerPage extends StatefulWidget {
  const FinanceTrackerPage({super.key});

  @override
  State<FinanceTrackerPage> createState() => _FinanceTrackerPageState();
}

class _FinanceTrackerPageState extends State<FinanceTrackerPage> {
  double balance = 120000;
  double income = 80000;
  double expense = 45000;
  final List<Map<String, dynamic>> history = [
    {
      'type': 'Доход',
      'amount': 50000,
      'category': 'Зарплата',
      'icon': HugeIcons.strokeRoundedUser,
      'color': Color(0xFF43A047),
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'type': 'Расход',
      'amount': 12000,
      'category': 'Продукты',
      'icon': HugeIcons.strokeRoundedMenu09,
      'color': Color(0xFFE91E63),
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'type': 'Доход',
      'amount': 30000,
      'category': 'Фриланс',
      'icon': HugeIcons.strokeRoundedNotification03,
      'color': Color(0xFF2196F3),
      'date': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'type': 'Расход',
      'amount': 8000,
      'category': 'Транспорт',
      'icon': HugeIcons.strokeRoundedHome03,
      'color': Color(0xFFFF9800),
      'date': DateTime.now().subtract(const Duration(days: 4)),
    },
  ];

  void _addOperation(bool isIncome) async {
    final controller = TextEditingController();
    final catController = TextEditingController();
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isIncome ? 'Добавить доход' : 'Добавить расход'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Сумма'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: catController,
              decoration: const InputDecoration(hintText: 'Категория'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              final cat = catController.text.trim();
              if (value != null && value > 0 && cat.isNotEmpty) {
                Navigator.pop(context, {
                  'amount': value,
                  'category': cat,
                });
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() {
        if (isIncome) {
          income += result['amount'];
          balance += result['amount'];
          history.insert(0, {
            'type': 'Доход',
            'amount': result['amount'],
            'category': result['category'],
            'icon': HugeIcons.strokeRoundedUser,
            'color': Color(0xFF43A047),
            'date': DateTime.now(),
          });
        } else {
          expense += result['amount'];
          balance -= result['amount'];
          history.insert(0, {
            'type': 'Расход',
            'amount': result['amount'],
            'category': result['category'],
            'icon': HugeIcons.strokeRoundedMenu09,
            'color': Color(0xFFE91E63),
            'date': DateTime.now(),
          });
        }
      });
    }
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
          'Финансовый трекер',
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
        children: [
          // Баланс
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.07),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Баланс',
                    style: TextStyle(color: Colors.grey, fontSize: 15)),
                const SizedBox(height: 8),
                Text(
                  '${balance.toStringAsFixed(0)} ₸',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Color(0xFF1E3A8A)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          // Доходы и расходы
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F6FF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      const Text('Доходы',
                          style: TextStyle(
                              color: Color(0xFF43A047),
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text(
                        '+${income.toStringAsFixed(0)} ₸',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF43A047)),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => _addOperation(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF43A047),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Добавить'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3F6),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      const Text('Расходы',
                          style: TextStyle(
                              color: Color(0xFFE91E63),
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text(
                        '-${expense.toStringAsFixed(0)} ₸',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFFE91E63)),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => _addOperation(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE91E63),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.remove, size: 18),
                        label: const Text('Добавить'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          // История операций
          const Text('История операций',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          const SizedBox(height: 12),
          ...history.take(6).map((op) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: (op['color'] as Color).withOpacity(0.07),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: (op['color'] as Color).withOpacity(0.13),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Icon(op['icon'], color: op['color'], size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              op['category'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatDate(op['date']),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        (op['type'] == 'Доход' ? '+' : '-') +
                            op['amount'].toStringAsFixed(0) +
                            ' ₸',
                        style: TextStyle(
                          color: op['type'] == 'Доход'
                              ? const Color(0xFF43A047)
                              : const Color(0xFFE91E63),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 28),
          // Совет по экономии
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.white, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    _getAdvice(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return "Сегодня, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    }
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  String _getAdvice() {
    final advices = [
      'Откладывайте 10% от каждого дохода — это создаст финансовую подушку.',
      'Планируйте покупки заранее и избегайте импульсивных трат.',
      'Используйте списки покупок и сравнивайте цены.',
      'Ведите учёт расходов — это помогает экономить.',
      'Старайтесь не брать кредиты на мелкие покупки.',
    ];
    return advices[DateTime.now().day % advices.length];
  }
}
