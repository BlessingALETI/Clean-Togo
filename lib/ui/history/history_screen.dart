import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:clean_togo/service/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> _historyData = [];
  bool _isLoading = true;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      String? token = await storage.read(key: 'jwt');
      // On appelle l'endpoint history qui filtre par chauffeur connecté
      final response = await ApiService.getRequest("courses/history", token!);

      if (response.statusCode == 200) {
        setState(() {
          _historyData = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Erreur historique : $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // On extrait tous les foyers terminés de toutes les courses reçues
    List<dynamic> foyersTermines = [];
    for (var course in _historyData) {
      for (var secteur in (course['secteurs'] ?? [])) {
        for (var foyer in (secteur['foyers'] ?? [])) {
          if (foyer['statut']?.toString().toLowerCase() == 'termine') {
            // On ajoute une info sur la date de la course pour l'affichage
            foyer['date_passage'] = course['date_passage'];
            foyer['nom_secteur'] = secteur['nom_secteur'];
            foyersTermines.add(foyer);
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E7E44),
        title: const Text("Historique", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : foyersTermines.isEmpty
          ? const Center(child: Text("Aucun foyer collecté pour le moment."))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _buildHeader(),
            _buildTable(foyersTermines),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E7E44),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
      ),
      child: const Text(
        "Foyers collectés",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTable(List<dynamic> foyers) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DataTable(
        columnSpacing: 15,
        horizontalMargin: 10,
        headingRowHeight: 40,
        columns: const [
          DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Nom', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Secteur', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: foyers.map((foyer) {
          return DataRow(cells: [
            DataCell(Text(foyer['date_passage']?.toString() ?? "-", style: const TextStyle(fontSize: 11))),
            DataCell(Text(foyer['nom'] ?? "Client", style: const TextStyle(fontSize: 11))),
            DataCell(Text(foyer['nom_secteur'] ?? "-", style: const TextStyle(fontSize: 11))),
          ]);
        }).toList(),
      ),
    );
  }
}