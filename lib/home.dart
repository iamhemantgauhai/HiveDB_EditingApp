import 'package:editing_app/search.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _items = [];
  final _storeBox = Hive.box('store_box');
  @override
  void initState() {
    super.initState();
    _refreshItems();
  }
  void _refreshItems() {
    final data = _storeBox.keys.map((key) {
      final value = _storeBox.get(key);
      return {"key": key, "name": value["name"], "number": value['number']};
    }).toList();
    setState(() {
      _items = data.reversed.toList();
    });
  }
  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _storeBox.add(newItem);
    _refreshItems();
  }
  // ignore: unused_element
  Map<String, dynamic> _readItem(int key) {
    final item = _storeBox.get(key);
    return item;
  }
  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _storeBox.put(itemKey, item);
    _refreshItems();
  }
  Future<void> _deleteItem(int itemKey) async {
    await _storeBox.delete(itemKey);
    _refreshItems();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An item has been deleted')));
  }
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  Future<void> _clearAll() async {
    await _storeBox.clear();
    _refreshItems();
  }
  void _showForm(BuildContext ctx, int? itemKey) async {
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      _nameController.text = existingItem['name'];
      _numberController.text = existingItem['number'];
    }
    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'number'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (itemKey == null) {
                        _createItem({
                          "name": _nameController.text,
                          "number": _numberController.text
                        });
                      }
                      if (itemKey != null) {
                        _updateItem(itemKey, {
                          'name': _nameController.text.trim(),
                          'number': _numberController.text.trim()
                        });
                      }
                      _nameController.text = '';
                      _numberController.text = '';
                      Navigator.of(context).pop();
                    },
                    child: Text(itemKey == null ? 'Create New' : 'Update'),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Multiplier')),
        ),
        body: _items.isEmpty
            ? const Center(
                child: Text(
                  'No Data',
                  style: TextStyle(fontSize: 30),
                ),
              )
            : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (_, index) {
                  final currentItem = _items[index];
                  return Card(
                    shadowColor: Colors.orange,
                    color: Colors.orange.shade100,
                    margin: const EdgeInsets.all(10),
                    elevation: 3,
                    child: ListTile(
                        title: Text(currentItem['name']),
                        subtitle: Text(currentItem['number'].toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.teal,
                                ),
                                onPressed: () =>
                                    _showForm(context, currentItem['key'])),
                            IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _deleteItem(currentItem['key'])),
                          ],
                        )),
                  );
                }),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
                heroTag: 'btn1',
                backgroundColor: Colors.orange,
                onPressed: () => _showForm(context, null),
                child: const Icon(Icons.add)),
            FloatingActionButton(
                heroTag: 'btn2',
                backgroundColor: Colors.red,
                onPressed: () => _clearAll(),
                child: const Icon(Icons.close)),
            FloatingActionButton(
                heroTag: 'btn3',
                backgroundColor: Colors.purple,
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext ctx) =>
                              const SearchEngineOption()));
                },
                child: const Icon(Icons.near_me)),
          ],
        ));
  }
}
