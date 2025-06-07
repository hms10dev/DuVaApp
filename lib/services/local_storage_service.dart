import 'package:hive/hive.dart';

class DuaStorageService {
  final Box _duaBox = Hive.box('duas');

  //save dua locally when offline

  Future<void> saveDuaOffline(String id, String duaContent) async {
    await _duaBox.put(id, {'content': duaContent, 'synced': false});
  }

  //retrive locally saved duas
  List<Map<String, dynamic>> getLocalDuas() {
    return _duaBox.values.map((dua) => dua as Map<String, dynamic>).toList();
  }

  //mark dua as synced after syncing with SUPABASE
  Future<void> markDuaAsSynced(String id) async {
    var dua = _duaBox.get(id);
    if (dua != null) {
      await _duaBox.put(id, {'content': dua['content'], 'synced': true});
    }
  }
}
