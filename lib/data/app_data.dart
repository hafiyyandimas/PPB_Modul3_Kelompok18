import '../screens/home.dart';

class AppData {
  AppData._internal();

  static final AppData instance = AppData._internal();

  final List<Country> favorites = [];
  final List<Country> history = [];

  bool isFavorite(Country country) {
    return favorites.any((c) => c.name == country.name);
  }

  void toggleFavorite(Country country) {
    if (isFavorite(country)) {
      favorites.removeWhere((c) => c.name == country.name);
    } else {
      favorites.add(country);
    }
  }

  void addHistory(Country country) {
    history.removeWhere((c) => c.name == country.name);
    history.insert(0, country);
  }

  void removeHistory(Country country) {
    history.removeWhere((c) => c.name == country.name);
  }

  void clearHistory() {
    history.clear();
  }
}