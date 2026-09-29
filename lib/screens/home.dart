import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'detail.dart';
import '../data/app_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Country>> countries;
  String _searchQuery = '';
  bool? _sortAscending;

  @override
  void initState() {
    super.initState();
    countries = fetchCountries();
  }

  Future<List<Country>> fetchCountries() async {
    final uri = Uri.parse('https://www.apicountries.com/countries');
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();
    if (response.statusCode == 200) {
      final respBody = await response.transform(utf8.decoder).join();
      final List jsonData = jsonDecode(respBody);
      return jsonData.map((j) => Country.fromJson(j)).toList();
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }

  List<Country> _applyFilterAndSort(List<Country> source) {
    var result = source;

    if (_searchQuery.isNotEmpty) {
      result = result
          .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_sortAscending != null) {
      result = [...result];
      result.sort((a, b) => _sortAscending!
          ? a.region.compareTo(b.region)
          : b.region.compareTo(a.region));
    }

    return result;
  }

  void _toggleSort() {
    setState(() {
      _sortAscending = switch (_sortAscending) {
        null => true,
        true => false,
        false => null,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        actions: [
          IconButton(
            onPressed: _toggleSort,
            tooltip: 'Sort berdasarkan benua',
            icon: Icon(
              _sortAscending == true
                  ? Icons.arrow_upward
                  : _sortAscending == false
                      ? Icons.arrow_downward
                      : Icons.sort,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Cari negara...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Country>>(
              future: countries,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No countries found'));
                }

                final list = _applyFilterAndSort(snapshot.data!);

                if (list.isEmpty) {
                  return const Center(child: Text('Negara tidak ditemukan'));
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final country = list[i];
                    return Card(
                      child: ListTile(
                        leading: country.flagsPng != null
                            ? Image.network(country.flagsPng!, width: 50)
                            : const SizedBox(width: 50),
                        title: Text(country.name),
                        subtitle: Text(country.region),
                        trailing: IconButton(
                          icon: Icon(
                            AppData.instance.isFavorite(country)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: AppData.instance.isFavorite(country)
                                ? Colors.red
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              AppData.instance.toggleFavorite(country);
                            });
                          },
                        ),
                        onTap: () {
                          AppData.instance.addHistory(country);
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Country {
  final String name;
  final String region;
  final String? capital;
  final int population;
  final String? flagsPng;
  final List<dynamic>? languages;
  final List<dynamic>? currencies;

  Country({
    required this.name,
    required this.region,
    required this.population,
    this.capital,
    this.flagsPng,
    this.languages,
    this.currencies,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    List<dynamic>? langs;
    if (json['languages'] != null) {
      langs = (json['languages'] as List)
          .map((l) => l['name'].toString())
          .toList();
    }

    List<dynamic>? cur;
    if (json['currencies'] != null) {
      cur = (json['currencies'] as List)
          .map((c) => c['name'].toString())
          .toList();
    }

    return Country(
      name: json['name'] ?? 'N/A',
      region: json['region'] ?? 'N/A',
      population: json['population'] ?? 0,
      capital: json['capital'],
      flagsPng: json['flags'] != null ? json['flags']['png'] : null,
      languages: langs,
      currencies: cur,
    );
  }
}
