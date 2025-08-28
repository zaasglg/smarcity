import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class HealthTrackerPage extends StatefulWidget {
  const HealthTrackerPage({super.key});

  @override
  State<HealthTrackerPage> createState() => _HealthTrackerPageState();
}

class _HealthTrackerPageState extends State<HealthTrackerPage> {
  SharedPreferences? _prefs;
  DateTime _selectedDate = DateTime.now();
  final Color mainColor = const Color(0xFFDB5B2B);

  // Health metrics with persistence
  double sleepHours = 0.0;
  final double sleepGoal = 8.0;
  double water = 0.0;
  final double waterGoal = 2.0;
  int steps = 0;
  final int stepsGoal = 10000;
  int breath = 0;
  final int breathGoal = 3;

  // Weekly statistics
  List<double> weeklySleep = [];
  List<double> weeklyWater = [];
  List<int> weeklySteps = [];
  List<int> weeklyBreath = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadData();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadData() async {
    if (_prefs == null) return;

    final dateKey = DateFormat('yyyy-MM-dd').format(_selectedDate);

    setState(() {
      sleepHours = _prefs!.getDouble('sleep_$dateKey') ?? 0.0;
      water = _prefs!.getDouble('water_$dateKey') ?? 0.0;
      steps = _prefs!.getInt('steps_$dateKey') ?? 0;
      breath = _prefs!.getInt('breath_$dateKey') ?? 0;

      // Load weekly data
      _loadWeeklyData();
    });
  }

  void _loadWeeklyData() {
    if (_prefs == null) return;

    weeklySleep = [];
    weeklyWater = [];
    weeklySteps = [];
    weeklyBreath = [];

    for (int i = 6; i >= 0; i--) {
      final date = _selectedDate.subtract(Duration(days: i));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);

      weeklySleep.add(_prefs!.getDouble('sleep_$dateKey') ?? 0.0);
      weeklyWater.add(_prefs!.getDouble('water_$dateKey') ?? 0.0);
      weeklySteps.add(_prefs!.getInt('steps_$dateKey') ?? 0);
      weeklyBreath.add(_prefs!.getInt('breath_$dateKey') ?? 0);
    }
  }

  Future<void> _saveData() async {
    if (_prefs == null) return;

    final dateKey = DateFormat('yyyy-MM-dd').format(_selectedDate);
    await _prefs!.setDouble('sleep_$dateKey', sleepHours);
    await _prefs!.setDouble('water_$dateKey', water);
    await _prefs!.setInt('steps_$dateKey', steps);
    await _prefs!.setInt('breath_$dateKey', breath);
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
      _loadData();
    });
  }

  void _addSleep() async {
    final controller = TextEditingController();
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить часы сна'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
      _saveData();
    }
  }

  void _addWater(double amount) {
    setState(() {
      water = (water + amount).clamp(0, waterGoal);
      _saveData();
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
      _saveData();
    }
  }

  void _addBreath() {
    setState(() {
      if (breath < breathGoal) breath++;
      _saveData();
    });
  }

  void _resetBreath() {
    setState(() {
      breath = 0;
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: mainColor,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(HugeIcons.strokeRoundedArrowLeft01,
              color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _changeDate(-1),
            ),
            Text(
              DateFormat('d MMMM').format(_selectedDate),
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                if (_selectedDate.isBefore(DateTime.now())) {
                  _changeDate(1);
                }
              },
            ),
          ],
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
          // Weekly Statistics Card
          _WeeklyStatsCard(
            weeklySleep: weeklySleep,
            weeklyWater: weeklyWater,
            weeklySteps: weeklySteps,
            weeklyBreath: weeklyBreath,
            mainColor: mainColor,
          ),
          const SizedBox(height: 18),
          // Сон
          _HealthCard(
            color: mainColor,
            icon: HugeIcons.strokeRoundedMoon,
            title: 'Сон',
            value:
                '${sleepHours.toStringAsFixed(1)} ч / ${sleepGoal.toStringAsFixed(0)} ч',
            progress: sleepHours / sleepGoal,
            progressColor: mainColor,
            subtitle: 'Рекомендуется 7-9 часов сна',
            action: ElevatedButton(
              onPressed: _addSleep,
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
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
            color: mainColor,
            icon: HugeIcons.strokeRoundedHome03,
            title: 'Вода',
            value:
                '${water.toStringAsFixed(1)} л / ${waterGoal.toStringAsFixed(0)} л',
            progress: water / waterGoal,
            progressColor: mainColor,
            subtitle: 'Рекомендуется 2 литра в день',
            isCircle: true,
            action: Row(
              children: [
                ElevatedButton(
                  onPressed: () => _addWater(0.25),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
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
            color: mainColor,
            icon: HugeIcons.strokeRoundedUser,
            title: 'Шаги',
            value: '$steps / $stepsGoal',
            progress: steps / stepsGoal,
            progressColor: mainColor,
            subtitle: 'Рекомендуется 10 000 шагов',
            action: ElevatedButton(
              onPressed: _addSteps,
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
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
            color: mainColor,
            icon: HugeIcons.strokeRoundedNotification03,
            title: 'Дыхательные практики',
            value: '$breath / $breathGoal',
            progress: breath / breathGoal,
            progressColor: mainColor,
            subtitle: 'Рекомендуется 2-3 подхода в день',
            action: Row(
              children: [
                ElevatedButton(
                  onPressed: _addBreath,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
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
            color: color.withOpacity(0.05),
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
              color: color.withOpacity(0.1),
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

class _WeeklyStatsCard extends StatelessWidget {
  final List<double> weeklySleep;
  final List<double> weeklyWater;
  final List<int> weeklySteps;
  final List<int> weeklyBreath;
  final Color mainColor;

  const _WeeklyStatsCard({
    required this.weeklySleep,
    required this.weeklyWater,
    required this.weeklySteps,
    required this.weeklyBreath,
    required this.mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Статистика за неделю',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: ChartPainter(
                sleepData: weeklySleep,
                waterData: weeklyWater,
                mainColor: mainColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Пн', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('Вт', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('Ср', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('Чт', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('Пт', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('Сб', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('Вс', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('Сон', mainColor),
              _buildLegendItem('Вода', mainColor.withOpacity(0.5)),
            ],
          ),
          const SizedBox(height: 24),
          // Steps and Breath stats
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  'Шаги',
                  '${weeklySteps.reduce((a, b) => a + b) ~/ 7}',
                  'среднее',
                  mainColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatBox(
                  'Дыхание',
                  '${weeklyBreath.reduce((a, b) => a + b) ~/ 7}',
                  'среднее',
                  mainColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(
      String title, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<double> sleepData;
  final List<double> waterData;
  final Color mainColor;

  ChartPainter({
    required this.sleepData,
    required this.waterData,
    required this.mainColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final areaPaint = Paint()..style = PaintingStyle.fill;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * (1 - i / 4);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Draw sleep data
    paint.color = mainColor;
    areaPaint.color = mainColor.withOpacity(0.1);
    _drawLine(canvas, size, sleepData, paint, dotPaint, areaPaint);

    // Draw water data
    paint.color = mainColor.withOpacity(0.5);
    areaPaint.color = mainColor.withOpacity(0.05);
    _drawLine(canvas, size, waterData.map((e) => e * 2).toList(), paint,
        dotPaint, areaPaint);
  }

  void _drawLine(
    Canvas canvas,
    Size size,
    List<double> data,
    Paint paint,
    Paint dotPaint,
    Paint areaPaint,
  ) {
    if (data.isEmpty) return;

    final path = Path();
    final areaPath = Path();
    final maxValue = data.reduce(math.max);
    final minValue = data.reduce(math.min);
    final range = maxValue - minValue;
    final scale = range > 0 ? size.height * 0.8 / range : 1.0;

    for (int i = 0; i < data.length; i++) {
      final x = size.width * i / (data.length - 1);
      final y = size.height * 0.9 - (data[i] - minValue) * scale;

      if (i == 0) {
        path.moveTo(x, y);
        areaPath.moveTo(x, size.height * 0.9);
        areaPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        areaPath.lineTo(x, y);
      }

      // Draw dot
      dotPaint.color = paint.color;
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
      canvas.drawCircle(Offset(x, y), 6, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }

    // Close area path
    areaPath.lineTo(size.width, size.height * 0.9);
    areaPath.close();

    // Draw area
    canvas.drawPath(areaPath, areaPaint);
    // Draw line
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
