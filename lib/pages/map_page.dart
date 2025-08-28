import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Координаты города Туркестан
  static const LatLng _qyzylordaCenter = LatLng(43.2973, 68.2515);

  // Контроллер GoogleMap
  GoogleMapController? _mapController;

  // Маркеры карты
  final Set<Marker> _markers = {};

  // Типы локаций (2GIS style colors)
  final List<LocationType> _locationTypes = [
    LocationType(
      name: 'ЦОН',
      icon: Icons.account_balance_rounded,
      color: const Color(0xFF0066CC), // 2GIS blue
      query: 'ЦОН+Туркестан',
    ),
    LocationType(
      name: 'АвтоЦОН',
      icon: Icons.directions_car_rounded,
      color: const Color(0xFF00A86B), // 2GIS green
      query: 'АвтоЦОН+Туркестан',
    ),
    LocationType(
      name: 'МФЦ',
      icon: Icons.business_center_rounded,
      color: const Color(0xFFFF6B35), // 2GIS orange
      query: 'Многофункциональный+центр+Туркестан',
    ),
    LocationType(
      name: 'Акимат',
      icon: Icons.location_city_rounded,
      color: const Color(0xFFE53E3E), // 2GIS red
      query: 'Акимат+Туркестан',
    ),
  ];

  bool _isLoading = false;
  bool _mapInitialized = false;
  String _selectedLocationType = '';
  String _mapErrorMessage = '';

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  // Google Places API арқылы таңдалған мекеме типтерін жүктеу
  Future<void> _loadPlaces(String query) async {
    if (_mapController == null) {
      setState(() {
        _mapErrorMessage = 'Карта еще не загружена. Попробуйте снова';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _markers.clear();
      _selectedLocationType = query.split('+')[0];
      _mapErrorMessage = '';
    });

    const String apiKey = 'AIzaSyClj1c_4cUAfy2eLD_EramkZTgxKfwx5rA';
    final String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final places = data['results'];

          setState(() {
            for (var place in places) {
              final location = place['geometry']['location'];
              final name = place['name'];
              final address = place['formatted_address'] ?? '';

              _markers.add(
                Marker(
                  markerId: MarkerId(place['place_id']),
                  position: LatLng(location['lat'], location['lng']),
                  infoWindow: InfoWindow(
                    title: name,
                    snippet: address,
                  ),
                ),
              );
            }
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _mapErrorMessage = 'Данные не загружены: ${data['status']}';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _mapErrorMessage = 'Ошибка сервера: ${response.statusCode}';
        });
      }
    } catch (e) {
      debugPrint('Error loading places: $e');
      setState(() {
        _isLoading = false;
        _mapErrorMessage = 'Ошибка соединения: $e';
      });
    }
  }

  // Картаға Қызылорда қаласына өту
  Future<void> _goToQyzylorda() async {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: _qyzylordaCenter,
          zoom: 13,
        ),
      ));
    }
  }

  // Показать bottom sheet с типами локаций (2GIS style)
  void _showLocationTypesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Категории',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const Spacer(),
                  if (_selectedLocationType.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _selectedLocationType = '';
                          _markers.clear();
                        });
                      },
                      child: const Text(
                        'Очистить',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF0066CC),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Categories list (2GIS style)
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _locationTypes.length,
                itemBuilder: (context, index) {
                  final locationType = _locationTypes[index];
                  final bool isSelected = _selectedLocationType == locationType.name;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.pop(context);
                          _loadPlaces(locationType.query);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFE6F2FF) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF0066CC) : const Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? const Color(0xFF0066CC)
                                      : locationType.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  locationType.icon,
                                  color: isSelected 
                                      ? Colors.white 
                                      : locationType.color,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      locationType.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected 
                                            ? const Color(0xFF0066CC)
                                            : const Color(0xFF333333),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _getCategoryDescription(locationType.name),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF666666),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF0066CC),
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Safe area padding
            SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
          ],
        ),
      ),
    );
  }

  // Helper method for category descriptions
  String _getCategoryDescription(String categoryName) {
    switch (categoryName) {
      case 'ЦОН':
        return 'Центры обслуживания населения';
      case 'АвтоЦОН':
        return 'Автомобильные услуги';
      case 'МФЦ':
        return 'Многофункциональные центры';
      case 'Акимат':
        return 'Государственные учреждения';
      default:
        return 'Категория услуг';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Main map area
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _qyzylordaCenter,
              zoom: 13,
            ),
            markers: _markers,
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            compassEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _goToQyzylorda();
            },
            onCameraMove: (_) {
              if (_mapErrorMessage.isNotEmpty) {
                setState(() {
                  _mapErrorMessage = '';
                });
              }
            },
          ),

          // Top search bar (2GIS style)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Back button
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF333333), size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Search bar
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const Icon(Icons.search, color: Color(0xFF999999), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedLocationType.isEmpty
                                  ? 'Поиск мест и адресов'
                                  : _selectedLocationType,
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedLocationType.isEmpty 
                                    ? const Color(0xFF999999)
                                    : const Color(0xFF333333),
                                fontWeight: _selectedLocationType.isEmpty
                                    ? FontWeight.w400
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (_selectedLocationType.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedLocationType = '';
                                  _markers.clear();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: const Icon(Icons.close, color: Color(0xFF999999), size: 16),
                              ),
                            ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2GIS style floating controls (right side)
          Positioned(
            right: 16,
            top: 120,
            child: Column(
              children: [

                SizedBox(height: 10),

                // Layers button
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.layers_outlined, color: Color(0xFF333333), size: 20),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Location button
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.my_location_outlined, color: Color(0xFF333333), size: 20),
                    onPressed: _goToQyzylorda,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),

          // 2GIS style zoom controls (right side bottom)
          Positioned(
            right: 16,
            bottom: 160,
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Color(0xFF333333), size: 20),
                    onPressed: () {
                      if (_mapController != null) {
                        _mapController!.animateCamera(CameraUpdate.zoomIn());
                      }
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
                Container(
                  width: 44,
                  height: 1,
                  color: const Color(0xFFE0E0E0),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove, color: Color(0xFF333333), size: 20),
                    onPressed: () {
                      if (_mapController != null) {
                        _mapController!.animateCamera(CameraUpdate.zoomOut());
                      }
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Card(
                  margin: EdgeInsets.all(32),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Загрузка мест...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Map loading state
          if (!_mapInitialized)
            Container(
              color: const Color(0xFFF0F0F0),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Загрузка карты...',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Error overlay
          if (_mapErrorMessage.isNotEmpty)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Card(
                  margin: const EdgeInsets.all(32),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Color(0xFFE53E3E),
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _mapErrorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0066CC),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _mapErrorMessage = '';
                              _mapInitialized = false;
                            });
                            Future.delayed(const Duration(milliseconds: 500), () {
                              setState(() {
                                _mapInitialized = true;
                              });
                            });
                          },
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // 2GIS style bottom panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 4),
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    
                    // Categories button
                    GestureDetector(
                      onTap: _showLocationTypesBottomSheet,
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.category_outlined,
                              color: Color(0xFF0066CC),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _selectedLocationType.isEmpty
                                    ? 'Категории'
                                    : _selectedLocationType,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _selectedLocationType.isEmpty
                                      ? const Color(0xFF666666)
                                      : const Color(0xFF333333),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_right,
                              color: Color(0xFF999999),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Кодты жүктелгеннен кейін біраз уақыттан соң карта инициализациясын жасау
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _mapInitialized = true;
        });
      }
    });
  }
}

// Мекеме типі класы
class LocationType {
  final String name;
  final IconData icon;
  final Color color;
  final String query;

  LocationType({
    required this.name,
    required this.icon,
    required this.color,
    required this.query,
  });
}

// Мекеме батырмасы виджеті
class LocationButton extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const LocationButton({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color,
                          color.withOpacity(0.8),
                        ],
                      )
                    : null,
                color: isSelected ? null : const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? color.withOpacity(0.3) : const Color(0xFFE1E8ED),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.25),
                          spreadRadius: 0,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : const Color(0xFF2C3E50),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
