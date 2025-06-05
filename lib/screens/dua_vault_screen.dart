import 'package:duva_app/screens/dua_add_edit_screen.dart';
import 'package:duva_app/services/dua_service.dart';
import 'package:duva_app/services/local_storage_service.dart';
import 'package:duva_app/widgets/dua_card.dart';
import 'package:flutter/material.dart';

class DuaVaultScreen extends StatefulWidget {
  const DuaVaultScreen({super.key});

  @override
  State<DuaVaultScreen> createState() => _DuaVaultScreenState();
}

class _DuaVaultScreenState extends State<DuaVaultScreen> {
  final DuaService duaService = DuaService();
  final DuaStorageService _duaStorageService = DuaStorageService();
  List<Map<String, dynamic>> filteredDuas = [];
  List<Map<String, dynamic>> categories = [];
  String? selectedCategory; //holds the selected category
  TextEditingController searchController = TextEditingController();
  String? searchQuery;

  @override
  void initState() {
    super.initState();
    _loadDuas();
    _loadCategories();
  }

  Future<void> _loadDuas() async {
    try {
      final localDuas = await _duaStorageService.getLocalDuas();
      setState(() {
        filteredDuas = localDuas;
      });
      bool online = await isOnline();
      if (online) {
        final data = await duaService.fetchDuas(
          searchQuery: searchQuery,
          category: selectedCategory,
        );

        setState(() {
          filteredDuas = data;
        });
        await duaService.saveDuasToLocal(data);
      }
    } catch (e) {
      debugPrint("Error fetching duas: $e");
    }
  }

  Future<void> _loadCategories() async {
    try {
      final fetchedCategories = await duaService.fetchCategories();
      if (mounted) {
        setState(() {
          categories = fetchedCategories;
        });
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });

    _loadDuas();
  }

  void _updateCategory(String? newCategory) {
    setState(() {
      selectedCategory = newCategory;
    });

    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        _loadDuas();
      }
    });
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

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    DropdownButton<String>(
                      value: selectedCategory,
                      hint: Text("Filter by Category"),
                      onChanged: (String? newValue) {
                        _updateCategory(newValue);
                      },
                      items:
                          categories.map((category) {
                            return DropdownMenuItem(
                              value: category['id'].toString(),
                              child: Text(category['name']),
                            );
                          }).toList(),
                    ),
                    //"Clear Filter" Button (Only shows when a category is selected)
                    if (selectedCategory != null) //
                      GestureDetector(
                        onTap: () => _updateCategory(null), // Reset filter
                        child: Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.close, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text(
                                "Clear Filter",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          //Dua List
          Expanded(
            child: ListView.builder(
              itemCount: filteredDuas.length,
              itemBuilder: (context, index) {
                final dua = filteredDuas[index];
                return DuaCard(
                  dua: dua,
                  onDelete: () async {
                    await duaService.deleteDua(dua['id']);
                    await duaService.syncDuas(); // Sync after deletion
                    await _loadDuas();
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
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        child: Icon(Icons.note_add_outlined),
      ),
    );
  }
}
