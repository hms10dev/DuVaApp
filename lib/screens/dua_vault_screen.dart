import 'package:duva_app/screens/dua_add_edit_screen.dart';
import 'package:duva_app/services/dua_service.dart';
import 'package:duva_app/widgets/dua_card.dart';
import 'package:flutter/material.dart';

class DuaVaultScreen extends StatefulWidget {
  @override
  State<DuaVaultScreen> createState() => _DuaVaultScreenState();
}

class _DuaVaultScreenState extends State<DuaVaultScreen> {
  final DuaService duaService = DuaService();
  List<Map<String, dynamic>> duas = [];
  String? selectedCategory; //holds the selected category
  TextEditingController searchController = TextEditingController();
  String? searchQuery;

  @override
  void initState() {
    super.initState();
    _loadDuas();
  }

  Future<void> _loadDuas() async {
    try {
      final fetchedDuas = await duaService.fetchDuas(searchQuery: searchQuery);
      setState(() {
        duas = fetchedDuas;
      });
    } catch (e) {
      print("Error fetching duas: $e");
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });

    _loadDuas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Duas'),
        backgroundColor: Colors.brown[700],
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      body: Column(
        children: [
          //Search bar
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SearchBar(
              controller: searchController,
              onChanged: _onSearchChanged,
              hintText: "Search Duas...",
            ),
          ),

          //Dua List
          Expanded(
            child: ListView.builder(
              itemCount: duas.length,
              itemBuilder: (context, index) {
                final dua = duas[index];
                return DuaCard(
                  dua: dua,
                  onDelete: () async {
                    await duaService.deleteDua(dua['id']);
                    await _loadDuas(); // ✅ Refresh dua list after deleting
                    setState(() {});
                  },
                  onEdit: _loadDuas, //refresh after editing
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DuaAddEditScreen()),
          ).then((_) => _loadDuas());
        },
        child: Icon(Icons.note_add_outlined),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
    );
  }
}
