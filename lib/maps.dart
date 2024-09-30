import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart'; // Certifique-se de que o pacote 'location' esteja incluído no pubspec.yaml
import 'package:http/http.dart' as http;
import 'package:openstreetmap/search_bar.dart';
import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  LocationData? currentLocation; // Variável para armazenar a localização atual
  List<LatLng> routePoints = [];
  List<Marker> markers = [];
  final String orsApiKey =
      '5b3ce3597851110001cf62482de52b26a17748bf9c899b9b2555e74b'; // Substitua pela sua API Key do OpenRouteService

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Chama a função que obtém a localização ao iniciar
  }

  // Obtém a localização atual do usuário
  Future<void> _getCurrentLocation() async {
    var location = Location();

    // Verifica se o serviço de localização está habilitado e se o app tem permissões
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Obtém a localização atual
    try {
      var userLocation = await location.getLocation();
      setState(() {
        currentLocation = userLocation;
        // Move o mapa para a localização atual
        mapController.move(
          LatLng(userLocation.latitude!, userLocation.longitude!),
          15.0, // Nível de zoom inicial
        );
      });
    } on Exception {
      currentLocation = null;
    }

    // Ouve as alterações na localização e atualiza a posição do mapa
    location.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        currentLocation = newLocation;
      });
    });
  }

  // Obtém a rota entre dois pontos
  Future<void> _getRoute(LatLng destination) async {
    if (currentLocation == null) return;

    final start =
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
    final response = await http.get(
      Uri.parse(
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$orsApiKey&start=${start.longitude},${start.latitude}&end=${destination.longitude},${destination.latitude}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coords =
          data['features'][0]['geometry']['coordinates'];
      setState(() {
        routePoints =
            coords.map((coord) => LatLng(coord[1], coord[0])).toList();
        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: destination,
            child: const Icon(Icons.location_on, color: Colors.red, size: 40.0),
          ),
        );
      });
    } else {
      print('Falha ao buscar a rota');
    }
  }

  // Adiciona um marcador no mapa

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: currentLocation != null
                  ? LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!)
                  : LatLng(0.0,
                      0.0), // Centraliza em 0.0, 0.0 até obter a localização
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png", // Usar subdomínio correto
                subdomains: const [], // Remove subdomínios
              ),
              MarkerLayer(
                markers: markers,
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routePoints,
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),
            ],
          ),
          // Barra de busca sobre o mapa
          Positioned(
            top: 60.0,
            left: 10.0,
            right: 10.0,
            child: CustomSearchBar(),
          ),
        ],
      ),
      // Botão para centralizar o mapa na localização atual do usuário
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentLocation != null) {
            mapController.move(
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
              15.0,
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
