import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile.dart';
import 'home.dart';
import 'list.dart';

class AddItemDialog extends StatefulWidget {
  final Function(String name, String category, String quantity) onAdd;

  const AddItemDialog({super.key, required this.onAdd});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController quantityCtrl = TextEditingController();
  String selectedCategory = 'All items';
  final List<String> categories = [
    'All items',
    'Dairy',
    'Produce',
    'Snacks',
    'Beverages'
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: BorderSide(color: Color(0xFF4F8E81), width: 3),
      ),
      child: Container(
        width: 320,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              "Add Item",
              style: TextStyle(
                color: Color(0xFF4F8E81),
                fontSize: 25,
                fontWeight: FontWeight.w800,
                fontFamily: 'Pathway Extreme',
              ),
            ),
            SizedBox(height: 20),

            // Item Name
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Item Name",
                style: TextStyle(
                    color: Color(0xFF139A5A),
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 15),
              decoration: _boxDeco(),
              child: TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintText: "e.g., Milk", // example input
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ),

            // Category
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Category",
                style: TextStyle(
                    color: Color(0xFF139A5A),
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 15),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: _boxDeco(),
              child: DropdownButton<String>(
                value: selectedCategory,
                isExpanded: true,
                underline: SizedBox(),
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => selectedCategory = val);
                },
              ),
            ),

            // Quantity
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Quantity",
                style: TextStyle(
                    color: Color(0xFF139A5A),
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 20),
              decoration: _boxDeco(),
              child: TextField(
                controller: quantityCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintText: "e.g., 2", // example input
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ),

            // Add button
            GestureDetector(
              onTap: () async {
                if (nameCtrl.text.trim().isNotEmpty &&
                    quantityCtrl.text.trim().isNotEmpty) {
                  await widget.onAdd(
                      nameCtrl.text.trim(),
                      selectedCategory,
                      quantityCtrl.text.trim());
                  Navigator.pop(context);
                }
              },
              child: Container(
                width: 130,
                height: 35,
                decoration: BoxDecoration(
                  color: Color(0xFFFA8801),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4))
                  ],
                ),
                child: Center(
                  child: Text(
                    "Add",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDeco() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
            color: Color(0x3F000000), blurRadius: 4, offset: Offset(0, 4)),
      ],
    );
  }
}


class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final supabase = Supabase.instance.client;
  int _selectedIndex = 1;
  List<Map<String, dynamic>> items = [];
  String selectedCategoryTab = 'All items';

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from('grocery_items')
        .select()
        .eq('user_id', user.id);

    setState(() {
      items = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> _addItem(String name, String cat, String quantity) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final inserted = await supabase
        .from('grocery_items')
        .insert({
      'name': name,
      'category': cat,
      'quantity': quantity,
      'bought': false,
      'user_id': user.id,
    })
        .select()
        .single();

    setState(() {
      items.add(inserted);
    });
  }

  Future<void> _updateBought(Map<String, dynamic> item, bool? bought) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase
        .from('grocery_items')
        .update({'bought': bought})
        .eq('user_id', user.id)
        .eq('id', item['id']);

    setState(() {
      item['bought'] = bought;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = selectedCategoryTab == 'All items'
        ? items
        : items.where((i) => i['category'] == selectedCategoryTab).toList();

    final toGetItems =
    filteredItems.where((i) => !(i['bought'] ?? false)).toList();
    final completedItems =
    filteredItems.where((i) => i['bought'] ?? false).toList();

    return Scaffold(
      backgroundColor: Color(0xFFD1FBF2),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddItemDialog(
              onAdd: _addItem,
            ),
          ).then((_) => _loadItems());
        },
        backgroundColor: Color(0xFFFA8801),
        child: Icon(Icons.add, size: 36),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16),
              child: Row(
                children: const [
                  Text('Grocer',
                      style: TextStyle(
                          color: Color(0xFF4E8E81),
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins')),
                  Text('Ease',
                      style: TextStyle(
                          color: Color(0xFFFA8801),
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Weekly Groceries',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  'All items',
                  'Dairy',
                  'Produce',
                  'Snacks',
                  'Beverages'
                ].map((tab) {
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedCategoryTab = tab);
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 12),
                      padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedCategoryTab == tab
                            ? Color(0xFF4F8E81).withOpacity(0.3)
                            : Color(0x4FA0DDD1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          tab,
                          style: TextStyle(
                              color: Color(0xFF4F8E81),
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 28),
                children: [
                  Text('To Get',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ...toGetItems.map(
                        (i) => CheckboxListTile(
                      title: Text(i['name']),
                      subtitle: Text('${i['category']} - ${i['quantity']}'),
                      value: i['bought'],
                      onChanged: (v) => _updateBought(i, v),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Completed',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ...completedItems.map(
                        (i) => CheckboxListTile(
                      title: Text(i['name']),
                      subtitle: Text('${i['category']} - ${i['quantity']}'),
                      value: i['bought'],
                      onChanged: (v) => _updateBought(i, v),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                _navItem(Icons.favorite, 'Favorites', 2),
                _navItem(Icons.person, 'Profile', 3),
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

  Widget _navItem(IconData icon, String label, int index) {
    final bool active = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);

        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomePage()));
        }else if (index == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ListPage()));
        }else if (index == 3) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ProfilePage()));
        } else if (index != 1) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("This page is not available yet")));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: active ? Color(0xFF139A5A) : Colors.grey),
          Text(label,
              style: TextStyle(
                  color: active ? Color(0xFF139A5A) : Colors.grey, fontSize: 11))
        ],
      ),
    );
  }
}