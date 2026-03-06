import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
  @override
  String toString() => message;
}

class ApiService {
  // ⚠️ Émulateur Android  → http://10.0.2.2:8080
  // ⚠️ Téléphone réel     → http://192.168.X.X:8080
  // ⚠️ Flutter Web Chrome → http://localhost:8080

  static const String baseUrl = 'http://10.0.2.2:8080';

  static final ApiService _i = ApiService._();
  factory ApiService() => _i;
  ApiService._();

  // ── SharedPreferences ─────────────────────────────────────────────────────
  Future<void> saveToken(String v) async =>
      (await SharedPreferences.getInstance()).setString('token', v);
  Future<String?> getToken() async =>
      (await SharedPreferences.getInstance()).getString('token');
  Future<void> saveEmail(String v) async =>
      (await SharedPreferences.getInstance()).setString('email', v);
  Future<String?> getEmail() async =>
      (await SharedPreferences.getInstance()).getString('email');
  Future<void> saveUserId(String v) async =>
      (await SharedPreferences.getInstance()).setString('userId', v);
  Future<String?> getUserId() async =>
      (await SharedPreferences.getInstance()).getString('userId');
  Future<void> clear() async => (await SharedPreferences.getInstance()).clear();

  Future<Map<String, String>> get _headers async {
    final t = await getToken();
    return {
      'Content-Type': 'application/json',
      if (t != null && t.isNotEmpty) 'Authorization': 'Bearer $t',
    };
  }

  void _check(http.Response r) {
    if (r.statusCode < 200 || r.statusCode >= 300) {
      String msg = 'Erreur ${r.statusCode}';
      try {
        final b = jsonDecode(r.body) as Map<String, dynamic>;
        msg = (b['message'] ?? b['error'] ?? msg).toString();
      } catch (_) {}
      throw ApiException(r.statusCode, msg);
    }
  }

  // ── AUTH  /api/auth/ ──────────────────────────────────────────────────────
  Future<AuthResponse> register(RegisterRequest req) async {
    final r = await http
        .post(Uri.parse('$baseUrl/api/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(req.toJson()))
        .timeout(const Duration(seconds: 15));
    _check(r);
    return AuthResponse.fromJson(jsonDecode(r.body));
  }

  Future<AuthResponse> login(String email, String password) async {
    final r = await http
        .post(Uri.parse('$baseUrl/api/auth/authenticate'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}))
        .timeout(const Duration(seconds: 15));
    _check(r);
    return AuthResponse.fromJson(jsonDecode(r.body));
  }

  // ── UTILISATEURS  /utilisateurs/ ─────────────────────────────────────────
  Future<List<Utilisateur>> getAllUtilisateurs() async {
    final r = await http
        .get(Uri.parse('$baseUrl/utilisateurs/findAll'),
            headers: await _headers)
        .timeout(const Duration(seconds: 15));
    _check(r);
    return (jsonDecode(r.body) as List)
        .map((e) => Utilisateur.fromJson(e))
        .toList();
  }

  Future<Utilisateur?> getUtilisateurByEmail(String email) async {
    try {
      final all = await getAllUtilisateurs();
      return all.firstWhere((u) => u.email == email);
    } catch (_) {
      return null;
    }
  }

  Future<Utilisateur> updateUtilisateur(
      String id, Map<String, dynamic> data) async {
    final r = await http
        .put(Uri.parse('$baseUrl/utilisateurs/update/$id'),
            headers: await _headers, body: jsonEncode(data))
        .timeout(const Duration(seconds: 15));
    _check(r);
    return Utilisateur.fromJson(jsonDecode(r.body));
  }

  // ── CLIENTS  /clients/ ───────────────────────────────────────────────────
  Future<List<ClientModel>> getAllClients() async {
    final r = await http
        .get(Uri.parse('$baseUrl/clients/findAll'), headers: await _headers)
        .timeout(const Duration(seconds: 15));
    _check(r);
    return (jsonDecode(r.body) as List)
        .map((e) => ClientModel.fromJson(e))
        .toList();
  }

  Future<ClientModel?> getClientByEmail(String email) async {
    try {
      final all = await getAllClients();
      return all.firstWhere((c) => c.email == email);
    } catch (_) {
      return null;
    }
  }

  Future<ClientModel> updateClient(String id, Map<String, dynamic> data) async {
    final r = await http
        .put(Uri.parse('$baseUrl/clients/update/$id'),
            headers: await _headers, body: jsonEncode(data))
        .timeout(const Duration(seconds: 15));
    _check(r);
    return ClientModel.fromJson(jsonDecode(r.body));
  }

  // ── COURSES  /courses/ ────────────────────────────────────────────────────
  Future<List<CourseModel>> getAllCourses() async {
    final r = await http
        .get(Uri.parse('$baseUrl/courses/findAll'), headers: await _headers)
        .timeout(const Duration(seconds: 15));
    _check(r);
    return (jsonDecode(r.body) as List)
        .map((e) => CourseModel.fromJson(e))
        .toList();
  }

  // ── SECTEURS  /secteurs/ ──────────────────────────────────────────────────
  Future<List<SecteurModel>> getAllSecteurs() async {
    final r = await http
        .get(Uri.parse('$baseUrl/secteurs/findAll'), headers: await _headers)
        .timeout(const Duration(seconds: 15));
    _check(r);
    return (jsonDecode(r.body) as List)
        .map((e) => SecteurModel.fromJson(e))
        .toList();
  }

  // ── FOYERS  /foyers/ ──────────────────────────────────────────────────────
  Future<List<FoyerModel>> getAllFoyers() async {
    final r = await http
        .get(Uri.parse('$baseUrl/foyers/findAll'), headers: await _headers)
        .timeout(const Duration(seconds: 15));
    _check(r);
    return (jsonDecode(r.body) as List)
        .map((e) => FoyerModel.fromJson(e))
        .toList();
  }

  Future<FoyerModel> saveFoyer(FoyerModel f) async {
    final r = await http
        .post(Uri.parse('$baseUrl/foyers/save'),
            headers: await _headers, body: jsonEncode(f.toJson()))
        .timeout(const Duration(seconds: 15));
    _check(r);
    return FoyerModel.fromJson(jsonDecode(r.body));
  }

  // ── PAIEMENTS  /paiements/ ────────────────────────────────────────────────
  Future<List<PaiementModel>> getAllPaiements() async {
    final r = await http
        .get(Uri.parse('$baseUrl/paiements/findAll'), headers: await _headers)
        .timeout(const Duration(seconds: 15));
    _check(r);
    return (jsonDecode(r.body) as List)
        .map((e) => PaiementModel.fromJson(e))
        .toList();
  }

  Future<PaiementModel> savePaiement(PaiementModel p) async {
    final r = await http
        .post(Uri.parse('$baseUrl/paiements/save'),
            headers: await _headers, body: jsonEncode(p.toJson()))
        .timeout(const Duration(seconds: 15));
    _check(r);
    return PaiementModel.fromJson(jsonDecode(r.body));
  }

  // ── RECLAMATIONS  /commentaireReclamations/ ───────────────────────────────
  Future<List<ReclamationModel>> getAllReclamations() async {
    final r = await http
        .get(Uri.parse('$baseUrl/commentaireReclamations/findAll'),
            headers: await _headers)
        .timeout(const Duration(seconds: 15));
    _check(r);
    return (jsonDecode(r.body) as List)
        .map((e) => ReclamationModel.fromJson(e))
        .toList();
  }

  Future<ReclamationModel> saveReclamation(ReclamationModel rec) async {
    final body = jsonEncode({
      'objet': rec.objet,
      'description': rec.description,
    });
    print('saveReclamation body: $body'); // debug
    final r = await http
        .post(Uri.parse('$baseUrl/commentaireReclamations/save'),
            headers: await _headers, body: body)
        .timeout(const Duration(seconds: 15));
    _check(r);
    return ReclamationModel.fromJson(jsonDecode(r.body));
  }
}
