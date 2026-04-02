// ================================================================
//  TOUR MODEL — Aligné avec Course (backend)
//  Champs backend : id, date_passage (java.sql.Date), secteurs[]
//  Relation: Course → many Secteurs → many Foyers
// ================================================================

export interface Secteur {
  id?: number | string;
  nom_secteur: string;    // backend: "nom_secteur"
}

export interface Tour {
  id?: number | string;
  date_passage: string;   // backend: "date_passage" format "yyyy-MM-dd"
  secteurs?: Secteur[];   // liste des secteurs de cette course
  // Champs calculés côté front uniquement (pas envoyés au backend)
  dateISO?: string;       // alias pour compatibilité
  zone?: string;          // affiché en front = secteurs.map(s=>s.nom_secteur).join(', ')
  foyersCount?: number;   // calculé
  status?: 'Planifiée' | 'En cours' | 'Terminée'; // calculé selon date
}
