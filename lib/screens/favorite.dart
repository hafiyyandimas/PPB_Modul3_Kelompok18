import 'package:flutter/material.dart';
import '../data/app_data.dart';
import 'detail.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final favorites = AppData.instance.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: favorites.isEmpty
          ? const Center(child: Text('Belum ada negara favorit'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, i) {
                final country = favorites[i];
                return Card(
                  child: ListTile(
                    leading: country.flagsPng != null
                        ? Image.network(country.flagsPng!, width: 50)
                        : const SizedBox(width: 50),
                    title: Text(country.name),
                    subtitle: Text(country.region),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          AppData.instance.toggleFavorite(country);
                        });
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(country: country),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
