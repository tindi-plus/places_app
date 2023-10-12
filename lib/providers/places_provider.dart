import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:places_app/helpers/db_helper.dart';
import 'package:places_app/helpers/location_helper.dart';

import '../models/place.dart';

class PlacesProvider with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void setPlaces(List<Place> places) {
    _items = places;
  }

  Place findById(String id) {
    return items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(String pickedTitle, File pickedImage,
      PlaceLocation pickedLocation) async {
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updatedLocation = PlaceLocation(
        longitude: pickedLocation.latitude,
        latitude: pickedLocation.latitude,
        address: address);
    final newPlace = Place(
      id: DateTime.now().toIso8601String(),
      image: pickedImage,
      location: updatedLocation,
      title: pickedTitle,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert(
      'places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'loc_lat': newPlace.location!.latitude,
        'loc_lng': newPlace.location!.longitude,
        'address': newPlace.location!.address!,
      },
    );
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('places');

    _items = dataList
        .map(
          (item) => Place(
              id: item['id'],
              image: File(item['image']),
              location: PlaceLocation(
                  latitude: item['loc_lat'],
                  longitude: item['loc_lng'],
                  address: item['address']),
              title: item['title']),
        )
        .toList();

    notifyListeners();
  }
}
