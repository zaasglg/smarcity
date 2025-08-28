import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  String _selectedCategory = 'Все';
  final List<String> _categories = ['Все', 'Школы', 'Детские сады', 'Университеты и колледжи', 'Кружки'];

  final List<Map<String, dynamic>> _educationInstitutions = [
    // Школы
    {
      'name': 'Школа-гимназия №1 имени Ахмета Ясауи',
      'category': 'Школы',
      'address': 'ул. Тауке хана, 45',
      'phone': '+7 (72533) 4-15-67',
      'rating': 4.8,
      'students': 850,
      'type': 'Государственная',
      'description': 'Одна из лучших школ города с углубленным изучением математики и естественных наук.',
    },
    {
      'name': 'Назарбаев Интеллектуальная школа',
      'category': 'Школы',
      'address': 'ул. Абая, 12',
      'phone': '+7 (72533) 5-22-88',
      'rating': 4.9,
      'students': 720,
      'type': 'Автономная',
      'description': 'Современная школа с инновационными методами обучения и международными стандартами.',
    },
    {
      'name': 'Школа №15',
      'category': 'Школы',
      'address': 'мкр. Акмечеть, 23',
      'phone': '+7 (72533) 3-44-55',
      'rating': 4.5,
      'students': 650,
      'type': 'Государственная',
      'description': 'Общеобразовательная школа с хорошей материально-технической базой.',
    },
    
    // Детские сады
    {
      'name': 'Детский сад "Балапан"',
      'category': 'Детские сады',
      'address': 'ул. Сатпаева, 18',
      'phone': '+7 (72533) 2-33-44',
      'rating': 4.6,
      'students': 120,
      'type': 'Государственный',
      'description': 'Детский сад с развивающими программами для детей от 2 до 6 лет.',
    },
    {
      'name': 'Детский сад "��қбота"',
      'category': 'Детские сады',
      'address': 'ул. Кунаева, 7',
      'phone': '+7 (72533) 6-77-88',
      'rating': 4.7,
      'students': 95,
      'type': 'Частный',
      'description': 'Частный детский сад с билингвальным обучением и современными игровыми площадками.',
    },
    {
      'name': 'Детский сад №8 "Гүлдер"',
      'category': 'Детские сады',
      'address': 'мкр. Центральный, 34',
      'phone': '+7 (72533) 4-55-66',
      'rating': 4.4,
      'students': 140,
      'type': 'Государственный',
      'description': 'Детский сад с логопедическими группами и программами раннего развития.',
    },
    
    // Университеты и колледжи
    {
      'name': 'Международный казахско-турецкий университет имени Х.А. Ясави',
      'category': 'Университеты и колледжи',
      'address': 'ул. Б. Саттарханова, 29',
      'phone': '+7 (72533) 25-11-11',
      'rating': 4.8,
      'students': 8500,
      'type': 'Государственный',
      'description': 'Ведущий университет региона с международными программами обучения.',
    },
    {
      'name': 'Туркестанский региональный университет',
      'category': 'Университеты и колледжи',
      'address': 'ул. Толе би, 67',
      'phone': '+7 (72533) 21-33-44',
      'rating': 4.5,
      'students': 4200,
      'type': 'Государственный',
      'description': 'Университет с сильными факультетами педагогики и естественных наук.',
    },
    {
      'name': 'Туркестанский колледж бизнеса',
      'category': 'Университеты и колледжи',
      'address': 'ул. Назарбаева, 89',
      'phone': '+7 (72533) 7-88-99',
      'rating': 4.3,
      'students': 850,
      'type': 'Частный',
      'description': 'Колледж с программами по бизнесу, экономике и информационным технологиям.',
    },
    
    // Кружки
    {
      'name': 'Дворец школьников',
      'category': 'Кружки',
      'address': 'ул. Абая, 45',
      'phone': '+7 (72533) 3-22-11',
      'rating': 4.7,
      'students': 450,
      'type': 'Государственный',
      'description': 'Центр дополнительного образования с кружками по робототехнике, танцам, музыке.',
    },
    {
      'name': 'Спортивная школа "Жас Барыс"',
      'category': 'Кружки',
      'address': 'ул. Спортивная, 12',
      'phone': '+7 (72533) 5-44-33',
      'rating': 4.6,
      'students': 320,
      'type': 'Государственная',
      'description': 'Спортивная школа по футболу, баскетболу, волейболу и легкой атлетике.',
    },
    {
      'name': 'Музыкальная школа имени Курмангазы',
      'category': 'Кружки',
      'address': 'ул. Музыкальная, 8',
      'phone': '+7 (72533) 2-66-77',
      'rating': 4.8,
      'students': 280,
      'type': 'Государственная',
      'description': 'Музыкальная школа с обучением игре на традиционных и современных инструментах.',
    },
    {
      'name': 'IT-клуб "Цифровое будущее"',
      'category': 'Кружки',
      'address': 'ул. Технологическая, 15',
      'phone': '+7 (72533) 8-99-00',
      'rating': 4.9,
      'students': 150,
      'type': 'Частный',
      'description': 'Современный IT-клуб с курсами программирования, веб-дизайна и робототехники.',
    },
  ];

  List<Map<String, dynamic>> get _filteredInstitutions {
    if (_selectedCategory == 'Все') {
      return _educationInstitutions;
    }
    return _educationInstitutions
        .where((institution) => institution['category'] == _selectedCategory)
        .toList();
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Школы':
        return HugeIcons.strokeRoundedSchool;
      case 'Детские сады':
        return HugeIcons.strokeRoundedBaby01;
      case 'Университеты и колледжи':
        return HugeIcons.strokeRoundedUniversity;
      case 'Кружки':
        return HugeIcons.strokeRoundedPaintBoard;
      default:
        return HugeIcons.strokeRoundedSchool;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Школы':
        return const Color(0xFF2196F3);
      case 'Детские сады':
        return const Color(0xFFE91E63);
      case 'Университеты и колледжи':
        return const Color(0xFF9C27B0);
      case 'Кружки':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF2196F3);
    }
  }

  int _getCategoryCount(String category) {
    if (category == 'Все') {
      return _educationInstitutions.length;
    }
    return _educationInstitutions
        .where((institution) => institution['category'] == category)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            HugeIcons.strokeRoundedArrowLeft01,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Образование'.toUpperCase(),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 36,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск учебных заведений',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  HugeIcons.strokeRoundedSearch01,
                  size: 18,
                  color: Colors.grey.shade400,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // Category filter
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? Colors.white.withOpacity(0.2)
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _getCategoryCount(category).toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey.shade600,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: const Color(0xFF2196F3),
                    checkmarkColor: Colors.white,
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                );
              },
            ),
          ),
          
          // Institutions list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredInstitutions.length,
              itemBuilder: (context, index) {
                final institution = _filteredInstitutions[index];
                return _buildInstitutionCard(institution);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstitutionCard(Map<String, dynamic> institution) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getCategoryColor(institution['category']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(institution['category']),
                  color: _getCategoryColor(institution['category']),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      institution['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      institution['category'],
                      style: TextStyle(
                        fontSize: 12,
                        color: _getCategoryColor(institution['category']),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: institution['type'] == 'Государственный' || institution['type'] == 'Государственная' || institution['type'] == 'Автономная'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  institution['type'],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: institution['type'] == 'Государственный' || institution['type'] == 'Государственная' || institution['type'] == 'Автономная'
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Text(
            institution['description'],
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedLocation01,
                size: 14,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  institution['address'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedCall,
                size: 14,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 4),
              Text(
                institution['phone'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    HugeIcons.strokeRoundedStar,
                    size: 14,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    institution['rating'].toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  Icon(
                    HugeIcons.strokeRoundedUser,
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${institution['students']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Handle call action
                  },
                  icon: const Icon(
                    HugeIcons.strokeRoundedCall,
                    size: 16,
                  ),
                  label: const Text('Позвонить'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2196F3),
                    side: const BorderSide(color: Color(0xFF2196F3)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showInstitutionDetails(context, institution);
                  },
                  icon: const Icon(
                    HugeIcons.strokeRoundedInformationCircle,
                    size: 16,
                  ),
                  label: const Text('Подробнее'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showInstitutionDetails(BuildContext context, Map<String, dynamic> institution) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(institution['category']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(institution['category']),
                      color: _getCategoryColor(institution['category']),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          institution['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          institution['category'],
                          style: TextStyle(
                            fontSize: 14,
                            color: _getCategoryColor(institution['category']),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      HugeIcons.strokeRoundedCancel01,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Описание',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            institution['description'],
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Contact Information
                    Text(
                      'Контактная информация',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildDetailItem(
                      'Адрес',
                      institution['address'],
                      HugeIcons.strokeRoundedLocation01,
                      Colors.red,
                    ),
                    const SizedBox(height: 12),
                    
                    _buildDetailItem(
                      'Телефон',
                      institution['phone'],
                      HugeIcons.strokeRoundedCall,
                      Colors.green,
                    ),
                    const SizedBox(height: 20),
                    
                    // Statistics
                    Text(
                      'Статистика',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Рейтинг',
                            institution['rating'].toString(),
                            HugeIcons.strokeRoundedStar,
                            Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            institution['category'] == 'Детские сады' ? 'Детей' : 
                            institution['category'] == 'Кружки' ? 'Участников' : 'Студентов',
                            institution['students'].toString(),
                            HugeIcons.strokeRoundedUser,
                            Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    _buildStatCard(
                      'Тип учреждения',
                      institution['type'],
                      HugeIcons.strokeRoundedInformationCircle,
                      institution['type'] == 'Государственный' || institution['type'] == 'Государственная' || institution['type'] == 'Автономная'
                          ? Colors.green
                          : Colors.orange,
                    ),
                    const SizedBox(height: 30),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Handle call action
                            },
                            icon: const Icon(
                              HugeIcons.strokeRoundedCall,
                              size: 18,
                            ),
                            label: const Text('Позвони��ь'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF2196F3),
                              side: const BorderSide(color: Color(0xFF2196F3)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Handle map action
                            },
                            icon: const Icon(
                              HugeIcons.strokeRoundedLocation01,
                              size: 18,
                            ),
                            label: const Text('На карте'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2196F3),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}