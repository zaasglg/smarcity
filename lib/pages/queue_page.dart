import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'dart:math';

class QueuePage extends StatefulWidget {
  const QueuePage({super.key});

  @override
  State<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {
  final List<Map<String, dynamic>> _services = [
    {
      'name': 'АвтоЦОН',
      'icon': HugeIcons.strokeRoundedMenu09,
      'color': Color(0xFF1E3A8A),
    },
    {
      'name': 'ЦОН',
      'icon': HugeIcons.strokeRoundedHome03,
      'color': Color(0xFF2196F3),
    },
    {
      'name': 'МФЦ',
      'icon': HugeIcons.strokeRoundedUser,
      'color': Color(0xFF43A047),
    },
    {
      'name': 'Паспортный стол',
      'icon': HugeIcons.strokeRoundedNews01,
      'color': Color(0xFFE91E63),
    },
  ];

  int? _selectedService;
  DateTime? _selectedDate;
  int? _selectedTimeIndex;

  final List<String> _timeSlots = List.generate(
      20,
      (i) =>
          '${(9 + i ~/ 2).toString().padLeft(2, '0')}:${i % 2 == 0 ? '00' : '30'}');

  // Моделируем загруженность: 0 - мало, 1 - средне, 2 - много
  List<int> get _loadPerSlot => List.generate(
      _timeSlots.length, (i) => Random(_selectedDate?.day ?? 1 + i).nextInt(3));

  void _reset() {
    setState(() {
      _selectedService = null;
      _selectedDate = null;
      _selectedTimeIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    const mainBlue = Color(0xFF1E3A8A);
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
          'Очереди в госучреждениях',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_selectedService != null ||
              _selectedDate != null ||
              _selectedTimeIndex != null)
            IconButton(
              icon: const Icon(Icons.refresh, color: mainBlue),
              tooltip: 'Сбросить',
              onPressed: _reset,
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade100,
            height: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _selectedService == null
            ? _buildServiceSelector()
            : _selectedDate == null
                ? _buildDateSelector()
                : _buildTimeSelector(mainBlue),
      ),
    );
  }

  Widget _buildServiceSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Выберите сервис',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.separated(
            itemCount: _services.length,
            separatorBuilder: (_, __) => const SizedBox(height: 18),
            itemBuilder: (context, i) {
              final s = _services[i];
              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                elevation: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => setState(() => _selectedService = i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 22, horizontal: 18),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: s['color'].withOpacity(0.10),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Icon(s['icon'], color: s['color'], size: 32),
                        ),
                        const SizedBox(width: 22),
                        Expanded(
                          child: Text(
                            s['name'],
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: 18, color: Colors.grey.shade300),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    final today = DateTime.now();
    final days = List.generate(7, (i) => today.add(Duration(days: i)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: _services[_selectedService!]['color'].withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(_services[_selectedService!]['icon'],
                  color: _services[_selectedService!]['color'], size: 26),
            ),
            const SizedBox(width: 12),
            Text(_services[_selectedService!]['name'],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 28),
        const Text('Выберите дату',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 18),
        SizedBox(
          height: 54,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final d = days[i];
              final isSelected = _selectedDate != null &&
                  _selectedDate!.day == d.day &&
                  _selectedDate!.month == d.month &&
                  _selectedDate!.year == d.year;
              return GestureDetector(
                onTap: () => setState(() => _selectedDate = d),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 72,
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF1E3A8A) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                                color: Color(0x221E3A8A),
                                blurRadius: 10,
                                offset: Offset(0, 4))
                          ]
                        : [],
                    border: Border.all(
                        color: isSelected
                            ? Color(0xFF1E3A8A)
                            : Colors.grey.shade100,
                        width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        [
                          'Пн',
                          'Вт',
                          'Ср',
                          'Чт',
                          'Пт',
                          'Сб',
                          'Вс'
                        ][d.weekday - 1],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${d.day}.${d.month}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedDate != null
                ? () => setState(() => _selectedTimeIndex = null)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              elevation: 0,
            ),
            child: const Text('Далее'),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelector(Color mainBlue) {
    final loads = _loadPerSlot;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: _services[_selectedService!]['color'].withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(_services[_selectedService!]['icon'],
                  color: _services[_selectedService!]['color'], size: 26),
            ),
            const SizedBox(width: 12),
            Text(_services[_selectedService!]['name'],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Spacer(),
            Text(
                '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}',
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 28),
        const Text('Выберите время',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 18),
        SizedBox(
          height: 54,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _timeSlots.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final isSelected = _selectedTimeIndex == i;
              final load = loads[i];
              Color slotColor;
              if (load == 0)
                slotColor = Colors.green;
              else if (load == 1)
                slotColor = Colors.orange;
              else
                slotColor = Colors.red;
              return GestureDetector(
                onTap: () => setState(() => _selectedTimeIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 78,
                  decoration: BoxDecoration(
                    color: isSelected ? mainBlue : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                                color: mainBlue.withOpacity(0.13),
                                blurRadius: 10,
                                offset: Offset(0, 4))
                          ]
                        : [],
                    border: Border.all(
                        color:
                            isSelected ? mainBlue : slotColor.withOpacity(0.5),
                        width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _timeSlots[i],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.circle, size: 12, color: slotColor),
                          const SizedBox(width: 4),
                          Text(
                            load == 0
                                ? 'Мало'
                                : load == 1
                                    ? 'Средне'
                                    : 'Много',
                            style: TextStyle(
                              color: slotColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedTimeIndex != null
                ? () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        title: const Text('Бронь подтверждена!'),
                        content: Text(
                          'Вы записаны в\n${_services[_selectedService!]['name']}\nна ${_timeSlots[_selectedTimeIndex!]}\n${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}',
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _reset();
                            },
                            child: const Text('Ок'),
                          ),
                        ],
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: mainBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              elevation: 0,
            ),
            child: const Text('Забронировать'),
          ),
        ),
      ],
    );
  }
}
