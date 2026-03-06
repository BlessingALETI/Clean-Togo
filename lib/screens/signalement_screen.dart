import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../utils/theme.dart';

class SignalementScreen extends StatefulWidget {
  const SignalementScreen({super.key});
  @override
  State<SignalementScreen> createState() => _SignalementScreenState();
}

class _SignalementScreenState extends State<SignalementScreen> {
  final _api = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _objetCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _sending = false;
  bool _loadingList = true;
  List<ReclamationModel> _reclamations = [];
  String? _selectedObjet;

  final List<String> _objets = [
    'Collecte non effectuée',
    'Collecte en retard',
    'Mauvais tri des déchets',
    'Comportement du chauffeur',
    'Problème de facturation',
    'Autre',
  ];

  @override
  void initState() {
    super.initState();
    _loadReclamations();
  }

  @override
  void dispose() {
    _objetCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadReclamations() async {
    setState(() => _loadingList = true);
    try {
      final data = await _api.getAllReclamations();
      setState(() {
        _reclamations = data;
        _loadingList = false;
      });
    } catch (_) {
      setState(() => _loadingList = false);
    }
  }

  Future<void> _envoyer() async {
    if (!_formKey.currentState!.validate()) return;

    // Vérifier que l'objet est sélectionné
    if (_selectedObjet == null || _selectedObjet!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Veuillez sélectionner un objet'),
          backgroundColor: AppColors.error));
      return;
    }

    setState(() => _sending = true);
    try {
      final rec = ReclamationModel(
        objet: _selectedObjet!.trim(),
        description: _descCtrl.text.trim(),
      );
      await _api.saveReclamation(rec);
      if (!mounted) return;
      setState(() {
        _sending = false;
        _selectedObjet = null;
        _objetCtrl.clear();
        _descCtrl.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Signalement envoyé avec succès !'),
          backgroundColor: AppColors.success));
      _loadReclamations();
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur : $e'), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Signalement / Réclamation')),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadReclamations,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ── Formulaire ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ]),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Nouveau signalement',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark)),
                      const SizedBox(height: 16),

                      // Objet (dropdown)
                      const Text('Objet',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AppColors.textGrey)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.greyLight)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text('Sélectionnez un objet',
                                style: TextStyle(color: AppColors.grey)),
                            value: _selectedObjet,
                            items: _objets
                                .map((o) => DropdownMenuItem(
                                    value: o,
                                    child: Text(o,
                                        style: const TextStyle(fontSize: 14))))
                                .toList(),
                            onChanged: (v) => setState(() {
                              _selectedObjet = v;
                              _objetCtrl.text = v ?? '';
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      const Text('Description',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AppColors.textGrey)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descCtrl,
                        maxLines: 4,
                        decoration: const InputDecoration(
                            hintText: 'Décrivez votre problème en détail...',
                            alignLabelWithHint: true),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Description requise';
                          if (v.trim().length < 10)
                            return 'Minimum 10 caractères';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      _sending
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.primary))
                          : ElevatedButton.icon(
                              onPressed: _envoyer,
                              icon: const Icon(Icons.send_rounded),
                              label: const Text('Envoyer le signalement')),
                    ]),
              ),
            ),
            const SizedBox(height: 24),

            // ── Historique réclamations ──
            Text('Mes signalements (${_reclamations.length})',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            const SizedBox(height: 12),
            _loadingList
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary))
                : _reclamations.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                            child: Text('Aucun signalement',
                                style: TextStyle(color: AppColors.textGrey))))
                    : Column(
                        children: _reclamations
                            .map((r) => Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.04),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2))
                                      ]),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: AppColors.error
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: const Icon(
                                                Icons.warning_amber_rounded,
                                                color: AppColors.error,
                                                size: 22)),
                                        const SizedBox(width: 12),
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                              Text(r.objet,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13,
                                                      color:
                                                          AppColors.textDark)),
                                              const SizedBox(height: 4),
                                              Text(r.description,
                                                  style: const TextStyle(
                                                      color: AppColors.textGrey,
                                                      fontSize: 12),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ])),
                                      ]),
                                ))
                            .toList()),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    );
  }
}
