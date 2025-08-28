class Pharmacy {
  final String id;
  final String name;
  final String address;
  final double rating;
  final double distance;
  final String phone;
  final bool isOpen;
  final List<Medicine> medicines;

  Pharmacy({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.distance,
    required this.phone,
    required this.isOpen,
    required this.medicines,
  });
}

class Medicine {
  final String id;
  final String name;
  final double price;
  final String description;
  final bool inStock;
  final String category;

  Medicine({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.inStock,
    required this.category,
  });
}