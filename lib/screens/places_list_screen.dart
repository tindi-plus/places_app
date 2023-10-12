import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:places_app/providers/places_provider.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
              onPressed: () {
                context.pushNamed('add_place');
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<PlacesProvider>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
            //if (snapshot.connectionState == ConnectionState.done)
          } else {
            return Consumer<PlacesProvider>(
              builder: (context, places, child) {
                if (places.items.isEmpty) {
                  return child!;
                } else {
                  return ListView.builder(
                    itemCount: places.items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: FileImage(places.items[index].image),
                        ),
                        title: Text(places.items[index].title),
                        subtitle: Text(places.items[index].location!.address!),
                        onTap: () {
                          context.goNamed('place_detail', extra: places.items[index],);
                        },
                      );
                    },
                  );
                }
              },
              child: Center(
                child: const Text('Got no places yet, start adding some!'),
              ),
            );
          }
        },
      ),
    );
  }
}
