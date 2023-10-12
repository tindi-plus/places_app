import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:places_app/helpers/location_helper.dart';
import 'package:places_app/screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  const LocationInput({super.key, required this.onSelectPlace});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageURL;

  void _showPreview(double lat, double lng) async {
    final mapPreviewURL = await LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitude: lng);
    setState(() {
      _previewImageURL = mapPreviewURL;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      // print(locData.latitude);
      _showPreview(locData.latitude!, locData.longitude!);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    } else {
      _showPreview(selectedLocation.latitude, selectedLocation.longitude);
      widget.onSelectPlace(
          selectedLocation.latitude, selectedLocation.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageURL == null
              ? Text(
                  'No Location Chosen.',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageURL!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text('Select Location on Map'),
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ],
    );
  }
}
