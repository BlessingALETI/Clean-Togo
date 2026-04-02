// ================================================================
//  USER MODEL — Aligné avec Utilisateur (backend)
//  Champs backend : id, nom, prenom, email, username, phone, statut, role
//  Client extends Utilisateur + foyers[]
//  Chauffeur extends Utilisateur + courses[]
// ================================================================

export type UserRole = 'CLIENT' | 'CHAUFFEUR' | 'ADMIN';

export interface User {
  id?: number | string;
  nom: string;
  prenom: string;
  email: string;
  username?: string;
  phone: string;         // backend : "phone" (pas numeroTelephone !)
  password?: string;
  statut: boolean;       // backend : boolean (pas string)
  role: UserRole;
  // Champ calculé côté front uniquement
  fullName?: string;
}

// Utilisé pour créer/enregistrer un client via /api/auth/register
export interface RegisterRequest {
  nom: string;
  prenom: string;
  email: string;
  username: string;
  phone: string;
  password: string;
  role: UserRole;
  statut: boolean;       // toujours true à la création
}
