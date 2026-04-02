import 'dart:convert';
import 'package:clean_togo/service/api_service.dart';
import 'package:clean_togo/ui/auth/login_screen.dart';
import 'package:clean_togo/ui/history/history_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final storage = const FlutterSecureStorage();

  bool _isTourneeLancee = false;
  List<dynamic> _courses = [];
  bool _isLoading = true;
  String _userName = "Chauffeur";

  String _userQuartier = "Lomé, Togo";

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  // Récupération filtrée par rapport au chauffeur connecté
  Future<void> _fetchDashboardData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // RÉCUPÉRATION DU VRAI TOKEN
      final storage = const FlutterSecureStorage();
      String? token = await storage.read(key: 'jwt');

      if (token == null) {
        debugPrint("Erreur : Aucun token trouvé");
        setState(() => _isLoading = false);
        return;
      }

      final response = await ApiService.getRequest("courses/findAll", token);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _courses = data;
          _isLoading = false;
        });
      } else {
        // TRÈS IMPORTANT : Arrêter le chargement même si le serveur répond une erreur
        debugPrint("Erreur Serveur : ${response.statusCode}");
        setState(() => _isLoading = false);

        // Optionnel : Afficher un message à l'utilisateur
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur serveur (${response.statusCode})"))
        );
      }
    } catch (e) {
      debugPrint("Exception attrapée : $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E7E44),
        title: const Text("Clean Togo", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // Pour voir le menu
      ),
      drawer: _buildDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _courses.isEmpty
          ? _buildPasDeTache()
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            for (var course in _courses)
              _buildCourseSection(course),

            if (!_isTourneeLancee)
              _buildBoutonAction("Démarrer la tournée", () {
                setState(() => _isTourneeLancee = true);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseSection(dynamic course) {
    // Une course contient des secteurs
    List<dynamic> secteurs = course['secteurs'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text("Course du : ${course['date_passage'] ?? ''}",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        ...secteurs.map((secteur) => Column(
          children: [
            _buildSecteurHeader(secteur),
            if (_isTourneeLancee) _buildListeFoyersREST(secteur['foyers'] ?? []),
            const SizedBox(height: 20),
          ],
        )).toList(),
        const Divider(),
      ],
    );
  }

  Widget _buildSecteurHeader(dynamic secteur) {
    // On récupère la liste des foyers du secteur
    List<dynamic> foyers = secteur['foyers'] ?? [];

    // On compte UNIQUEMENT ceux qui ne sont pas encore terminés
    int nbRestant = foyers.where((f) => f['statut'] != 'termine').length;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF1E7E44).withOpacity(0.3))
      ),
      child: Row(
        children: [
          const Icon(Icons.map_outlined, color: Color(0xFF1E7E44)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Secteur : ${secteur['nom_secteur']}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF1E7E44),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "$nbRestant foyers",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListeFoyersREST(List<dynamic> foyers) {
    return Column(
      children: foyers.map((foyer) {
        bool estTermine = foyer['statut'] == 'termine';
        String adresseFoyer = foyer['adresse'] ?? "Lomé, Togo";

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ListTile(
            leading: IconButton(
              icon: const Icon(Icons.directions, color: Colors.blue), // Icône de navigation
              onPressed: () => _ouvrirCarte(adresseFoyer),
              tooltip: "Tracer l'itinéraire",
            ),
            title: Text(foyer['nom'] ?? "Foyer"),
            subtitle: Text(adresseFoyer),
            trailing: IconButton(
              icon: Icon(
                  Icons.check_circle,
                  color: estTermine ? Colors.green : Colors.grey
              ),
              onPressed: estTermine ? null : () => _validerCollecteREST(foyer['id']),
            ),

          ),
        );
      }).toList(),
    );
  }
  Future<void> _validerCollecteREST(int foyerId) async {
    try {
      String? token = await storage.read(key: 'jwt');

      final response = await http.put(
        Uri.parse("${ApiService.baseUrl}/foyers/update-statut/$foyerId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"statut": "termine"}),
      );

      if (response.statusCode == 200) {
        _fetchDashboardData(); // On recharge les données pour mettre à jour le compteur et les couleurs
      }
    } catch (e) {
      debugPrint("Erreur lors de la validation : $e");
    }
  }
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF1E7E44)),
            accountName: Text(_userName),
            accountEmail: Text(_userQuartier),
            currentAccountPicture: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person)),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Tournée du jour"),
            onTap: () {
              // Si on est déjà sur le Dashboard, on ferme juste le menu
              // Sinon, on repart à zéro sur le Dashboard
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    (route) => false, // Efface toutes les anciennes pages pour éviter de "s'empiler"
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Mon Historique"),
            onTap: () {
              Navigator.pop(context); // 1. On ferme le Drawer d'abord
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryScreen())
              ); // 2. On ouvre l'écran
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Déconnexion"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPasDeTache() {
    return const Center(
      child: Text("Aucun secteur ne vous est assigné pour le moment."),
    );
  }

  Widget _buildBoutonAction(String label, VoidCallback action) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E7E44)),
        onPressed: action,
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }


  Future<void> _ouvrirCarte(String adresse) async {
    // On encode l'adresse pour qu'elle soit lisible par une URL (remplace les espaces par des +)
    final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(adresse)}";

    final Uri url = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Impossible d'ouvrir la carte pour l'adresse : $adresse");
    }
  }

}

