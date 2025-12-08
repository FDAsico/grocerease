import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'list.dart';
import 'profile.dart';
import 'ListsOnlyPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _personalLists = [];
  final List<Map<String, dynamic>> _groupLists = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadLists();
  }

  Future<void> loadLists() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final data = await Supabase.instance.client
        .from('grocery_lists')
        .select()
        .eq('user_id', user.id);

    setState(() {
      _personalLists.clear();
      for (var item in data) {
        _personalLists.add({
          'id': item['id'],
          'title': item['name'],
          'private': item['is_private'],
          'progress': 0.0,
        });
      }
    });

    final groupData = await Supabase.instance.client
        .from('group_lists')
        .select('invite_code')
        .eq('user_id', user.id);

    setState(() {
      _groupLists.clear();
      for (var item in groupData) {
        _groupLists.add({
          'id': item['invite_code'],
          'title': 'Group List (${item['invite_code']})',
          'joinedCode': item['invite_code'],
          'progress': 0.0,
        });
      }
    });
  }

  void _showNewListDialog() {
    final TextEditingController nameCtrl = TextEditingController();
    bool isPrivate = true;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFD1FBF2),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: StatefulBuilder(
              builder: (context, setStateDialog) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create New List',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF139A5A),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'e.g. Weekly groceries',
                        labelText: 'List name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Text(
                          'Privacy:',
                          style: TextStyle(
                            color: Color(0xFF216255),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ChoiceChip(
                          label: const Text('Private'),
                          selected: isPrivate,
                          selectedColor: const Color(0xFF139A5A),
                          labelStyle: TextStyle(
                            color: isPrivate ? Colors.white : Colors.black,
                          ),
                          onSelected: (v) => setStateDialog(() => isPrivate = true),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Shared'),
                          selected: !isPrivate,
                          selectedColor: const Color(0xFF139A5A),
                          labelStyle: TextStyle(
                            color: !isPrivate ? Colors.white : Colors.black,
                          ),
                          onSelected: (v) => setStateDialog(() => isPrivate = false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF139A5A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(const Color(0xFF139A5A)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                          onPressed: () async {
                            final name = nameCtrl.text.trim();
                            if (name.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter a list name')),
                              );
                              return;
                            }

                            final user = Supabase.instance.client.auth.currentUser;
                            if (user == null) return;

                            await Supabase.instance.client.from('grocery_lists').insert({
                              'user_id': user.id,
                              'name': name,
                              'is_private': isPrivate,
                            });

                            setState(() {
                              _personalLists.add({
                                'id': DateTime.now().toString(),
                                'title': name,
                                'private': isPrivate,
                                'progress': 0.0,
                              });
                            });

                            Navigator.pop(context);
                          },
                          child: const Text('Create'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showJoinListDialog() {
    final TextEditingController codeCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFD1FBF2),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Join a List',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF139A5A),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Enter invite code to join a group list',
                  style: TextStyle(color: Color(0xFF216255)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: codeCtrl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'e.g. ABC123',
                    labelText: 'Invite code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF139A5A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color(0xFF139A5A)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      onPressed: () {
                        final code = codeCtrl.text.trim();
                        if (code.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a code')),
                          );
                          return;
                        }
                        setState(() {
                          _groupLists.add({
                            'id': code,
                            'title': 'Group List ($code)',
                            'joinedCode': code,
                            'progress': 0.0,
                          });
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Join'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListCard(String title, IconData icon) {
    return Container(
      width: 176,
      height: 114,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Color(0x3F000000), blurRadius: 4, offset: Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(left: 12, top: 12, child: Icon(icon, size: 30, color: const Color(0xFF139A5A))),
          Positioned(
            left: 12,
            bottom: 12,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF4F8E81),
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pathway Extreme',
              ),
            ),
          ),
        ],
      ),
    );
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
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
        } else if (label == 'List') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ListsOnlyPage(
                personalLists: _personalLists,
                groupLists: _groupLists,
              ),
            ),
          );
        }
        else if (label == 'Profile') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
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
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Lists',
                      style: TextStyle(
                        color: Color(0xFF216255),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Pathway Extreme',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _showNewListDialog,
                          child: _buildListCard('New List', Icons.list),
                        ),
                        GestureDetector(
                          onTap: _showJoinListDialog,
                          child: _buildListCard('Join List', Icons.group_add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              if (_personalLists.isNotEmpty || _groupLists.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_personalLists.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'My Created Lists',
                              style: TextStyle(
                                color: Color(0xFF139A5A),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: _personalLists.map(
                                    (l) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ListPage(
                                            listId: l['id'].toString(),
                                            listTitle: l['title'] as String,
                                          ),
                                        ),
                                      );
                                    },
                                    child: _buildProgressCard(
                                      l['title'] as String,
                                      (l['progress'] as double),
                                    ),
                                  ),
                                ),
                              ).toList(),
                            ),
                          ],
                        ),
                      if (_groupLists.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const Text(
                              'Group Lists',
                              style: TextStyle(
                                color: Color(0xFF139A5A),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: _groupLists.map(
                                    (g) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ListPage(
                                            listId: g['id'].toString(),
                                            listTitle: g['title'] as String,
                                          ),
                                        ),
                                      );
                                    },
                                    child: _buildProgressCard(
                                      g['title'] as String,
                                      (g['progress'] as double),
                                    ),
                                  ),
                                ),
                              ).toList(),
                            ),
                          ],
                        ),
                    ],
                  ),
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
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2)),
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
              onTap: () {},
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
