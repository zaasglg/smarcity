import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../models/pharmacy.dart';

class PharmacyPage extends StatefulWidget {
  const PharmacyPage({super.key});

  @override
  State<PharmacyPage> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Pharmacy> _pharmacies = [];
  List<Pharmacy> _filteredPharmacies = [];

  @override
  void initState() {
    super.initState();
    _loadPharmacies();
    _searchController.addListener(_filterPharmacies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadPharmacies() {
    // Mock data for demonstration
    _pharmacies = [
      Pharmacy(
        id: '1',
        name: 'Аптека "Здоровье"',
        address: 'ул. Абая, 45',
        rating: 4.5,
        distance: 0.3,
        phone: '+7 (777) 123-45-67',
        isOpen: true,
        medicines: [
          Medicine(
            id: '1',
            name: 'Парацетамол',
            price: 250.0,
            description: 'Жаропонижающее средство',
            inStock: true,
            category: 'Обезболивающие',
          ),
          Medicine(
            id: '2',
            name: 'Аспирин',
            price: 180.0,
            description: 'Противовоспалительное средство',
            inStock: true,
            category: 'Обезболивающие',
          ),
          Medicine(
            id: '3',
            name: 'Витамин C',
            price: 450.0,
            description: 'Укрепляет иммунитет',
            inStock: false,
            category: 'Витамины',
          ),
        ],
      ),
      Pharmacy(
        id: '2',
        name: 'Фармация "Медикум"',
        address: 'пр. Назарбаева, 12',
        rating: 4.2,
        distance: 0.7,
        phone: '+7 (777) 234-56-78',
        isOpen: true,
        medicines: [
          Medicine(
            id: '4',
            name: 'Ибупрофен',
            price: 320.0,
            description: 'Противовоспалительное средство',
            inStock: true,
            category: 'Обезболивающие',
          ),
          Medicine(
            id: '5',
            name: 'Амоксициллин',
            price: 680.0,
            description: 'Антибиотик широкого спектра',
            inStock: true,
            category: 'Антибиотики',
          ),
        ],
      ),
      Pharmacy(
        id: '3',
        name: 'Аптека "Фармленд"',
        address: 'ул. Толе би, 78',
        rating: 4.8,
        distance: 1.2,
        phone: '+7 (777) 345-67-89',
        isOpen: false,
        medicines: [
          Medicine(
            id: '6',
            name: 'Омепразол',
            price: 520.0,
            description: 'Для лечения язвы желудка',
            inStock: true,
            category: 'Желудочно-кишечные',
          ),
          Medicine(
            id: '7',
            name: 'Лоратадин',
            price: 280.0,
            description: 'Антигистаминное средство',
            inStock: true,
            category: 'Антигистаминные',
          ),
        ],
      ),
      Pharmacy(
        id: '4',
        name: 'Аптека "Эвалар"',
        address: 'ул. Кунаева, 23',
        rating: 4.0,
        distance: 1.8,
        phone: '+7 (777) 456-78-90',
        isOpen: true,
        medicines: [
          Medicine(
            id: '8',
            name: 'Цитрамон',
            price: 150.0,
            description: 'От головной боли',
            inStock: true,
            category: 'Обезболивающие',
          ),
          Medicine(
            id: '9',
            name: 'Мукалтин',
            price: 95.0,
            description: 'От кашля',
            inStock: true,
            category: 'Противокашлевые',
          ),
        ],
      ),
    ];
    _filteredPharmacies = _pharmacies;
  }

  void _filterPharmacies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPharmacies = _pharmacies.where((pharmacy) {
        return pharmacy.name.toLowerCase().contains(query) ||
            pharmacy.address.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(HugeIcons.strokeRoundedArrowLeft01, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Аптеки рядом',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Colors.grey),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск аптек...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(
                  HugeIcons.strokeRoundedSearch01,
                  color: Colors.grey[400],
                  size: 20,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[400], size: 18),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          // Pharmacy list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredPharmacies.length,
              itemBuilder: (context, index) {
                final pharmacy = _filteredPharmacies[index];
                return _buildPharmacyCard(pharmacy);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPharmacyCard(Pharmacy pharmacy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and status
            Row(
              children: [
                Expanded(
                  child: Text(
                    pharmacy.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: pharmacy.isOpen ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    pharmacy.isOpen ? 'Открыто' : 'Закрыто',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Address
            Row(
              children: [
                const Icon(
                  HugeIcons.strokeRoundedLocation01,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    pharmacy.address,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Rating and distance
            Row(
              children: [
                // Rating
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      pharmacy.rating.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Distance
                Row(
                  children: [
                    const Icon(
                      HugeIcons.strokeRoundedRoute01,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${pharmacy.distance} км',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Phone
                IconButton(
                  icon: const Icon(
                    HugeIcons.strokeRoundedCall,
                    color: Color(0xFFE95A7B),
                  ),
                  onPressed: () {
                    _showPhoneDialog(pharmacy.phone);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            // View Medicines button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showMedicinesBottomSheet(pharmacy);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDB5B2B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Посмотреть лекарства',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhoneDialog(String phone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Телефон аптеки'),
        content: Text(phone),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Here you would implement actual phone calling
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Звонок на $phone')),
              );
            },
            child: const Text('Позвонить'),
          ),
        ],
      ),
    );
  }

  void _showMedicinesBottomSheet(Pharmacy pharmacy) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Header
              Text(
                pharmacy.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Доступные лекарства',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              // Medicines list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: pharmacy.medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = pharmacy.medicines[index];
                    return _buildMedicineCard(medicine);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineCard(Medicine medicine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: medicine.inStock ? Colors.grey.shade200 : Colors.red.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      medicine.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      medicine.category,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${medicine.price.toStringAsFixed(0)} ₸',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE95A7B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: medicine.inStock ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      medicine.inStock ? 'В наличии' : 'Нет в наличии',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: medicine.inStock
                  ? () {
                      _orderMedicine(medicine);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: medicine.inStock
                    ? const Color(0xFFDB5B2B)
                    : Colors.grey[300],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                medicine.inStock ? 'Заказать' : 'Недоступно',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _orderMedicine(Medicine medicine) {
    Navigator.pop(context); // Close bottom sheet
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Заказ лекарства'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Лекарство: ${medicine.name}'),
            Text('Цена: ${medicine.price.toStringAsFixed(0)} ₸'),
            const SizedBox(height: 16),
            const Text('Ваш заказ будет готов через 30 минут.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Заказ на ${medicine.name} оформлен!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDB5B2B),
              foregroundColor: Colors.white,
            ),
            child: const Text('Подтвердить заказ'),
          ),
        ],
      ),
    );
  }
}