import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile.dart';
import 'home.dart';
import 'ListsOnlyPage.dart';

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
                  hintText: "e.g., Milk",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ),
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
                  hintText: "e.g., 2",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ),
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
  final String listId;
  final String listTitle;

  const ListPage({super.key, required this.listId, required this.listTitle});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final supabase = Supabase.instance.client;
  int _selectedIndex = 1;
  List<Map<String, dynamic>> items = [];
  String selectedCategoryTab = 'All items';
  late String currentListId;

  @override
  void initState() {
    super.initState();
    currentListId = widget.listId;
    _loadItems();
  }

  Future<void> _loadItems() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from('grocery_items')
        .select()
        .eq('user_id', user.id)
        .eq('list_id', currentListId);

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
      'list_id': currentListId,
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
      appBar: AppBar(title: Text(widget.listTitle,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
      ),),),
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
                ]
                    .map(
                      (c) => GestureDetector(
                    onTap: () => setState(() => selectedCategoryTab = c),
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedCategoryTab == c
                            ? Color(0xFF139A5A)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          c,
                          style: TextStyle(
                              color: selectedCategoryTab == c
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 28),
                children: [
                  if (toGetItems.isNotEmpty)
                    ...toGetItems.map(
                          (i) => Card(
                        child: ListTile(
                          title: Text(i['name']),
                          subtitle: Text(i['category']),
                          trailing: Checkbox(
                            value: i['bought'] ?? false,
                            onChanged: (v) => _updateBought(i, v),
                          ),
                        ),
                      ),
                    ),
                  if (completedItems.isNotEmpty)
                    ...completedItems.map(
                          (i) => Card(
                        color: Color(0xFFD9D9D9),
                        child: ListTile(
                          title: Text(i['name']),
                          subtitle: Text(i['category']),
                          trailing: Checkbox(
                            value: i['bought'] ?? false,
                            onChanged: (v) => _updateBought(i, v),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
