import 'package:flutter/material.dart';
import '../data/app_data.dart';
import 'detail.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void _clearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Riwayat'),
        content: const Text(
          'Seluruh riwayat akan dihapus permanen dan tidak bisa dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                AppData.instance.clearHistory();
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = AppData.instance.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        actions: [
          if (history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Hapus semua riwayat',
              onPressed: _clearAll,
            ),
        ],
      ),
      body: history.isEmpty
          ? const Center(child: Text('Belum ada riwayat pencarian'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, i) {
                final country = history[i];
                return Dismissible(
                  key: ValueKey(country.name),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete_forever, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      AppData.instance.removeHistory(country);
                    });
                  },
                  child: Card(
                    child: ListTile(
                      leading: country.flagsPng != null
                          ? Image.network(country.flagsPng!, width: 50)
                          : const SizedBox(width: 50),
                      title: Text(country.name),
                      subtitle: Text(country.region),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(country: country),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
