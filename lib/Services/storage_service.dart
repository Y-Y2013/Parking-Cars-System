import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _usersKey = 'users_data_v2';
  static const String _slotsKey = 'parking_slots_v2';

  static const String adminUsername = 'admin';
  static const String adminPassword = 'admin123';

  static Future<Map<String, String>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_usersKey);

    final users = <String, String>{};

    if (data != null) {
      for (final item in data) {
        final parts = item.split('|');
        if (parts.length == 2) {
          users[parts[0]] = parts[1];
        }
      }
    }

    return users;
  }

  static Future<void> _saveUsers(Map<String, String> users) async {
    final prefs = await SharedPreferences.getInstance();
    final data = users.entries.map((e) => '${e.key}|${e.value}').toList();
    await prefs.setStringList(_usersKey, data);
  }

  static Future<bool> registerUser(String username, String password) async {
    username = username.trim();
    password = password.trim();

    if (username.isEmpty || password.isEmpty) return false;
    if (username.toLowerCase() == adminUsername) return false;

    final users = await _getUsers();
    if (users.containsKey(username)) return false;

    users[username] = password;
    await _saveUsers(users);
    return true;
  }

  static Future<bool> loginUser(String username, String password) async {
    username = username.trim();
    password = password.trim();

    if (username == adminUsername && password == adminPassword) {
      return true;
    }

    final users = await _getUsers();
    return users[username] == password;
  }

  static Future<bool> loginAdmin(String username, String password) async {
    return username.trim() == adminUsername && password.trim() == adminPassword;
  }

  static Future<List<bool>> loadSlots(
      int count, {
        Set<int> defaultFullIndices = const {},
      }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_slotsKey);

    List<bool> slots;

    if (data == null) {
      slots = List<bool>.filled(count, false);
      for (final i in defaultFullIndices) {
        if (i >= 0 && i < count) {
          slots[i] = true;
        }
      }
      await saveSlots(slots);
      return slots;
    }

    slots = data.map((e) => e == '1').toList();

    if (slots.length < count) {
      slots.addAll(List<bool>.filled(count - slots.length, false));
    } else if (slots.length > count) {
      slots = slots.sublist(0, count);
    }

    return slots;
  }

  static Future<void> saveSlots(List<bool> slots) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _slotsKey,
      slots.map((e) => e ? '1' : '0').toList(),
    );
  }

  static Future<void> saveSlot(int index, bool value) async {
    final slots = await loadSlots(index + 1);
    if (index >= slots.length) {
      slots.addAll(List<bool>.filled(index + 1 - slots.length, false));
    }
    slots[index] = value;
    await saveSlots(slots);
  }
}