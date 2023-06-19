import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class googleMap extends StatefulWidget {
  const googleMap({super.key});

  @override
  State<googleMap> createState() => _googleMapState();
}

class _googleMapState extends State<googleMap> {
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(39.91742 , 41.23568), zoom: 14);

  Set<Marker> markers = {};

  void _addMarkers() {
    setState(() {
      markers.add(
        const Marker(
          markerId: MarkerId('marker1'),
          position: LatLng(39.90467 , 41.26177),
          infoWindow: InfoWindow(
            title: 'Erzurum Büyükşehir Belediyesi',
            snippet: 'Kart Dolum Merkezi',
          ),
        ),
      );
      markers.add(
        const Marker(
          markerId: MarkerId('marker2'),
          position: LatLng(39.905643711033285, 41.265708477663374),
          infoWindow: InfoWindow(
            title: 'Havuzbaşı',
            snippet: 'Kart Dolum Noktası',
          ),
        ),
      );

      markers.add(
        const Marker(
          markerId: MarkerId('marker3'),
          position: LatLng(39.911801463729184, 41.2509645385728),
          infoWindow: InfoWindow(
            title: 'MNG Avm',
            snippet: 'Kart Dolum Noktası',
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

   @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kart Dolum Merkezleri"),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: true,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await _determinePosition();

          googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));


          markers.clear();

          markers.add(Marker(markerId: const MarkerId('currentLocation'),position: LatLng(position.latitude, position.longitude)));

          //setState(() {});

        },
        label: const Text("Mevcut Konum"),
        icon: const Icon(Icons.location_history),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled){
      return Future.error('Konum hizmetleri devre dışı');
    }

    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if(permission == LocationPermission.denied) {
        return Future.error('Konum izni reddedildi');
      }
    }

    if(permission == LocationPermission.deniedForever){
      return Future.error('Konum izinleri kalıcı olarak reddedildi');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;

  }
}