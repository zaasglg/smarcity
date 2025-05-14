import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class HealthTrackerPage extends StatefulWidget {
  const HealthTrackerPage({super.key});

  @override
  State<HealthTrackerPage> createState() => _HealthTrackerPageState();
}

class _HealthTrackerPageState extends State<HealthTrackerPage> {
  double sleepHours = 7.5;
  final double sleepGoal = 8.0;
  double water = 1.2;
  final double waterGoal = 2.0;
  int steps = 6500;
  final int stepsGoal = 10000;
  int breath = 2;
  final int breathGoal = 3;

  void _addSleep() async {
    final controller = TextEditingController();
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить часы сна'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(hintText: 'Часы (например, 7.5)'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              final value =
                  double.tryParse(controller.text.replaceAll(',', '.'));
              if (value != null && value > 0 && value < 24) {
                Navigator.pop(context, value);
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() => sleepHours = result);
    }
  }

  void _addWater(double amount) {
    setState(() {
      water = (water + amount).clamp(0, waterGoal);
    });
  }

  void _addSteps() async {
    final controller = TextEditingController();
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить шаги'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Количество шагов'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value > 0) {
                Navigator.pop(context, value);
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() => steps = (steps + result).clamp(0, stepsGoal));
    }
  }

  void _addBreath() {
    setState(() {
      if (breath < breathGoal) breath++;
    });
  }

  void _resetBreath() {
    setState(() => breath = 0);
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
          'Трекер здоровья',
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
          // Сон
          _HealthCard(
            color: const Color(0xFF1E3A8A),
            icon: HugeIcons.strokeRoundedMoon,
            title: 'Сон',
            value:
                '${sleepHours.toStringAsFixed(1)} ч / ${sleepGoal.toStringAsFixed(0)} ч',
            progress: sleepHours / sleepGoal,
            progressColor: const Color(0xFF1E3A8A),
            subtitle: 'Рекомендуется 7-9 часов сна',
            action: ElevatedButton(
              onPressed: _addSleep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                elevation: 0,
              ),
              child: const Text('Добавить сон'),
            ),
          ),
          const SizedBox(height: 18),
          // Вода
          _HealthCard(
            color: const Color(0xFF2196F3),
            icon: HugeIcons.strokeRoundedHome03,
            title: 'Вода',
            value:
                '${water.toStringAsFixed(1)} л / ${waterGoal.toStringAsFixed(0)} л',
            progress: water / waterGoal,
            progressColor: const Color(0xFF2196F3),
            subtitle: 'Рекомендуется 2 литра в день',
            isCircle: true,
            action: Row(
              children: [
                ElevatedButton(
                  onPressed: () => _addWater(0.25),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    elevation: 0,
                  ),
                  child: const Text('+ стакан'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _addWater(-0.25),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    elevation: 0,
                  ),
                  child: const Text('-'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // Шаги
          _HealthCard(
            color: const Color(0xFF43A047),
            icon: HugeIcons.strokeRoundedUser,
            title: 'Шаги',
            value: '$steps / $stepsGoal',
            progress: steps / stepsGoal,
            progressColor: const Color(0xFF43A047),
            subtitle: 'Рекомендуется 10 000 шагов',
            action: ElevatedButton(
              onPressed: _addSteps,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43A047),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                elevation: 0,
              ),
              child: const Text('Добавить шаги'),
            ),
          ),
          const SizedBox(height: 18),
          // Дыхательные практики
          _HealthCard(
            color: const Color(0xFFE91E63),
            icon: HugeIcons.strokeRoundedNotification03,
            title: 'Дыхательные практики',
            value: '$breath / $breathGoal',
            progress: breath / breathGoal,
            progressColor: const Color(0xFFE91E63),
            subtitle: 'Рекомендуется 2-3 подхода в день',
            action: Row(
              children: [
                ElevatedButton(
                  onPressed: _addBreath,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    elevation: 0,
                  ),
                  child: const Text('+ подход'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetBreath,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    elevation: 0,
                  ),
                  child: const Text('Сбросить'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;
  final double progress;
  final Color progressColor;
  final String subtitle;
  final bool isCircle;
  final Widget? action;

  const _HealthCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
    required this.progress,
    required this.progressColor,
    required this.subtitle,
    this.isCircle = false,
    this.action,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.13),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                isCircle
                    ? _CircleProgress(progress: progress, color: progressColor)
                    : _BarProgress(progress: progress, color: progressColor),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
                ),
                if (action != null) ...[
                  const SizedBox(height: 12),
                  action!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarProgress extends StatelessWidget {
  final double progress;
  final Color color;
  const _BarProgress({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: progress.clamp(0, 1),
        minHeight: 8,
        backgroundColor: color.withOpacity(0.13),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class _CircleProgress extends StatelessWidget {
  final double progress;
  final Color color;
  const _CircleProgress({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progress.clamp(0, 1),
            strokeWidth: 6,
            backgroundColor: color.withOpacity(0.13),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Center(
            child: Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
