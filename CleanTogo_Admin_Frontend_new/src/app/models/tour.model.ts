
export interface Secteur {
  id?: number | string;
  nom_secteur: string;    // backend: "nom_secteur"
}

export interface Tour {
  id?: number | string;
  date_passage: string;   // backend: "date_passage" format "yyyy-MM-dd"
  secteurs?: Secteur[];   // liste des secteurs de cette course
  driverId?: string | null  // ID du chauffeur assigné
  foyersCount?: number;   // nombre de foyers à desservir
  // Champs calculés côté front uniquement (pas envoyés au backend)
  dateISO?: string;       // alias pour compatibilité
  zone?: string;          // affiché en front = secteurs.map(s=>s.nom_secteur).join(', ')
  status?: 'Planifiée' | 'En cours' | 'Terminée'; // calculé selon date
}
