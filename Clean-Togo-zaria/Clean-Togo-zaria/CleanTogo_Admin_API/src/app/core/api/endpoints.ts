// ================================================================
//  ENDPOINTS — Alignés 100% avec le backend Spring Boot CleanTogo
//
//  Auth     : POST /api/auth/authenticate  | POST /api/auth/register
//  Clients  : GET/PUT/DELETE /clients/findAll | /clients/findById/{id} | /clients/update/{id} | /clients/delete/{id}
//  Chauffeurs: /chauffeurs/...
//  Courses  : /courses/findAll | /courses/save | /courses/update/{id} | /courses/delete/{id}
//  Paiements: /paiements/findAll | /paiements/save | ...
//  Reclamations: /commentaireReclamations/findAll | /commentaireReclamations/save | ...
//  Secteurs : /secteurs/findAll | ...
//  Foyers   : /foyers/findAll | ...
//  Utilisateurs: /utilisateurs/findAll | /utilisateurs/update/{id} | ...
// ================================================================

// ⚠️ Changez selon votre environnement :
//   Dev local → 'http://localhost:8080'
//   Prod      → 'https://api.cleantogo.tg'
const base = 'http://localhost:8080';

export const API = {
  base,

  // ── AUTH ──────────────────────────────────────────────────────
  auth: {
    login:    `${base}/api/auth/authenticate`,
    register: `${base}/api/auth/register`,
    // Pas de /auth/me → profil chargé via /utilisateurs/findAll filtre email
  },

  // ── UTILISATEURS ──────────────────────────────────────────────
  utilisateurs: {
    findAll:          `${base}/utilisateurs/findAll`,
    findById: (id: string | number) => `${base}/utilisateurs/findById/${id}`,
    update:   (id: string | number) => `${base}/utilisateurs/update/${id}`,
    delete:   (id: string | number) => `${base}/utilisateurs/delete/${id}`,
  },

  // ── CLIENTS ───────────────────────────────────────────────────
  clients: {
    findAll:          `${base}/clients/findAll`,
    findById: (id: string | number) => `${base}/clients/findById/${id}`,
    update:   (id: string | number) => `${base}/clients/update/${id}`,
    delete:   (id: string | number) => `${base}/clients/delete/${id}`,
  },

  // ── CHAUFFEURS (drivers) ───────────────────────────────────────
  chauffeurs: {
    findAll:          `${base}/chauffeurs/findAll`,
    findById: (id: string | number) => `${base}/chauffeurs/findById/${id}`,
    update:   (id: string | number) => `${base}/chauffeurs/update/${id}`,
    delete:   (id: string | number) => `${base}/chauffeurs/delete/${id}`,
  },

  // ── COURSES (tours/passages) ───────────────────────────────────
  courses: {
    findAll:          `${base}/courses/findAll`,
    findById: (id: string | number) => `${base}/courses/findById/${id}`,
    save:             `${base}/courses/save`,
    update:   (id: string | number) => `${base}/courses/update/${id}`,
    delete:   (id: string | number) => `${base}/courses/delete/${id}`,
  },

  // ── PAIEMENTS ─────────────────────────────────────────────────
  paiements: {
    findAll:          `${base}/paiements/findAll`,
    findById: (id: string | number) => `${base}/paiements/findById/${id}`,
    save:             `${base}/paiements/save`,
    update:   (id: string | number) => `${base}/paiements/update/${id}`,
    delete:   (id: string | number) => `${base}/paiements/delete/${id}`,
  },

  // ── RECLAMATIONS (complaints) ──────────────────────────────────
  reclamations: {
    findAll:          `${base}/commentaireReclamations/findAll`,
    findById: (id: string | number) => `${base}/commentaireReclamations/findById/${id}`,
    save:             `${base}/commentaireReclamations/save`,
    update:   (id: string | number) => `${base}/commentaireReclamations/update/${id}`,
    delete:   (id: string | number) => `${base}/commentaireReclamations/delete/${id}`,
  },

  // ── SECTEURS (zones) ──────────────────────────────────────────
  secteurs: {
    findAll:          `${base}/secteurs/findAll`,
    findById: (id: string | number) => `${base}/secteurs/findById/${id}`,
    save:             `${base}/secteurs/save`,
    update:   (id: string | number) => `${base}/secteurs/update/${id}`,
    delete:   (id: string | number) => `${base}/secteurs/delete/${id}`,
  },

  // ── FOYERS ────────────────────────────────────────────────────
  foyers: {
    findAll:          `${base}/foyers/findAll`,
    save:             `${base}/foyers/save`,
    update:   (id: string | number) => `${base}/foyers/update/${id}`,
    delete:   (id: string | number) => `${base}/foyers/delete/${id}`,
  },
};
