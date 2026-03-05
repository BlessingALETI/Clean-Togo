import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/auth_provider.dart';
import '../utils/theme.dart';
import 'main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true, _obscureC = true;

  @override
  void dispose() {
    for (var c in [_nomCtrl,_prenomCtrl,_emailCtrl,_phoneCtrl,_passCtrl,_confirmCtrl]) c.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Les mots de passe ne correspondent pas'),
          backgroundColor: AppColors.error));
      return;
    }
    final req = RegisterRequest(
      nom: _nomCtrl.text.trim(),
      prenom: _prenomCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      username: _emailCtrl.text.trim().split('@')[0],
      phone: _phoneCtrl.text.trim(),
      password: _passCtrl.text,
      role: 'CLIENT',
    );
    final auth = context.read<AuthProvider>();
    final ok = await auth.register(req);
    if (!mounted) return;
    if (ok) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const MainScreen()), (r) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(auth.error ?? "Erreur d'inscription"),
          backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColors.greenSplash,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 44, height: 44,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.eco_rounded, color: AppColors.primary, size: 28)),
              const SizedBox(width: 10),
              RichText(text: const TextSpan(children: [
                TextSpan(text: 'Clean ', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                TextSpan(text: 'Togo', style: TextStyle(color: Color(0xFF1B5E20), fontSize: 24, fontWeight: FontWeight.w900)),
              ])),
            ]),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Creer un compte',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                  const SizedBox(height: 20),
                  _field(_prenomCtrl, 'Prénom', Icons.person_outline),
                  const SizedBox(height: 12),
                  _field(_nomCtrl, 'Nom', Icons.person_outline),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        labelText: 'Adresse Mail', hintText: 'nom@gmail.com',
                        prefixIcon: Icon(Icons.email_outlined, color: AppColors.grey)),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Email requis';
                      if (!v.contains('@')) return 'Email invalide';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        labelText: 'Téléphone', hintText: '+228 90 00 00 00',
                        prefixIcon: Icon(Icons.phone_outlined, color: AppColors.grey)),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Téléphone requis' : null,
                  ),
                  const SizedBox(height: 12),
                  _passField(_passCtrl, 'Mot de passe', _obscure, () => setState(() => _obscure = !_obscure)),
                  const SizedBox(height: 12),
                  _passField(_confirmCtrl, 'Confirmation mot de passe', _obscureC, () => setState(() => _obscureC = !_obscureC)),
                  const SizedBox(height: 24),
                  auth.isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : ElevatedButton(onPressed: _register, child: const Text("S'inscrire")),
                  const SizedBox(height: 12),
                  Center(child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Déjà un compte ? Se connecter',
                        style: TextStyle(color: AppColors.primary)),
                  )),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon) => TextFormField(
    controller: c, textCapitalization: TextCapitalization.words,
    decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: AppColors.grey)),
    validator: (v) => (v == null || v.trim().isEmpty) ? '$label requis' : null,
  );

  Widget _passField(TextEditingController c, String label, bool obs, VoidCallback toggle) => TextFormField(
    controller: c, obscureText: obs,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey),
      suffixIcon: IconButton(
          icon: Icon(obs ? Icons.visibility_off : Icons.visibility, color: AppColors.grey),
          onPressed: toggle),
    ),
    validator: (v) {
      if (v == null || v.isEmpty) return '$label requis';
      if (v.length < 6) return 'Minimum 6 caractères';
      return null;
    },
  );
}
