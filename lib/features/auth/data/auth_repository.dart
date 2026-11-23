import '../../../core/errors/app_exception.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage.dart';

class AuthRepository {
  AuthRepository(this._api, this._storage);
  final ApiClient _api;
  final LocalStorage _storage;

  bool get isLoggedIn => (_storage.token ?? '').isNotEmpty;
  Map<String, dynamic>? get currentUser => _storage.user;

  Future<void> register({required String name, required String email, required String password}) async {
    final res = await _api.post('/api/auth/register', data: {'name': name, 'email': email, 'password': password});
    await _saveAuth(res);
  }

  Future<void> login({required String email, required String password}) async {
    final res = await _api.post('/api/auth/login', data: {'email': email, 'password': password});
    await _saveAuth(res);
  }

  Future<void> _saveAuth(dynamic res) async {
    if (res is! Map) throw const AppException('Invalid auth response');
    final map = Map<String, dynamic>.from(res);
    final token = map['token']?.toString();
    if (token == null || token.isEmpty) throw const AppException('Missing token');
    await _storage.setToken(token);
    await _storage.setUser({'userId': map['userId'], 'email': map['email'], 'name': map['name']});
  }

  Future<void> logout() async {
    await _storage.setToken(null);
    await _storage.setUser(null);
    await _storage.clearData();
  }
}
