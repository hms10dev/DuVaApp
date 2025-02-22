import 'package:supabase_flutter/supabase_flutter.dart';

class DuaService {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  //create : add a new dua

  Future<void> addDua(
    String title,
    String text,
    List<String> tags,
    String? categoryId,
  ) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      throw Exception("User not authenticated!");
    }

    try {
      await Supabase.instance.client.from('dua').insert({
        'title': title,
        'text': text,
        'tags': tags,
        'category_id': categoryId,
        'user_id': user.id,
      });

      print("✅ Dua added successfully!"); // ✅ Debugging
    } catch (e) {
      print("❌ Error adding dua: $e"); // ✅ Catch errors
      throw Exception("Failed to add dua: $e");
    }
  }

  //read: Fetch All Duas
  Future<List<Map<String, dynamic>>> fetchDuas({String? searchQuery}) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated!");
    }
    try {
      var query = Supabase.instance.client
          .from('dua')
          .select('*')
          .eq('user_id', user.id); // Fetch only the user's duas

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.ilike(
          'title',
          '%$searchQuery%',
        ); // ✅ Search filter (case insensitive)
      }

      final List<dynamic> response = await query;

      print("Fetched Duas: $response"); //Debugging

      return response.cast<Map<String, dynamic>>();
    } catch (e) {
      print("Error Fetching duas $e");
      return [];
    }
  }

  //Update: Update an existing dua
  Future<void> UpdateDua(
    String id,
    String title,
    String text,
    List<String> tags,
    String? categoryId,
  ) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      throw Exception("User not authenticated!");
    }
    try {
      await supabaseClient
          .from('dua')
          .update({
            'title': title,
            'text': text,
            'tags': tags,
            'category_id': categoryId,
          })
          .eq('id', id)
          .eq('user_id', user.id);
      print("✅ Dua updated successfully!");
    } on Exception catch (e) {
      print("❌ Error updating dua: $e");
      throw Exception("Failed to update dua: $e");
    }
  }

  //Delete: Delete a Dua
  Future<void> deleteDua(String id) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      throw Exception("User not authenticated!");
    }

    try {
      await Supabase.instance.client
          .from('dua')
          .delete()
          .eq('id', id)
          .eq('user_id', user.id);
      print("✅ Dua deleted successfully!");
    } catch (e) {
      print("❌ Error deleting dua: $e");
      throw Exception("Failed to delete dua: $e");
    }
  }

  //add category
  Future<void> addCategory(String categoryName, String color) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      throw Exception("User not authenticated!");
    }

    //Check if category already exists
    final existingCategory =
        await Supabase.instance.client
            .from('category')
            .select('id')
            .eq('name', categoryName)
            .eq('user_id', user.id)
            .maybeSingle(); // Fetch single record or null

    if (existingCategory != null) {
      throw Exception("Category already exists!"); // Prevent duplicate
    }

    //Insert category if it doesn't exist
    await Supabase.instance.client.from('category').insert({
      'name': categoryName,
      'color': color,
      'user_id': user.id,
    });
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      throw Exception("User not authenticated!");
    }

    final List<dynamic> response = await Supabase.instance.client
        .from('category')
        .select('*')
        .eq('user_id', user.id); // ✅ Fetch only user's categories

    print("Fetched Categories: $response");

    return response.cast<Map<String, dynamic>>();
  }

  // **Fetch unique tags from all duas**
  Future<List<String>> fetchTags() async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('dua')
          .select('tags');
      Set<String> uniqueTags = {};
      for (var dua in response) {
        if (dua['tags'] != null) {
          uniqueTags.addAll(List<String>.from(dua['tags']));
        }
      }
      return uniqueTags.toList();
    } catch (e) {
      throw Exception("Error fetching tags: $e");
    }
  }
}
