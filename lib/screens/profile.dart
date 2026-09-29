import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? onHomeTap;

  const ProfilePage({super.key, this.onHomeTap});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Map<String, String>> teamMembers = [
    {
      'Nama': 'Hafiyyan Dimas Walana',
      'NIM': '21120124140130',
      'Foto': 'assets/01.jpg',
    },
    {
      'Nama': 'Rafi Muhammad Arsyad',
      'NIM': '21120124130064',
      'Foto': 'assets/02.jpg',
    },
    {
      'Nama': 'Muhammad Dzakwan Fakhriy Habibie',
      'NIM': '21120120140134',
      'Foto': 'assets/03.jpg',
    },
    {
      'Nama': 'Geihansyah Lisdianov Marjanto',
      'NIM': '21120122140152',
      'Foto': 'assets/04.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 13, 105, 225),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: widget.onHomeTap,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: FractionallySizedBox(
              alignment: Alignment.topCenter,
              heightFactor: 0.45,
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    image: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsNkWPWepcYoXtPoLxUKgWl_htrmm47Xx2kJmuX2yRIg&s=10',
                    ),
                  ),
                  color: const Color.fromARGB(255, 255, 252, 252)
                      .withValues(alpha: 128),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.52),
                  const Text(
                    'KELOMPOK 18',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  for (var member in teamMembers)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: AssetImage(member['Foto']!),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member['Nama'] ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                member['NIM'] ?? 'No NIM',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}