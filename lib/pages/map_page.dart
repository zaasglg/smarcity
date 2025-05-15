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
  // Қызылорда қаласының координаталары
  static const LatLng _qyzylordaCenter = LatLng(44.8485, 65.4991);

  // GoogleMap контроллер
  GoogleMapController? _mapController;

  // Карта маркерлері
  final Set<Marker> _markers = {};

  // Локация типтері
  final List<LocationType> _locationTypes = [
    LocationType(
      name: 'ЦОН',
      icon: Icons.account_balance,
      color: Colors.blue,
      query: 'ЦОН+Қызылорда',
    ),
    LocationType(
      name: 'АвтоЦОН',
      icon: Icons.directions_car,
      color: Colors.green,
      query: 'АвтоЦОН+Қызылорда',
    ),
    LocationType(
      name: 'МФЦ',
      icon: Icons.business_center,
      color: Colors.orange,
      query: 'Многофункциональный+центр+Кызылорда',
    ),
    LocationType(
      name: 'Әкімдік',
      icon: Icons.account_balance,
      color: Colors.red,
      query: 'Акимат+Кызылорда',
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
        _mapErrorMessage = 'Карта әлі жүктелмеді. Қайталап көріңіз';
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
            _mapErrorMessage = 'Деректер жүктелмеді: ${data['status']}';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _mapErrorMessage = 'Сервер қателігі: ${response.statusCode}';
        });
      }
    } catch (e) {
      debugPrint('Error loading places: $e');
      setState(() {
        _isLoading = false;
        _mapErrorMessage = 'Қосылым қателігі: $e';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          _selectedLocationType.isEmpty
              ? 'Қызылорда қаласы'
              : '$_selectedLocationType мекемелері',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Картаны қайта жүктеу үшін кнопка қосу
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: () {
              setState(() {
                _mapInitialized = false;
                _mapErrorMessage = '';
              });
              Future.delayed(const Duration(milliseconds: 500), () {
                setState(() {
                  _mapInitialized = true;
                });
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Карта
          Expanded(
            child: Stack(
              children: [
                // Карта көрінісі
                if (_mapInitialized)
                  GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: _qyzylordaCenter,
                      zoom: 13,
                    ),
                    markers: _markers,
                    mapType: MapType.normal,
                    zoomControlsEnabled: false,
                    compassEnabled: true,
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
                  )
                else
                // Картаны жүктеу анимациясы
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Карта жүктелуде...'),
                      ],
                    ),
                  ),

                // Жүктеу индикаторы
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),

                // Қате хабарлама көрсету
                if (_mapErrorMessage.isNotEmpty)
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _mapErrorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
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
                            child: const Text('Қайталау'),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Масштабтау батырмалары
                Positioned(
                  right: 16,
                  bottom: 100,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: "zoom_in",
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.add, color: Colors.black87),
                        onPressed: () {
                          if (_mapController != null) {
                            _mapController!.animateCamera(CameraUpdate.zoomIn());
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: "zoom_out",
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.remove, color: Colors.black87),
                        onPressed: () {
                          if (_mapController != null) {
                            _mapController!.animateCamera(CameraUpdate.zoomOut());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Төменгі батырмалар панелі
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 12, left: 16, right: 16, bottom: 8
                  ),
                  child: Text(
                    'Мекеме түрін таңдаңыз',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _locationTypes.length,
                    itemBuilder: (context, index) {
                      final locationType = _locationTypes[index];
                      final bool isSelected =
                          _selectedLocationType == locationType.name;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: LocationButton(
                          name: locationType.name,
                          icon: locationType.icon,
                          color: locationType.color,
                          isSelected: isSelected,
                          onTap: () => _loadPlaces(locationType.query),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: _goToQyzylorda,
        child: const Icon(Icons.location_city),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ]
                  : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 28,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? color : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}