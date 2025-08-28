import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smartcity/pages/education_page.dart';
import 'package:smartcity/pages/feedback_page.dart';
import 'package:smartcity/pages/finance_tracker_page.dart';
import 'package:smartcity/pages/health_tracker_page.dart';
import 'package:smartcity/pages/map_page.dart';
import 'package:smartcity/pages/marketplace_page.dart';
import 'package:smartcity/pages/pharmacy_page.dart';
import 'package:smartcity/pages/queue_page.dart';
import 'package:smartcity/pages/scanner_page.dart';
import 'package:smartcity/pages/utilities_page.dart';
import 'package:smartcity/pages/volunteering_page.dart';
import 'package:smartcity/pages/news_detail_page.dart';
import 'package:smartcity/services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherData? _currentWeather;
  bool _isLoadingWeather = true;
  String _weatherError = '';

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    try {
      setState(() {
        _isLoadingWeather = true;
        _weatherError = '';
      });

      final weather = await WeatherService.getCurrentWeather('Turkistan');
      
      if (weather != null) {
        setState(() {
          _currentWeather = weather;
          _isLoadingWeather = false;
        });
      } else {
        setState(() {
          _weatherError = 'Не удалось загрузить данные о погоде';
          _isLoadingWeather = false;
        });
      }
    } catch (e) {
      setState(() {
        _weatherError = 'Ошибка: $e';
        _isLoadingWeather = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const Border(
          top: BorderSide(
            color: Color.fromARGB(255, 241, 238, 238),
            width: 1,
          ),
        ),
        // leading: IconButton(
        //   icon:
        //       const Icon(HugeIcons.strokeRoundedMenu09, color: Colors.black87),
        //   onPressed: () {},
        // ),
        centerTitle: true,
        title: const Image(
          image: AssetImage("./assets/icons/turkistan.png"),
          width: 120.0,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              HugeIcons.strokeRoundedNotification03,
              color: Colors.black87,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Уведомления',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '2 новых',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildNotificationItem(
                        'Новое сообщение',
                        'Вы получили новое сообщение от администрации',
                        '5 минут назад',
                        Icons.message,
                        Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      _buildNotificationItem(
                        'Обновление сервиса',
                        'Доступно новое обновление приложения',
                        '1 час назад',
                        Icons.system_update,
                        Colors.green,
                      ),
                      const SizedBox(height: 12),
                      _buildNotificationItem(
                        'Напоминание',
                        'Не забудьте оплатить коммунальные услуги',
                        '2 часа назад',
                        Icons.notifications,
                        Colors.orange,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
              height: 1,
              thickness: 1,
              color: Color.fromARGB(255, 241, 238, 238)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map/banner
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFFE9F0F7),
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('./assets/images/map.png'),
                  fit: BoxFit.cover,
                  opacity: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MapPage(),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE95A7B),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Text(
                            'Карта города',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // "Впервые в Туркестане" button
            _buildFirstTimeInTurkestanButton(),
            const SizedBox(height: 16),
            // City metrics block
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(16),
            //     border: Border.all(
            //       color: const Color.fromARGB(255, 241, 238, 238),
            //       width: 1,
            //     ),
            //   ),
            //   child: Column(
            //     children: [
            //       const Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             'Показатели города',
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               fontSize: 16,
            //             ),
            //           ),
            //           Icon(
            //             Icons.trending_up,
            //             color: Color(0xFFE95A7B),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 16),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //         children: [
            //           _buildMetricItem(
            //             'Воздух',
            //             'Хороший',
            //             Icons.air,
            //             const Color(0xFF4CAF50),
            //           ),
            //           _buildMetricItem(
            //             'Трафик',
            //             'Свободный',
            //             Icons.directions_car,
            //             const Color(0xFF2196F3),
            //           ),
            //           _buildMetricItem(
            //             'Энергия',
            //             'Стабильный',
            //             Icons.electric_bolt,
            //             const Color(0xFFFFC107),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 20),
            _WeatherCard(),
            const SizedBox(height: 20),
            // Categories section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Сервисы',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Icon(HugeIcons.strokeRoundedMoreHorizontalCircle01,
                      color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              childAspectRatio: 1,
              children: [
                _buildCategoryItem(
                  'Обратная связь',
                  HugeIcons.strokeRoundedBubbleChat,
                  const Color(0xFF4CAF50),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FeedbackPage(),
                      ),
                    );
                  },
                ),
                _buildCategoryItem(
                  'Очереди',
                  HugeIcons.strokeRoundedUser,
                  const Color(0xFF2196F3),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QueuePage(),
                      ),
                    );
                  },
                ),
                _buildCategoryItem(
                  'ЖКХ',
                  HugeIcons.strokeRoundedHome03,
                  const Color(0xFFFF9800),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UtilitiesPage(),
                      ),
                    );
                  },
                ),
                _buildCategoryItem(
                  'Аптеки',
                  HugeIcons.strokeRoundedMedicalMask,
                  const Color(0xFFE95A7B),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PharmacyPage(),
                      ),
                    );
                  },
                ),
                _buildCategoryItem(
                  'Финансы',
                  HugeIcons.strokeRoundedMenu09,
                  const Color(0xFF9C27B0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FinanceTrackerPage(),
                      ),
                    );
                  },
                ),
                _buildCategoryItem(
                  'Nomad Market',
                  HugeIcons.strokeRoundedNews01,
                  const Color(0xFF00BCD4),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MarketplacePage(),
                      ),
                    );
                  },
                ),
                _buildCategoryItem(
                  'Сканер',
                  HugeIcons.strokeRoundedCamera02,
                  const Color(0xFF795548),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScannerScreen(),
                      ),
                    );
                  },
                ),
                _buildCategoryItem(
                  'Волонтёры',
                  HugeIcons.strokeRoundedBubbleChat,
                  const Color(0xFF607D8B),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VolunteeringPage(),
                      ),
                    );
                  },
                ),

                _buildCategoryItem(
                  'Образование',
                  HugeIcons.strokeRoundedGlobalEducation,
                  const Color(0xFF607D8B),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EducationPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 28),
            // News section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Новости Туркестана',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Icon(HugeIcons.strokeRoundedMoreHorizontalCircle01,
                      color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                _buildNewsItem(
                  context,
                  'В Туркестане открылся новый парк "Акмечеть"',
                  'Сегодня состоялось торжественное открытие нового парка отдыха с современной инфраструктурой',
                  '2 часа назад',
                  'https://images.unsplash.com/photo-1519832979-6fa011b87667?auto=format&fit=crop&w=80&q=80',
                ),
                const SizedBox(height: 12),
                _buildNewsItem(
                  context,
                  'В Туркестанской области начался сев риса',
                  'Аграрии приступили к посевной кампании. В этом году планируется засеять более 100 тысяч гектаров',
                  '5 часов назад',
                  'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=80&q=80',
                ),
                const SizedBox(height: 12),
                _buildNewsItem(
                  context,
                  'В Туркестане проходит фестиваль "Шелковый путь"',
                  'Международный фестиваль собрал участников из 15 стран. В программе: выставки, концерты и мастер-классы',
                  'Вчера',
                  'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=80&q=80',
                ),
                const SizedBox(height: 12),
                _buildNewsItem(
                  context,
                  'В Туркестане запустили новый автобусный маршрут',
                  'Новый маршрут свяжет центр города с новым микрорайоном "Акмечеть". Интервал движения - 10 минут',
                  '2 дня назад',
                  'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=80&q=80',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(
      String label, String value, IconData icon, bool isDark) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.grey.shade300,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsItem(BuildContext context, String title, String description,
      String timeAgo, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(
              avatarUrl: 'assets/icons/guest.png',
              userName: 'Администрация',
              timeAgo: timeAgo,
              text: description,
              imageUrls: [imageUrl],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color.fromARGB(255, 241, 238, 238),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
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

  Widget _buildCategoryItem(String title, IconData icon, Color color,
      {VoidCallback? onTap}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _WeatherCard() {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage(
              'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xAA6EC6F7),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: _isLoadingWeather
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : _weatherError.isNotEmpty
                ? Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _weatherError,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: _loadWeatherData,
                      ),
                    ],
                  )
                : _currentWeather != null
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _getWeatherIcon(_currentWeather!.condition),
                                    color: const Color(0xFFFFB300),
                                    size: 40,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Туркестан',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  _currentWeather!.condition,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Temperature
                          Text(
                            '${_currentWeather!.tempC.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const Row(
                        children: [
                          Icon(Icons.cloud_off, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Нет данных о погоде',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    final lowerCondition = condition.toLowerCase();
    if (lowerCondition.contains('sun') || lowerCondition.contains('clear')) {
      return Icons.wb_sunny_rounded;
    } else if (lowerCondition.contains('cloud')) {
      return Icons.cloud;
    } else if (lowerCondition.contains('rain')) {
      return Icons.grain;
    } else if (lowerCondition.contains('snow')) {
      return Icons.ac_unit;
    } else if (lowerCondition.contains('thunder')) {
      return Icons.flash_on;
    } else {
      return Icons.wb_cloudy;
    }
  }

  Widget _buildNotificationItem(
      String title, String message, String time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFirstTimeInTurkestanButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromARGB(255, 241, 238, 238),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Row(
                  children: [
                    Icon(
                      Icons.explore,
                      color: Color(0xFFE95A7B),
                      size: 28,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Добро пожаловать!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: const Text(
                  'Откройте для себя все возможности умного города Туркестан! Здесь вы найдете гид по основным сервисам, достопримечательностям и полезным функциям приложения.',
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Позже'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Здесь можно добавить навигацию к странице гида
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE95A7B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Начать'),
                  ),
                ],
              ),
            );
          },
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE95A7B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.explore,
                  color: Color(0xFFE95A7B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Впервые в Туркестане?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Узнайте о возможностях города',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
