import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../services/auth_provider.dart';
import '../utils/theme.dart';
import 'login_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});
  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final _api = ApiService();

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Déconnecter')),
        ],
      ),
    );
    if (ok == true && mounted) {
      await context.read<AuthProvider>().logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
    }
  }

  void _showEditProfil(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final nomCtrl = TextEditingController(text: auth.displayNom);
    final prenomCtrl = TextEditingController(text: auth.displayPrenom);
    final emailCtrl = TextEditingController(text: auth.displayEmail);
    final phoneCtrl = TextEditingController(text: auth.displayPhone);
    bool saving = false;

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Modifier le profil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(controller: prenomCtrl, decoration: const InputDecoration(labelText: 'Prénom')),
            const SizedBox(height: 12),
            TextField(controller: nomCtrl, decoration: const InputDecoration(labelText: 'Nom')),
            const SizedBox(height: 12),
            TextField(controller: emailCtrl, keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: phoneCtrl, keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Téléphone')),
            const SizedBox(height: 20),
            saving
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : ElevatedButton(
                    onPressed: () async {
                      setModal(() => saving = true);
                      try {
                        final userId = await _api.getUserId();
                        if (userId != null) {
                          await _api.updateUtilisateur(userId, {
                            'nom': nomCtrl.text.trim(),
                            'prenom': prenomCtrl.text.trim(),
                            'email': emailCtrl.text.trim(),
                            'phone': phoneCtrl.text.trim(),
                          });
                          await context.read<AuthProvider>().refreshUser();
                          if (mounted) Navigator.pop(ctx);
                          if (mounted) ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profil mis à jour !'), backgroundColor: AppColors.success));
                        }
                      } catch (_) {
                        if (mounted) ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Erreur de mise à jour'), backgroundColor: AppColors.error));
                      }
                      setModal(() => saving = false);
                    },
                    child: const Text('Sauvegarder')),
          ]),
        ),
      ),
    );
  }

  void _showAdresse(BuildContext context) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Ajouter une adresse', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          TextField(controller: ctrl, decoration: const InputDecoration(
              labelText: 'Adresse / Quartier',
              prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.grey))),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              try {
                await _api.saveFoyer(FoyerModel(adresse: ctrl.text.trim()));
                await context.read<AuthProvider>().refreshUser();
                if (mounted) Navigator.pop(ctx);
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Adresse enregistrée !'), backgroundColor: AppColors.success));
              } catch (_) {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Erreur'), backgroundColor: AppColors.error));
              }
            },
            child: const Text('Sauvegarder')),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final foyers = auth.client?.foyers ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Mon Profil'), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Column(children: [
          // ── Header dynamique ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            color: AppColors.primary,
            child: Column(children: [
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4))]),
                child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 52),
              ),
              const SizedBox(height: 12),
              Text(
                auth.displayName.isNotEmpty ? auth.displayName : 'Utilisateur',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(auth.displayEmail, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              if (auth.displayPhone.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(auth.displayPhone, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ]),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              // ── Mes adresses (dynamiques) ──
              if (foyers.isNotEmpty) ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
                        child: Text('Mes adresses',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark))),
                      ...foyers.map((f) => ListTile(
                        leading: Container(width: 38, height: 38,
                          decoration: BoxDecoration(color: AppColors.primaryLight.withOpacity(0.25), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20)),
                        title: Text(f.adresse, style: const TextStyle(fontSize: 14)),
                        dense: true,
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // ── Options ──
              _Section(items: [
                _Item(icon: Icons.manage_accounts_outlined, label: 'Modifier le profil',
                    onTap: () => _showEditProfil(context)),
                _Item(icon: Icons.location_on_outlined, label: 'Ajouter une adresse',
                    onTap: () => _showAdresse(context)),
              ]),
              const SizedBox(height: 12),
              _Section(items: [
                _Item(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () {}),
                _Item(icon: Icons.language_outlined, label: 'Langage',
                    trailing: const Text('Français', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                    onTap: () {}),
                _Item(icon: Icons.settings_outlined, label: 'Paramètres', onTap: () {}),
              ]),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Se déconnecter'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              ),
              const SizedBox(height: 80),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final List<_Item> items;
  const _Section({required this.items});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
    child: Column(children: items.asMap().entries.map((e) => Column(children: [
      e.value,
      if (e.key < items.length - 1) const Divider(height: 1, color: AppColors.greyLight, indent: 56),
    ])).toList()),
  );
}

class _Item extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap; final Widget? trailing;
  const _Item({required this.icon, required this.label, required this.onTap, this.trailing});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Container(width: 38, height: 38,
      decoration: BoxDecoration(color: AppColors.primaryLight.withOpacity(0.25), borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: AppColors.primary, size: 20)),
    title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
    trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: AppColors.grey),
    onTap: onTap,
  );
}
