import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:places_app/providers/places_provider.dart';
import 'package:places_app/screens/add_place_screen.dart';
import 'package:places_app/screens/map_screen.dart';
import 'package:places_app/screens/place_detail_screen.dart';
import 'package:places_app/screens/places_list_screen.dart';
import 'package:provider/provider.dart';

import 'models/place.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlacesProvider(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Places App',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          colorScheme: ColorScheme.fromSwatch(
            accentColor: Colors.amber,
          ),
          brightness: Brightness.light,
        ),
        routerConfig: _router,
      ),
    );
  }
}

GoRouter _router = GoRouter(routes: [
  GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => PlacesListScreen(),
      routes: [
        GoRoute(
          name: 'add_place',
          path: 'add_place',
          builder: (context, state) => AddPlaceScreen(),
        ),
        GoRoute(
          name: 'place_detail',
          path: 'place_detail',
          builder: (context, state) =>
              PlaceDetailScreen(place: state.extra as Place),
        ),
        GoRoute(
            name: 'map_screen',
            path: 'map_screen',
            builder: (context, state) {
              Map<String, dynamic> args = state.extra as Map<String, dynamic>;
              return MapScreen(
                initialLocation: args['location'] as PlaceLocation,
                isSelecting: args['isSelecting'] as bool,
              );
            }),
      ]),
]);
