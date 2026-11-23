import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';

class LocalStorage {
  static const _authBox = 'auth_box';
  static const _dataBox = 'data_box';
  static const _settingsBox = 'settings_box';
  static const _syncBox = 'sync_box';

  late Box<String> _auth;
  late Box<String> _data;
  late Box<String> _settings;
  late Box<String> _sync;

  Future<void> init() async {
    await Hive.initFlutter();
    _auth = await Hive.openBox<String>(_authBox);
    _data = await Hive.openBox<String>(_dataBox);
    _settings = await Hive.openBox<String>(_settingsBox);
    _sync = await Hive.openBox<String>(_syncBox);
  }

  // Auth
  String? get token => _auth.get(AppConstants.tokenKey);
  Future<void> setToken(String? token) async {
    if (token == null || token.isEmpty) {
      await _auth.delete(AppConstants.tokenKey);
    } else {
      await _auth.put(AppConstants.tokenKey, token);
    }
  }

  Map<String, dynamic>? get user {
    final raw = _auth.get(AppConstants.userKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> setUser(Map<String, dynamic>? user) async {
    if (user == null) {
      await _auth.delete(AppConstants.userKey);
    } else {
      await _auth.put(AppConstants.userKey, jsonEncode(user));
    }
  }

  String? get baseUrl => _settings.get('base_url');
  Future<void> setBaseUrl(String? url) async {
    if (url == null || url.trim().isEmpty) {
      await _settings.delete('base_url');
    } else {
      await _settings.put('base_url', url.trim());
    }
  }

  // Generic data: customers/sites/notes as JSON lists keyed by name
  List<Map<String, dynamic>> readList(String key) {
    final raw = _data.get(key);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    return decoded.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> writeList(String key, List<Map<String, dynamic>> value) async {
    await _data.put(key, jsonEncode(value));
  }

  // Settings
  String? get defaultNoteStatus => _settings.get(AppConstants.defaultStatusKey);
  Future<void> setDefaultNoteStatus(String value) => _settings.put(AppConstants.defaultStatusKey, value);

  // Sync queue - list of ops
  List<Map<String, dynamic>> readSyncQueue() {
    final raw = _sync.get(AppConstants.pendingSyncKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    return decoded.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> writeSyncQueue(List<Map<String, dynamic>> ops) =>
      _sync.put(AppConstants.pendingSyncKey, jsonEncode(ops));

  Future<void> clearData() async {
    await _data.clear();
    await _sync.clear();
  }

  Future<void> clearAll() async {
    await _auth.clear();
    await _data.clear();
    await _settings.clear();
    await _sync.clear();
  }
}
