// ================================================================
//  MODELS — 100% alignés avec le backend Spring Boot
//
//  Utilisateur : id, nom, prenom, email, username, phone, statut, role
//  Client      : extends Utilisateur + foyers[]
//  Course      : id, date_passage, secteurs[]
//  Paiement    : id, nomModePaiement, numero, montant, dateVersement
//  Foyer       : id, adresse
//  Secteur     : id, nom_secteur, foyers[]
//  Commentaire_Reclamation : id, objet, description
//  AuthResponse: token, username, email, role
//  RegisterRequest → phone (pas numeroTelephone !), statut: true
// ================================================================

class Utilisateur {
  final String? id;
  final String nom;
  final String prenom;
  final String email;
  final String username;
  final String phone;
  final bool statut;
  final String? role;

  Utilisateur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.username,
    required this.phone,
    this.statut = true,
    this.role,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> j) => Utilisateur(
        id: j['id']?.toString(),
        nom: j['nom'] ?? '',
        prenom: j['prenom'] ?? '',
        email: j['email'] ?? '',
        username: j['username'] ?? j['realUsername'] ?? '',
        phone: j['phone'] ?? '',
        statut: j['statut'] ?? true,
        role: j['role'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'username': username,
        'phone': phone,
        'statut': statut,
        if (role != null) 'role': role,
      };

  String get fullName => '$prenom $nom'.trim();
}

class ClientModel {
  final String? id;
  final String nom;
  final String prenom;
  final String email;
  final String phone;
  final String username;
  final String role;
  final List<FoyerModel> foyers;

  ClientModel({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.phone,
    required this.username,
    this.role = 'CLIENT',
    this.foyers = const [],
  });

  factory ClientModel.fromJson(Map<String, dynamic> j) => ClientModel(
        id: j['id']?.toString(),
        nom: j['nom'] ?? '',
        prenom: j['prenom'] ?? '',
        email: j['email'] ?? '',
        phone: j['phone'] ?? '',
        username: j['username'] ?? j['realUsername'] ?? '',
        role: j['role'] ?? 'CLIENT',
        foyers: j['foyers'] != null
            ? (j['foyers'] as List)
                .map((f) => FoyerModel.fromJson(f as Map<String, dynamic>))
                .toList()
            : [],
      );

  String get fullName => '$prenom $nom'.trim();
}

class FoyerModel {
  final String? id;
  final String adresse;

  FoyerModel({this.id, required this.adresse});

  factory FoyerModel.fromJson(Map<String, dynamic> j) =>
      FoyerModel(id: j['id']?.toString(), adresse: j['adresse'] ?? '');

  Map<String, dynamic> toJson() =>
      {if (id != null) 'id': id, 'adresse': adresse};
}

class SecteurModel {
  final String? id;
  final String nomSecteur;
  final List<FoyerModel> foyers;

  SecteurModel({this.id, required this.nomSecteur, this.foyers = const []});

  factory SecteurModel.fromJson(Map<String, dynamic> j) => SecteurModel(
        id: j['id']?.toString(),
        nomSecteur: j['nom_secteur'] ?? '',
        foyers: j['foyers'] != null
            ? (j['foyers'] as List)
                .map((f) => FoyerModel.fromJson(f as Map<String, dynamic>))
                .toList()
            : [],
      );
}

class CourseModel {
  final String? id;
  final String? datePassage; // backend: date_passage → "yyyy-MM-dd"
  final List<SecteurModel> secteurs;

  CourseModel({this.id, this.datePassage, this.secteurs = const []});

  factory CourseModel.fromJson(Map<String, dynamic> j) => CourseModel(
        id: j['id']?.toString(),
        datePassage: j['date_passage']?.toString(),
        secteurs: j['secteurs'] != null
            ? (j['secteurs'] as List)
                .map((s) => SecteurModel.fromJson(s as Map<String, dynamic>))
                .toList()
            : [],
      );

  DateTime? get dateTime {
    if (datePassage == null) return null;
    try {
      return DateTime.parse(datePassage!);
    } catch (_) {
      return null;
    }
  }

  String get dateFormatted {
    final d = dateTime;
    if (d == null) return 'Date inconnue';
    const mois = [
      'Jan','Fév','Mar','Avr','Mai','Jun',
      'Jul','Aoû','Sep','Oct','Nov','Déc'
    ];
    const jours = ['Lun','Mar','Mer','Jeu','Ven','Sam','Dim'];
    return '${jours[d.weekday - 1]} ${d.day} ${mois[d.month - 1]} ${d.year}';
  }
}

class PaiementModel {
  final String? id;
  final String nomModePaiement; // Mixx / Flooz / T-Money
  final String numero;
  final double montant;
  final String? dateVersement;

  PaiementModel({
    this.id,
    required this.nomModePaiement,
    required this.numero,
    required this.montant,
    this.dateVersement,
  });

  factory PaiementModel.fromJson(Map<String, dynamic> j) => PaiementModel(
        id: j['id']?.toString(),
        nomModePaiement: j['nomModePaiement'] ?? '',
        numero: j['numero'] ?? '',
        montant: (j['montant'] ?? 0).toDouble(),
        dateVersement: j['dateVersement']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nomModePaiement': nomModePaiement,
        'numero': numero,
        'montant': montant,
        if (dateVersement != null) 'dateVersement': dateVersement,
      };

  String get dateFormatted {
    if (dateVersement == null) return '';
    try {
      final d = DateTime.parse(dateVersement!);
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    } catch (_) {
      return dateVersement!;
    }
  }
}

class ReclamationModel {
  final String? id;
  final String objet;
  final String description;

  ReclamationModel({this.id, required this.objet, required this.description});

  factory ReclamationModel.fromJson(Map<String, dynamic> j) =>
      ReclamationModel(
        id: j['id']?.toString(),
        objet: j['objet'] ?? '',
        description: j['description'] ?? '',
      );

  Map<String, dynamic> toJson() =>
      {if (id != null) 'id': id, 'objet': objet, 'description': description};
}

class AuthResponse {
  final String token;
  final String? email;
  final String? username;
  final String? role;

  AuthResponse({required this.token, this.email, this.username, this.role});

  factory AuthResponse.fromJson(Map<String, dynamic> j) => AuthResponse(
        token: j['token'] ?? '',
        email: j['email'],
        username: j['username'],
        role: j['role'],
      );
}

class RegisterRequest {
  final String nom;
  final String prenom;
  final String email;
  final String username;
  final String phone; // ← backend attend "phone" pas "numeroTelephone"
  final String password;
  final String role;

  RegisterRequest({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.username,
    required this.phone,
    required this.password,
    this.role = 'CLIENT',
  });

  Map<String, dynamic> toJson() => {
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'username': username,
        'phone': phone,
        'password': password,
        'role': role,
        'statut': true, // ← obligatoire
      };
}
