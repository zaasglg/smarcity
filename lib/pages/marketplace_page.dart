import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'product_detail_page.dart';
import 'craftsman_profile_page.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCategory = 'Все';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Все',
      'icon': HugeIcons.strokeRoundedMenu09,
      'color': Colors.blue,
    },
    {
      'name': 'Керамика',
      'icon': HugeIcons.strokeRoundedPaintBrush01,
      'color': Colors.orange,
    },
    {
      'name': 'Текстиль',
      'icon': HugeIcons.strokeRoundedClothes,
      'color': Colors.pink,
    },
    {
      'name': 'Дерево',
      'icon': HugeIcons.strokeRoundedTree01,
      'color': Colors.green,
    },
    {
      'name': 'Металл',
      'icon': HugeIcons.strokeRoundedCamper,
      'color': Colors.purple,
    },
    {
      'name': 'Украшения',
      'icon': HugeIcons.strokeRoundedDiamond,
      'color': Colors.amber,
    },
  ];

  final List<Map<String, dynamic>> _craftsmen = [
    {
      'name': 'Айнұр Керамшысы',
      'profession': 'Керамист',
      'rating': 4.8,
      'location': 'Алматы',
      'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=150&q=80',
      'verified': true,
      'completedOrders': 156,
    },
    {
      'name': 'Нұрлан Ағашші',
      'profession': 'Столяр',
      'rating': 4.9,
      'location': 'Нұр-Сұлтан',
      'image': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=150&q=80',
      'verified': true,
      'completedOrders': 203,
    },
    {
      'name': 'Гүлмира Тігінші',
      'profession': 'Швея',
      'rating': 4.7,
      'location': 'Шымкент',
      'image': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=150&q=80',
      'verified': false,
      'completedOrders': 89,
    },
    {
      'name': 'Бекзат Темірші',
      'profession': 'Кузнец',
      'rating': 4.6,
      'location': 'Алматы',
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80',
      'verified': true,
      'completedOrders': 67,
    },
  ];

  final List<Map<String, dynamic>> _products = [
    {
      'title': 'Керамическая ваза ручной работы',
      'price': '₸ 15 000',
      'image': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?auto=format&fit=crop&w=300&q=80',
      'isFavorite': false,
      'category': 'Керамика',
      'craftsman': 'Айнұр Керамшысы',
      'rating': 4.8,
      'isCustom': false,
    },
    {
      'title': 'Деревянный стол из дуба',
      'price': '₸ 85 000',
      'image': 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=300&q=80',
      'isFavorite': false,
      'category': 'Дерево',
      'craftsman': 'Нұрлан Ағашші',
      'rating': 4.9,
      'isCustom': true,
    },
    {
      'title': 'Вышитая национальная одежда',
      'price': '₸ 45 000',
      'image': 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?auto=format&fit=crop&w=300&q=80',
      'isFavorite': false,
      'category': 'Текстиль',
      'craftsman': 'Гүлмира Тігінші',
      'rating': 4.7,
      'isCustom': true,
    },
    {
      'title': 'Кованые декоративные элементы',
      'price': '₸ 25 000',
      'image': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?auto=format&fit=crop&w=300&q=80',
      'isFavorite': false,
      'category': 'Металл',
      'craftsman': 'Бекзат Темірші',
      'rating': 4.6,
      'isCustom': false,
    },
    {
      'title': 'Серебряные серьги с бирюзой',
      'price': '₸ 12 000',
      'image': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=300&q=80',
      'isFavorite': false,
      'category': 'Украшения',
      'craftsman': 'Айнұр Керамшысы',
      'rating': 4.8,
      'isCustom': false,
    },
    {
      'title': 'Керамические тарелки набор',
      'price': '₸ 8 000',
      'image': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?auto=format&fit=crop&w=300&q=80',
      'isFavorite': false,
      'category': 'Керамика',
      'craftsman': 'Айнұр Керамшысы',
      'rating': 4.8,
      'isCustom': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredProducts {
    List<Map<String, dynamic>> products = _products;
    
    // Filter by category
    if (selectedCategory != 'Все') {
      products = products.where((product) => product['category'] == selectedCategory).toList();
    }
    
    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      products = products.where((product) => 
        product['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
        product['craftsman'].toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return products;
  }

  List<Map<String, dynamic>> get filteredCraftsmen {
    if (_searchQuery.isEmpty) return _craftsmen;
    
    return _craftsmen.where((craftsman) => 
      craftsman['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
      craftsman['profession'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
      craftsman['location'].toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            HugeIcons.strokeRoundedArrowLeft01,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Мастерская'.toUpperCase(),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFFDB5B2B),
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: const Color(0xFFDB5B2B),
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Мастера'),
                Tab(text: 'Товары'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Поиск мастеров и товаров...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  HugeIcons.strokeRoundedSearch01,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          size: 20,
                          color: Colors.grey.shade400,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFDB5B2B), width: 1),
                ),
              ),
            ),
          ),
          // Categories (only show for products tab)
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, child) {
              return _tabController.index == 1 ? _buildCategoryFilter() : const SizedBox.shrink();
            },
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCraftsmenTab(),
                _buildProductsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality for adding new product/craftsman
        },
        backgroundColor: const Color(0xFFDB5B2B),
        child: const Icon(
          HugeIcons.strokeRoundedAdd01,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      color: Colors.white,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = selectedCategory == category['name'];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category['name'];
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? category['color'] : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? category['color'] : Colors.grey.shade300,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category['icon'],
                    size: 16,
                    color: isSelected ? Colors.white : category['color'],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category['name'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCraftsmenTab() {
    final craftsmen = filteredCraftsmen;
    
    return Column(
      children: [
        // Register as craftsman button
        Container(
          margin: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _showRegistrationModal();
              },
              icon: const Icon(
                HugeIcons.strokeRoundedUserAdd02,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                'Зарегистрироваться как ремесленник',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
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
        ),
        // Craftsmen list
        Expanded(
          child: craftsmen.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedUserSearch01,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Мастера не найдены',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Попробуйте изменить параметры поиска',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: craftsmen.length,
                  itemBuilder: (context, index) {
                    final craftsman = craftsmen[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CraftsmanProfilePage(
                              craftsman: craftsman,
                            ),
                          ),
                        );
                      },
                      child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
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
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    craftsman['image'],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Icon(
                                          HugeIcons.strokeRoundedUser,
                                          size: 40,
                                          color: Colors.grey.shade400,
                                        ),
                                      );
                                    },
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                : null,
                                            strokeWidth: 2,
                                            valueColor: const AlwaysStoppedAnimation<Color>(
                                              Color(0xFFDB5B2B),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (craftsman['verified'])
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          craftsman['name'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            craftsman['rating'].toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    craftsman['profession'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        HugeIcons.strokeRoundedLocation01,
                                        size: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          craftsman['location'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Flexible(
                                        child: Text(
                                          '${craftsman['completedOrders']} заказов',
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

  Widget _buildProductsTab() {
    final products = filteredProducts;
    
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              HugeIcons.strokeRoundedShoppingBag01,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Товары не найдены',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить категорию или поиск',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        childAspectRatio: 0.65, // Increased to give more height
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductCard(
          title: product['title'],
          price: product['price'],
          imageUrl: product['image'],
          isFavorite: product['isFavorite'],
          craftsman: product['craftsman'],
          rating: product['rating'],
          isCustom: product['isCustom'],
          onFavoriteToggle: () {
            setState(() {
              product['isFavorite'] = !product['isFavorite'];
            });
          },
        );
      },
    );
  }

  void _showRegistrationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
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
              // Title
              const Text(
                'Регистрация ремесленника',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Присоединяйтесь к нашей платформе и начните продавать свои изделия',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),
              // Benefits
              _buildBenefitItem(
                HugeIcons.strokeRoundedMoney04,
                'Увеличьте доходы',
                'Продавайте свои изделия тысячам покупателей',
              ),
              const SizedBox(height: 16),
              _buildBenefitItem(
                HugeIcons.strokeRoundedUserStar01,
                'Покажите мастерство',
                'Создайте профиль и портфолио своих работ',
              ),
              const SizedBox(height: 16),
              _buildBenefitItem(
                HugeIcons.strokeRoundedShield01,
                'Безопасные сделки',
                'Защищённые платежи и гарантия качества',
              ),
              const SizedBox(height: 16),
              _buildBenefitItem(
                HugeIcons.strokeRoundedCustomerSupport,
                'Поддержка 24/7',
                'Помощь в развитии вашего ремесленного бизнеса',
              ),
              const Spacer(),
              // Registration button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showRegistrationForm();
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
                    'Начать регистрацию',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Terms
              Center(
                child: Text(
                  'Продолжая, вы соглашаетесь с условиями использования',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFDB5B2B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFDB5B2B),
            size: 24,
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
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showRegistrationForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
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
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(HugeIcons.strokeRoundedArrowLeft01),
                  ),
                  const Text(
                    'Анкета ремесленника',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormField('Полное имя', 'Введите ваше имя'),
                      const SizedBox(height: 16),
                      _buildFormField('Специализация', 'Керамика, Дерево, Текстиль...'),
                      const SizedBox(height: 16),
                      _buildFormField('Город', 'Где вы работаете?'),
                      const SizedBox(height: 16),
                      _buildFormField('Опыт работы', 'Количество лет'),
                      const SizedBox(height: 16),
                      _buildFormField('Телефон', '+7 (___) ___-__-__'),
                      const SizedBox(height: 16),
                      _buildFormField('Email', 'your@email.com'),
                      const SizedBox(height: 16),
                      const Text(
                        'Расскажите о себе',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Опишите ваши навыки, достижения и особенности работы...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFDB5B2B), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              HugeIcons.strokeRoundedInformationCircle,
                              color: Colors.blue.shade600,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'После подачи заявки мы свяжемся с вами в течение 24 часов для верификации',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSuccessMessage();
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
                    'Подать заявку',
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

  Widget _buildFormField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDB5B2B), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Заявка отправлена! Мы свяжемся с вами в ближайшее время.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;
  final bool isFavorite;
  final String craftsman;
  final double rating;
  final bool isCustom;
  final VoidCallback onFavoriteToggle;

  const _ProductCard({
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.isFavorite,
    required this.craftsman,
    required this.rating,
    required this.isCustom,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              product: {
                'title': title,
                'price': price,
                'image': imageUrl,
                'isFavorite': isFavorite,
                'craftsman': craftsman,
                'rating': rating,
                'isCustom': isCustom,
              },
            ),
          ),
        );
      },
      child: Container(
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              HugeIcons.strokeRoundedImage01,
                              size: 40,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Изображение недоступно',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 3,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFDB5B2B),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (isCustom)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDB5B2B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'На заказ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                      onPressed: onFavoriteToggle,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      craftsman,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        
                        Flexible(
                          child: Text(
                            price,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFDB5B2B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 10,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                rating.toString(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
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
      ),
    );
  }
}