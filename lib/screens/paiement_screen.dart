import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../utils/theme.dart';

class PaiementScreen extends StatefulWidget {
  const PaiementScreen({super.key});
  @override
  State<PaiementScreen> createState() => _PaiementScreenState();
}

class _PaiementScreenState extends State<PaiementScreen> {
  final _api = ApiService();
  final _phoneCtrl = TextEditingController();
  String? _mode; // Mixx / Flooz / T-Money
  int? _forfaitIdx;
  bool _paying = false;
  bool _loadingHist = true;
  List<PaiementModel> _historique = [];

  final List<Map<String, dynamic>> _forfaits = [
    {'label': 'Mensuel', 'montant': 5000.0, 'desc': '1 mois de collecte'},
    {'label': 'Trimestriel', 'montant': 13000.0, 'desc': '3 mois — économisez 2000 F'},
    {'label': 'Semestriel', 'montant': 24000.0, 'desc': '6 mois — économisez 6000 F'},
    {'label': 'Annuel', 'montant': 45000.0, 'desc': '12 mois — économisez 15000 F'},
  ];

  @override
  void initState() { super.initState(); _loadHistorique(); }
  @override
  void dispose() { _phoneCtrl.dispose(); super.dispose(); }

  Future<void> _loadHistorique() async {
    setState(() => _loadingHist = true);
    try {
      final data = await _api.getAllPaiements();
      setState(() { _historique = data; _loadingHist = false; });
    } catch (_) {
      setState(() => _loadingHist = false);
    }
  }

  Future<void> _payer() async {
    if (_mode == null) { _snack('Choisissez un mode de paiement', err: true); return; }
    if (_forfaitIdx == null) { _snack('Choisissez un forfait', err: true); return; }
    if (_phoneCtrl.text.trim().isEmpty) { _snack('Entrez votre numéro', err: true); return; }

    setState(() => _paying = true);
    try {
      final f = _forfaits[_forfaitIdx!];
      final p = PaiementModel(
        nomModePaiement: _mode!,
        numero: _phoneCtrl.text.trim(),
        montant: f['montant'] as double,
        dateVersement: DateTime.now().toIso8601String(),
      );
      await _api.savePaiement(p);
      if (!mounted) return;
      setState(() { _paying = false; _mode = null; _forfaitIdx = null; _phoneCtrl.clear(); });
      _snack('Paiement de ${(f['montant'] as double).toStringAsFixed(0)} FCFA effectué via ${_mode ?? ''} !');
      _loadHistorique();
    } catch (e) {
      if (!mounted) return;
      setState(() => _paying = false);
      _snack('Erreur : $e', err: true);
    }
  }

  void _snack(String msg, {bool err = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: err ? AppColors.error : AppColors.success));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Paiement'), automaticallyImplyLeading: false),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadHistorique,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ── Mode de paiement ──
            const _STitle('Mode de paiement'),
            const SizedBox(height: 12),
            ...[('Mixx', Icons.phone_android_rounded), ('Flooz', Icons.account_balance_wallet_rounded), ('T-Money', Icons.payment_rounded)]
              .map((e) => _ModeBtn(
                label: 'Payer avec ${e.$1}',
                icon: e.$2,
                selected: _mode == e.$1,
                onTap: () => setState(() => _mode = e.$1))),
            const SizedBox(height: 24),

            // ── Forfaits ──
            const _STitle('Choisir un forfait'),
            const SizedBox(height: 12),
            ...List.generate(_forfaits.length, (i) => _ForfaitItem(
              forfait: _forfaits[i],
              selected: _forfaitIdx == i,
              onTap: () => setState(() => _forfaitIdx = i),
            )),
            const SizedBox(height: 20),

            // ── Numéro ──
            const _STitle('Numéro de paiement'),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: _mode != null ? 'Numéro $_mode' : 'Votre numéro',
                prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.grey),
                filled: true, fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // ── Résumé ──
            if (_forfaitIdx != null && _mode != null) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryLight)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('${_forfaits[_forfaitIdx!]['label']} via $_mode',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text('${(_forfaits[_forfaitIdx!]['montant'] as double).toStringAsFixed(0)} FCFA',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 16)),
                ]),
              ),
              const SizedBox(height: 16),
            ],

            _paying
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : ElevatedButton(onPressed: _payer, child: const Text('Confirmer le paiement')),
            const SizedBox(height: 28),

            // ── Historique ──
            _STitle('Historique des paiements (${_historique.length})'),
            const SizedBox(height: 12),
            _loadingHist
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _historique.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: const Center(child: Text('Aucun paiement', style: TextStyle(color: AppColors.textGrey))))
                    : Column(children: _historique.map((p) => _HistItem(p: p)).toList()),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    );
  }
}

class _STitle extends StatelessWidget {
  final String t;
  const _STitle(this.t);
  @override
  Widget build(BuildContext context) => Text(t,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark));
}

class _ModeBtn extends StatelessWidget {
  final String label; final IconData icon; final bool selected; final VoidCallback onTap;
  const _ModeBtn({required this.label, required this.icon, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: selected ? AppColors.primary : AppColors.greyLight),
        boxShadow: selected ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
            : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Row(children: [
        Icon(icon, color: selected ? Colors.white : AppColors.primary, size: 22),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(
          color: selected ? Colors.white : AppColors.textDark,
          fontWeight: FontWeight.w600, fontSize: 15)),
        const Spacer(),
        if (selected) const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
      ]),
    ),
  );
}

class _ForfaitItem extends StatelessWidget {
  final Map<String, dynamic> forfait; final bool selected; final VoidCallback onTap;
  const _ForfaitItem({required this.forfait, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: selected ? AppColors.primary : AppColors.greyLight, width: selected ? 2 : 1)),
      child: Row(children: [
        Container(width: 22, height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: selected ? AppColors.primary : AppColors.grey, width: 2),
            color: selected ? AppColors.primary : Colors.transparent),
          child: selected ? const Icon(Icons.check, color: Colors.white, size: 13) : null),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(forfait['label'] as String,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark)),
          Text(forfait['desc'] as String,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        ])),
        Text('${(forfait['montant'] as double).toStringAsFixed(0)} FCFA',
            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 15)),
      ]),
    ),
  );
}

class _HistItem extends StatelessWidget {
  final PaiementModel p;
  const _HistItem({required this.p});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
    child: Row(children: [
      Container(width: 40, height: 40,
        decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 22)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(p.nomModePaiement, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        Text('N° ${p.numero}', style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        if (p.dateFormatted.isNotEmpty)
          Text(p.dateFormatted, style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('${p.montant.toStringAsFixed(0)} F',
            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 14)),
        const Text('Validé', style: TextStyle(color: AppColors.success, fontSize: 11)),
      ]),
    ]),
  );
}
