import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../services/auth_provider.dart';
import '../utils/theme.dart';
import 'signalement_screen.dart';
import 'agenda_screen.dart';

class AccueilScreen extends StatefulWidget {
  const AccueilScreen({super.key});
  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  final _api = ApiService();
  List<PaiementModel> _paiements = [];
  List<CourseModel> _courses = [];
  bool _loading = true;
  String? _err;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _err = null; });
    try {
      final results = await Future.wait([_api.getAllPaiements(), _api.getAllCourses()]);
      setState(() {
        _paiements = results[0] as List<PaiementModel>;
        _courses = results[1] as List<CourseModel>;
        _loading = false;
      });
    } catch (_) {
      setState(() { _err = 'Impossible de charger les données'; _loading = false; });
    }
  }

  CourseModel? get _prochaineCourse {
    final now = DateTime.now();
    final futures = _courses.where((c) {
      final d = c.dateTime;
      return d != null && d.isAfter(now);
    }).toList();
    if (futures.isEmpty) return null;
    futures.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
    return futures.first;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final prenom = auth.displayPrenom.isNotEmpty ? auth.displayPrenom : 'Client';
    final prochaine = _prochaineCourse;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _load,
        child: CustomScrollView(slivers: [
          SliverAppBar(
            floating: true, snap: true,
            backgroundColor: AppColors.primary,
            title: Row(children: [
              Container(width: 32, height: 32,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.eco_rounded, color: AppColors.primary, size: 20)),
              const SizedBox(width: 8),
              RichText(text: const TextSpan(children: [
                TextSpan(text: 'Clean ', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                TextSpan(text: 'Togo', style: TextStyle(color: Color(0xFFA5D6A7), fontSize: 18, fontWeight: FontWeight.w900)),
              ])),
            ]),
            actions: [IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {})],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Bonjour, $prenom 👋',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                const SizedBox(height: 4),
                const Text('Votre tableau de bord de collecte',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                const SizedBox(height: 20),

                // ── Prochain ramassage DYNAMIQUE ──
                _loading
                    ? Container(height: 160, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                        child: const Center(child: CircularProgressIndicator(color: Colors.white)))
                    : _ProchainRamassageCard(course: prochaine),
                const SizedBox(height: 16),

                // ── Actions rapides ──
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _QuickAction(icon: Icons.warning_amber_rounded, label: 'Signaler',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignalementScreen()))),
                  _QuickAction(icon: Icons.calendar_month_outlined, label: 'Planning',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AgendaScreen()))),
                  _QuickAction(icon: Icons.track_changes_outlined, label: 'Suivi', onTap: () {}),
                  _QuickAction(icon: Icons.history_rounded, label: 'Historique', onTap: () {}),
                ]),
                const SizedBox(height: 20),

                // ── Dernier paiement ──
                const Text('Mon abonnement',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                const SizedBox(height: 12),
                _loading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : _AbonnementCard(paiements: _paiements),
                const SizedBox(height: 20),

                // ── Activité récente ──
                const Text('Activité Récente',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                const SizedBox(height: 12),
                _loading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : _err != null
                        ? _ErrWidget(msg: _err!, onRetry: _load)
                        : _ActiviteRecente(paiements: _paiements),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

class _ProchainRamassageCard extends StatelessWidget {
  final CourseModel? course;
  const _ProchainRamassageCard({this.course});

  @override
  Widget build(BuildContext context) {
    final hasData = course != null && course!.dateTime != null;
    final dt = course?.dateTime;

    String heure = '10:00';
    String jour = hasData ? course!.dateFormatted : 'Aucun passage prévu';
    String secteur = hasData && course!.secteurs.isNotEmpty
        ? course!.secteurs.map((s) => s.nomSecteur).join(', ')
        : 'Votre quartier';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Prochain ramassage', style: TextStyle(color: Colors.white70, fontSize: 13)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: Text(hasData ? 'Planifié' : 'En attente',
                style: const TextStyle(color: Colors.white, fontSize: 11)),
          ),
        ]),
        const SizedBox(height: 12),
        Text(jour, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        if (hasData)
          Text(heure, style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900, height: 1)),
        const SizedBox(height: 10),
        Row(children: [
          const Icon(Icons.location_on_rounded, color: Colors.white70, size: 14),
          const SizedBox(width: 4),
          Expanded(child: Text(secteur, style: const TextStyle(color: Colors.white70, fontSize: 12), overflow: TextOverflow.ellipsis)),
        ]),
      ]),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(children: [
      Container(width: 58, height: 58,
        decoration: BoxDecoration(color: AppColors.primaryLight.withOpacity(0.25), borderRadius: BorderRadius.circular(16)),
        child: Icon(icon, color: AppColors.primary, size: 26)),
      const SizedBox(height: 6),
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
    ]),
  );
}

class _AbonnementCard extends StatelessWidget {
  final List<PaiementModel> paiements;
  const _AbonnementCard({required this.paiements});
  @override
  Widget build(BuildContext context) {
    final dernier = paiements.isNotEmpty ? paiements.last : null;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Mon Forfait', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: dernier != null ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20)),
            child: Text(dernier != null ? 'Actif' : 'Aucun forfait',
                style: TextStyle(color: dernier != null ? AppColors.success : AppColors.error, fontSize: 11)),
          ),
        ]),
        if (dernier != null) ...[
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
            const SizedBox(width: 8),
            Text('${dernier.nomModePaiement} — ${dernier.montant.toStringAsFixed(0)} FCFA',
                style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
          ]),
          const SizedBox(height: 4),
          Text('Payé le ${dernier.dateFormatted}',
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        ],
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            minimumSize: const Size(double.infinity, 44)),
          child: const Text('Renouveler mon abonnement'),
        ),
      ]),
    );
  }
}

class _ActiviteRecente extends StatelessWidget {
  final List<PaiementModel> paiements;
  const _ActiviteRecente({required this.paiements});
  @override
  Widget build(BuildContext context) {
    if (paiements.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: const Center(child: Text('Aucune activité récente', style: TextStyle(color: AppColors.textGrey))),
      );
    }
    return Column(children: paiements.take(5).map((p) => Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Row(children: [
        Container(width: 40, height: 40,
          decoration: BoxDecoration(color: AppColors.primaryLight.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.payment_rounded, color: AppColors.primary, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.nomModePaiement, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Text(p.dateFormatted, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        ])),
        Text('${p.montant.toStringAsFixed(0)} F',
            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 14)),
      ]),
    )).toList());
  }
}

class _ErrWidget extends StatelessWidget {
  final String msg; final VoidCallback onRetry;
  const _ErrWidget({required this.msg, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(child: Column(children: [
    const Icon(Icons.wifi_off_rounded, color: AppColors.grey, size: 40),
    const SizedBox(height: 8),
    Text(msg, style: const TextStyle(color: AppColors.textGrey)),
    TextButton(onPressed: onRetry, child: const Text('Réessayer')),
  ]));
}
