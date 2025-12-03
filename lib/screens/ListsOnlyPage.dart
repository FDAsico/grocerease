import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'list.dart';
import 'home.dart';
import 'profile.dart';

class ListsOnlyPage extends StatefulWidget {
  const ListsOnlyPage({super.key});

  @override
  State<ListsOnlyPage> createState() => _ListsOnlyPageState();
}

class _ListsOnlyPageState extends State<ListsOnlyPage> {
  final List<Map<String, dynamic>> _personalLists = [];
  final List<Map<String, dynamic>> _groupLists = [];
  int _selectedIndex = 1; // List tab is selected

  @override
  void initState() {
    super.initState();
    loadLists();
  }

  Future<void> loadLists() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final personalData = await Supabase.instance.client
        .from('grocery_lists')
        .select()
        .eq('user_id', user.id);

    final groupData = await Supabase.instance.client
        .from('group_lists')
        .select('invite_code')
        .eq('owner_id', user.id);

    setState(() {
      _personalLists.clear();
      for (var item in personalData) {
        _personalLists.add({
          'title': item['name'],
          'private': item['is_private'],
          'progress': 0.0,
        });
      }

      _groupLists.clear();
      for (var item in groupData) {
        _groupLists.add({
          'title': 'Group List (${item['invite_code']})',
          'joinedCode': item['invite_code'],
          'progress': 0.0,
        });
      }
    });
  }

  Widget _buildProgressCard(String title, double progress) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF139A5A),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              color: const Color(0xFF139A5A),
              backgroundColor: const Color(0xFFD9D9D9),
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);

        if (label == 'Home') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (label == 'List') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ListsOnlyPage()),
          );
        } else if (label == 'Favorites') {
          // No Favorites page yet
        } else if (label == 'Profile') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? const Color(0xFF139A5A) : Colors.grey[600]),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isActive ? const Color(0xFF139A5A) : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD1FBF2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16, left: 18, right: 18, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 20, bottom: 20),
                child: Row(
                  children: const [
                    Text(
                      'Grocer',
                      style: TextStyle(
                        color: Color(0xFF139A5A),
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'Ease',
                      style: TextStyle(
                        color: Color(0xFFFA8801),
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_personalLists.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Created Lists',
                      style: TextStyle(
                        color: Color(0xFF139A5A),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        fontFamily: 'Pathway Extreme',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: _personalLists
                          .map(
                            (l) => Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ListPage(),
                                ),
                              );
                            },
                            child: _buildProgressCard(
                              l['title'] as String,
                              l['progress'] as double,
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              if (_groupLists.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Group Lists',
                      style: TextStyle(
                        color: Color(0xFF139A5A),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        fontFamily: 'Pathway Extreme',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: _groupLists
                          .map(
                            (g) => Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ListPage(),
                                ),
                              );
                            },
                            child: _buildProgressCard(
                              g['title'] as String,
                              g['progress'] as double,
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navItem(Icons.home, 'Home', 0),
                _navItem(Icons.groups, 'List', 1),
                const SizedBox(width: 70),
                _navItem(Icons.favorite, 'Favorites', 3),
                _navItem(Icons.person, 'Profile', 2),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            child: GestureDetector(
              onTap: () {
                // TODO: open barcode scanner here
              },
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF139A5A),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
