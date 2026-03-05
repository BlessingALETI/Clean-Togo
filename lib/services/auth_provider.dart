import 'package:flutter/material.dart';
import '../models/models.dart';
import 'api_service.dart';

class AuthProvider extends ChangeNotifier {
  final _api = ApiService();
  bool _loading = false;
  bool _authenticated = false;
  String? _error;
  Utilisateur? _user;
  ClientModel? _client;

  bool get isLoading => _loading;
  bool get isAuthenticated => _authenticated;
  String? get error => _error;
  Utilisateur? get user => _user;
  ClientModel? get client => _client;
  String get displayName => _user?.fullName ?? _client?.fullName ?? '';
  String get displayEmail => _user?.email ?? _client?.email ?? '';
  String get displayPhone => _user?.phone ?? _client?.phone ?? '';
  String get displayPrenom => _user?.prenom ?? _client?.prenom ?? '';
  String get displayNom => _user?.nom ?? _client?.nom ?? '';

  Future<bool> checkAuth() async {
    final token = await _api.getToken();
    if (token != null && token.isNotEmpty) {
      _authenticated = true;
      await _loadUser();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> _loadUser() async {
    try {
      final email = await _api.getEmail();
      if (email == null || email.isEmpty) return;
      final u = await _api.getUtilisateurByEmail(email);
      if (u != null) {
        _user = u;
        if (u.id != null) await _api.saveUserId(u.id!);
      }
      final c = await _api.getClientByEmail(email);
      if (c != null) _client = c;
    } catch (_) {}
  }

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final auth = await _api.login(email, password);
      await _api.saveToken(auth.token);
      await _api.saveEmail(auth.email ?? email);
      _authenticated = true;
      await _loadUser();
      _loading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _loading = false;
      notifyListeners();
      return false;
    } catch (_) {
      _error = 'Erreur de connexion. Vérifiez votre réseau.';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(RegisterRequest req) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final auth = await _api.register(req);
      await _api.saveToken(auth.token);
      await _api.saveEmail(auth.email ?? req.email);
      _authenticated = true;
      await _loadUser();
      _loading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _loading = false;
      notifyListeners();
      return false;
    } catch (_) {
      _error = "Erreur d'inscription. Vérifiez votre réseau.";
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshUser() async {
    await _loadUser();
    notifyListeners();
  }

  Future<void> logout() async {
    await _api.clear();
    _authenticated = false;
    _user = null;
    _client = null;
    notifyListeners();
  }
}
