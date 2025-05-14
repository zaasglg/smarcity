import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class UtilitiesPage extends StatelessWidget {
  const UtilitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'type': 'Вода',
        'icon': HugeIcons.strokeRoundedHome03,
        'color': Color(0xFF2196F3),
        'status': 'Технические работы',
        'desc': 'Пониженное давление воды',
        'from': '10:00',
        'to': '15:00',
        'state': 'В процессе',
        'areas': ['Центр', 'Сырдарья', 'Кызылжарма'],
      },
      {
        'type': 'Газ',
        'icon': HugeIcons.strokeRoundedFire,
        'color': Color(0xFFFFC107),
        'status': 'Плановое отключение',
        'desc': 'Профилактика на линии',
        'from': '09:00',
        'to': '12:00',
        'state': 'Ожидается',
        'areas': ['Абай', 'Шанырак', 'Кызылжарма'],
      },
      {
        'type': 'Свет',
        'icon': HugeIcons.strokeRoundedFlash,
        'color': Color(0xFFFF9800),
        'status': 'Аварийные работы',
        'desc': 'Отключение электроэнергии',
        'from': '13:00',
        'to': '18:00',
        'state': 'В процессе',
        'areas': ['Центр', 'Арай', 'Саяхат'],
      },
    ];

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
          'График и оповещения ЖКХ',
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
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(HugeIcons.strokeRoundedHome03,
                      size: 60, color: Colors.grey[300]),
                  const SizedBox(height: 18),
                  const Text(
                    'Нет текущих оповещений',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Все коммунальные услуги работают в штатном режиме',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, i) {
                final n = notifications[i];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: n['color'].withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: n['color'].withOpacity(0.13),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Icon(n['icon'], color: n['color'], size: 28),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  n['type'],
                                  style: TextStyle(
                                    color: n['color'],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    letterSpacing: 0.3,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: n['color'].withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    n['status'],
                                    style: TextStyle(
                                      color: n['color'],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      letterSpacing: 0.3,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.circle,
                                    size: 10,
                                    color: n['state'] == 'В процессе'
                                        ? Colors.orange
                                        : Colors.blue),
                                const SizedBox(width: 4),
                                Text(
                                  n['state'],
                                  style: TextStyle(
                                    color: n['state'] == 'В процессе'
                                        ? Colors.orange
                                        : Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    letterSpacing: 0.3,
                                    height: 1.4,
                                    decoration: TextDecoration.none,
                                    decorationColor: const Color(0xff191c20),
                                    leadingDistribution:
                                        TextLeadingDistribution.even,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              n['desc'],
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                            if (n['areas'] != null &&
                                n['areas'].isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  for (final area in n['areas'])
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: n['color'].withOpacity(0.09),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        area,
                                        style: TextStyle(
                                          color: n['color'],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.schedule,
                                    size: 16, color: Colors.grey[400]),
                                const SizedBox(width: 6),
                                Text(
                                  '${n['from']} — ${n['to']}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
