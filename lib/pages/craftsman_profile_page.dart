import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CraftsmanProfilePage extends StatefulWidget {
  final Map<String, dynamic> craftsman;

  const CraftsmanProfilePage({
    super.key,
    required this.craftsman,
  });

  @override
  State<CraftsmanProfilePage> createState() => _CraftsmanProfilePageState();
}

class _CraftsmanProfilePageState extends State<CraftsmanProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFollowing = false;

  final List<Map<String, dynamic>> _craftsmanProducts = [
    {
      'title': 'Керамическая ваза ручной работы',
      'price': '₸ 15 000',
      'image': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?auto=format&fit=crop&w=300&q=80',
      'rating': 4.8,
      'isCustom': false,
      'category': 'Керамика',
    },
    {
      'title': 'Набор керамических тарелок',
      'price': '₸ 8 000',
      'image': 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?auto=format&fit=crop&w=300&q=80',
      'rating': 4.9,
      'isCustom': false,
      'category': 'Керамика',
    },
    {
      'title': 'Керамическая ваза (на заказ)',
      'price': '₸ 20 000',
      'image': 'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?auto=format&fit=crop&w=300&q=80',
      'rating': 4.7,
      'isCustom': true,
      'category': 'Керамика',
    },
  ];

  final List<Map<String, dynamic>> _reviews = [
    {
      'userName': 'Асель Нұрғалиева',
      'userImage': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=50&q=80',
      'rating': 5.0,
      'comment': 'Прекрасная работа! Ваза получилась именно такой, как я мечтала. Качество на высшем уровне.',
      'date': '2 дня назад',
      'productImage': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?auto=format&fit=crop&w=50&q=80',
    },
    {
      'userName': 'Дина Жақсылық',
      'userImage': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=50&q=80',
      'rating': 4.8,
      'comment': 'Очень красивые тарелки, отличное качество глины. Рекомендую мастера!',
      'date': '1 неделя назад',
      'productImage': 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?auto=format&fit=crop&w=50&q=80',
    },
    {
      'userName': 'Мақсат Бекболатов',
      'userImage': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=50&q=80',
      'rating': 4.9,
      'comment': 'Заказывал набор посуды в подарок. Все сделано аккуратно и в срок. Спасибо!',
      'date': '2 недели назад',
      'productImage': 'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?auto=format&fit=crop&w=50&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileInfo(),
                _buildStatsRow(),
                _buildTabBar(),
              ],
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductsTab(),
                _buildAboutTab(),
                _buildReviewsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            HugeIcons.strokeRoundedArrowLeft01,
            color: Colors.white,
            size: 20,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              HugeIcons.strokeRoundedShare01,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () {
            // Share functionality
          },
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              HugeIcons.strokeRoundedMoreVertical,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () {
            _showMoreOptions();
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFDB5B2B).withOpacity(0.8),
                const Color(0xFFDB5B2B).withOpacity(0.6),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.craftsman['image']),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        const Color(0xFFDB5B2B).withOpacity(0.7),
                        BlendMode.overlay,
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(37),
                              child: Image.network(
                                widget.craftsman['image'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade200,
                                    child: Icon(
                                      HugeIcons.strokeRoundedUser,
                                      size: 40,
                                      color: Colors.grey.shade400,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        if (widget.craftsman['verified'])
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.fromBorderSide(
                                  BorderSide(color: Colors.white, width: 2),
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.craftsman['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.craftsman['profession'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.craftsman['rating'].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                HugeIcons.strokeRoundedLocation01,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.craftsman['location'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Follow button in header
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isFollowing = !_isFollowing;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: _isFollowing ? Colors.grey.shade200 : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isFollowing ? Icons.check : HugeIcons.strokeRoundedUserAdd02,
                                    size: 16,
                                    color: _isFollowing ? Colors.grey.shade600 : const Color(0xFFDB5B2B),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isFollowing ? 'Подписаны' : 'Подписаться',
                                    style: TextStyle(
                                      color: _isFollowing ? Colors.grey.shade600 : const Color(0xFFDB5B2B),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Remove the Row and just keep the content
          const Text(
            'О мастере',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Профессиональный керамист с более чем 8-летним опытом работы. Специализируется на создании уникальной посуды и декоративных изделий ручной работы.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFFDB5B2B),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // First row with 2 items
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '${widget.craftsman['completedOrders']}',
                  'Выполненных заказов',
                  HugeIcons.strokeRoundedShoppingBag01,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '98%',
                  'Положительных отзывов',
                  HugeIcons.strokeRoundedThumbsUp,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Second row with 1 item centered
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '2-5 дней',
                  'Среднее время изготовления',
                  HugeIcons.strokeRoundedClock01,
                  Colors.orange,
                ),
              ),
              Expanded(child: Container()), // Empty space to center the card
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFFDB5B2B),
        unselectedLabelColor: Colors.grey.shade600,
        indicatorColor: const Color(0xFFDB5B2B),
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: 'Товары'),
          Tab(text: 'О мастере'),
          Tab(text: 'Отзывы'),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _craftsmanProducts.length,
      itemBuilder: (context, index) {
        final product = _craftsmanProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  product['image'],
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedImage01,
                            size: 30,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Изображение недоступно',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (product['isCustom'])
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDB5B2B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'На заказ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product['rating'].toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        product['price'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDB5B2B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAboutSection(
            'Специализация',
            'Керамика ручной работы',
            HugeIcons.strokeRoundedPaintBrush01,
          ),
          const SizedBox(height: 16),
          _buildAboutSection(
            'Образование',
            'Алматинский Художественный Колледж\nСпециальность: Художественная керамика',
            HugeIcons.strokeRoundedSchool,
          ),
          const SizedBox(height: 16),
          _buildAboutSection(
            'Достижения',
            '• Участник выставки "Казахское ремесло 2023"\n• Победитель конкурса молодых мастеров\n• Сертифицированный мастер традиционной керамики',
            HugeIcons.strokeRoundedAward01,
          ),
          const SizedBox(height: 16),
          _buildAboutSection(
            'Рабочее время',
            'Понедельник - Пятница: 9:00 - 18:00\nСуббота: 10:00 - 16:00\nВоскресенье: выходной',
            HugeIcons.strokeRoundedClock01,
          ),
          const SizedBox(height: 16),
          _buildAboutSection(
            'Контакты',
            'Телефон: +7 (777) 123-45-67\nEmail: ainur.keramist@mail.kz\nИнстаграм: @ainur_ceramics',
            HugeIcons.strokeRoundedCall,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFDB5B2B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFDB5B2B),
              size: 20,
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        final review = _reviews[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      review['userImage'],
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            HugeIcons.strokeRoundedUser,
                            size: 20,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review['userName'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Row(
                                children: List.generate(5, (i) {
                                  return Icon(
                                    Icons.star,
                                    size: 14,
                                    color: i < review['rating'].floor()
                                        ? Colors.amber
                                        : Colors.grey.shade300,
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                review['date'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      review['productImage'],
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            HugeIcons.strokeRoundedImage01,
                            size: 20,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                review['comment'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {
                _showContactOptions();
              },
              icon: const Icon(
                HugeIcons.strokeRoundedCall,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                'Связаться',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDB5B2B),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: ElevatedButton.icon(
              onPressed: () {
                _showOrderModal();
              },
              icon: const Icon(
                HugeIcons.strokeRoundedShoppingCart01,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                'Заказать изделие',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(HugeIcons.strokeRoundedFlag01),
              title: const Text('Пожаловаться'),
              onTap: () {
                Navigator.pop(context);
                // Report functionality
              },
            ),
            ListTile(
              leading: const Icon(HugeIcons.strokeRoundedShare01),
              title: const Text('Поделиться профилем'),
              onTap: () {
                Navigator.pop(context);
                // Share functionality
              },
            ),
            ListTile(
              leading: const Icon(HugeIcons.strokeRoundedBookmark01),
              title: const Text('Сохранить в закладки'),
              onTap: () {
                Navigator.pop(context);
                // Bookmark functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showContactOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Связаться с мастером',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  HugeIcons.strokeRoundedCall,
                  color: Colors.green,
                ),
              ),
              title: const Text('Позвонить'),
              subtitle: const Text('+7 (777) 123-45-67'),
              onTap: () {
                Navigator.pop(context);
                // Call functionality
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  HugeIcons.strokeRoundedMessage01,
                  color: Colors.blue,
                ),
              ),
              title: const Text('Написать сообщение'),
              subtitle: const Text('Отправить личное сообщение'),
              onTap: () {
                Navigator.pop(context);
                // Message functionality
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  HugeIcons.strokeRoundedMail01,
                  color: Colors.orange,
                ),
              ),
              title: const Text('Отправить email'),
              subtitle: const Text('ainur.keramist@mail.kz'),
              onTap: () {
                Navigator.pop(context);
                // Email functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Заказать изделие',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Опишите что вы хотите заказать у мастера',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Тип изделия',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Например: ваза, тарелка, чашка...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFDB5B2B), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Описание заказа',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Опишите детали: размеры, цвет, стиль, особые пожелания...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFDB5B2B), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Контактная информация',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Ваш номер телефона',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFDB5B2B), width: 2),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Заказ отправлен! Мастер свяжется с вами в ближайшее время.'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDB5B2B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Отправить заказ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
