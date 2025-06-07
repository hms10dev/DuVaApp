import 'package:duva_app/services/dua_service.dart';
import 'package:flutter/material.dart';

class DuaAddEditScreen extends StatefulWidget {
  final Map<String, dynamic>? dua;

  const DuaAddEditScreen({super.key, this.dua});

  @override
  State<DuaAddEditScreen> createState() => _DuaAddEditScreenState();
}

class _DuaAddEditScreenState extends State<DuaAddEditScreen> {
  final DuaService duaService = DuaService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  List<Map<String, dynamic>> categories = [];
  List<String> availableTags = [];
  List<String> selectedTags = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchCategoriesAndTags();
    if (widget.dua != null) {
      titleController.text = widget.dua!['title'];
      textController.text = widget.dua!['text'];
      selectedTags = List<String>.from(widget.dua!['tags']);
      selectedCategory = widget.dua!['category_id'];
    }
  }

  Future<void> _fetchCategoriesAndTags() async {
    try {
      final fetchedCategories = await duaService.fetchCategories();
      final fetchedTags = await duaService.fetchTags();

      setState(() {
        categories = fetchedCategories;
        availableTags = fetchedTags;
      });
    } catch (e) {
      debugPrint("Error Loading Catefories/tags: $e");
    }
  }

  Future<void> _saveDua() async {
    if (widget.dua == null) {
      await duaService.addDua(
        titleController.text,
        textController.text,
        selectedTags,
        selectedCategory,
      );
    } else {
      await duaService.updateDua(
        widget.dua!['id'],
        titleController.text,
        textController.text,
        selectedTags,
        selectedCategory,
      );
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.dua == null ? 'Add Dua' : 'Edit Dua')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Dua Title'),
            ),
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Dua Details'),
              maxLines: 4,
            ),
            SizedBox(height: 10),

            // Select or create a category
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items:
                  categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category['id'].toString(),
                          child: Text(category['name']), // Use category ID
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 10),

            //add a category:
            TextButton(
              onPressed: () async {
                String? newCategory = await _showAddCategoryDialog();
                if (newCategory != null && newCategory.isNotEmpty) {
                  try {
                    await duaService.addCategory(newCategory, "#FF5733");
                    await _fetchCategoriesAndTags();
                    if (!mounted) return;
                    setState(() {});
                  } on Exception catch (e) {
                    if (!mounted) return;

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              },
              child: Text(
                "+ Add Category",
                style: TextStyle(color: Colors.amber),
              ),
            ),

            //Dynamic Tag Selection
            Wrap(
              spacing: 8.0,
              children:
                  availableTags.map((tag) {
                    return ChoiceChip(
                      label: Text(tag),
                      selected: selectedTags.contains(tag),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedTags.add(tag);
                          } else {
                            selectedTags.remove(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),
            SizedBox(height: 20),

            //Save Button
            ElevatedButton(
              onPressed: () async {
                await _saveDua();
              },
              child: Text('Save Dua'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showAddCategoryDialog() async {
    TextEditingController categoryController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("New Category"),
          content: TextField(
            controller: categoryController,
            decoration: InputDecoration(hintText: "Enter Category Name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, categoryController.text),
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
