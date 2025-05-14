import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smartcity/pages/feedback_page.dart';
import 'package:smartcity/pages/finance_tracker_page.dart';
import 'package:smartcity/pages/health_tracker_page.dart';
import 'package:smartcity/pages/map_page.dart';
import 'package:smartcity/pages/marketplace_page.dart';
import 'package:smartcity/pages/queue_page.dart';
import 'package:smartcity/pages/utilities_page.dart';
import 'package:smartcity/pages/volunteering_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        leading: IconButton(
          icon:
              const Icon(HugeIcons.strokeRoundedMenu09, color: Colors.black87),
          onPressed: () {},
        ),
        centerTitle: true,
        title: Text(
          'Главная'.toUpperCase(),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              HugeIcons.strokeRoundedNotification03,
              color: Colors.black87,
            ),
            onPressed: () {},
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
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFE9F0F7),
                borderRadius: BorderRadius.circular(16),
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
            // Friends block
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/women/1.jpg'),
                    radius: 18,
                  ),
                  SizedBox(width: 4),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/men/2.jpg'),
                    radius: 18,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Мадина рядом',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'живет в том же месте',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Weather widget
            _WeatherCard(),
            const SizedBox(height: 28),
            // News section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Новости Кызылорды',
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
                  'В Кызылорде открылся новый парк "Акмечеть"',
                  'Сегодня состоялось торжественное открытие нового парка отдыха с современной инфраструктурой',
                  '2 часа назад',
                  'https://images.unsplash.com/photo-1519832979-6fa011b87667?auto=format&fit=crop&w=80&q=80',
                ),
                const SizedBox(height: 12),
                _buildNewsItem(
                  'В Кызылординской области начался сев риса',
                  'Аграрии приступили к посевной кампании. В этом году планируется засеять более 100 тысяч гектаров',
                  '5 часов назад',
                  'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=80&q=80',
                ),
                const SizedBox(height: 12),
                _buildNewsItem(
                  'В Кызылорде проходит фестиваль "Шелковый путь"',
                  'Международный фестиваль собрал участников из 15 стран. В программе: выставки, концерты и мастер-классы',
                  'Вчера',
                  'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=80&q=80',
                ),
                const SizedBox(height: 12),
                _buildNewsItem(
                  'В Кызылорде запустили новый автобусный маршрут',
                  'Новый маршрут свяжет центр города с новым микрорайоном "Акмечеть". Интервал движения - 10 минут',
                  '2 дня назад',
                  'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=80&q=80',
                ),
              ],
            ),
            const SizedBox(height: 28),
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
              crossAxisCount: 1,
              mainAxisSpacing: 12,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              childAspectRatio: 3.5,
              children: [
                _buildCategoryItem(
                  'Обратная связь от граждан',
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
                  'Очереди в госучреждениях',
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
                  'График и оповещения ЖКХ',
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
                  'Трекер здоровья',
                  HugeIcons.strokeRoundedNotification03,
                  const Color(0xFFE91E63),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HealthTrackerPage(),
                      ),
                    );
                  },
                ),
                _buildCategoryItem(
                  'Финансовый трекер',
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
                  'Маркетплейс',
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
                  HugeIcons.strokeRoundedMoreHorizontalCircle01,
                  const Color(0xFF795548),
                ),
                _buildCategoryItem(
                  'Волонтёрство',
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

  Widget _buildNewsItem(
      String title, String description, String time, String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
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
                  time,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, Color color,
      {VoidCallback? onTap}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
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
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
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
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.wb_sunny_rounded,
                        color: Color(0xFFFFB300), size: 40),
                  ],
                ),
              ],
            ),

            Spacer(),

            // Temperature
            Text(
              '20°',
              style: TextStyle(
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
        ),
      ),
    );
  }
}
