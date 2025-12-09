import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'list.dart';
import 'homepage.dart';
import 'profile.dart';

class ListsOnlyPage extends StatefulWidget {
  final List<Map<String, dynamic>> personalLists;
  final List<Map<String, dynamic>> groupLists;

  const ListsOnlyPage({
    super.key,
    this.personalLists = const [],
    this.groupLists = const [],
  });

  @override
  State<ListsOnlyPage> createState() => _ListsOnlyPageState();
}

class _ListsOnlyPageState extends State<ListsOnlyPage> {
  late List<Map<String, dynamic>> _personalLists;
  late List<Map<String, dynamic>> _groupLists;

  @override
  void initState() {
    super.initState();
    _personalLists = List<Map<String, dynamic>>.from(widget.personalLists);
    _groupLists = List<Map<String, dynamic>>.from(widget.groupLists);
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
        .eq('user_id', user.id);

    setState(() {
      _personalLists.clear();
      for (var item in personalData) {
        _personalLists.add({
          'id': item['id'],
          'title': item['name'],
          'private': item['is_private'],
          'progress': 0.0,
        });
      }

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
                                  builder: (context) => ListPage(
                                    listId: l['id'].toString(),
                                    listTitle: l['title'],
                                  ),
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
                                  builder: (context) => ListPage(
                                    listId: g['id'].toString(),
                                    listTitle: g['title'],
                                  ),
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
    );
  }
}
