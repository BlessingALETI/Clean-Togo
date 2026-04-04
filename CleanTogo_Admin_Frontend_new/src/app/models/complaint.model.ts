// ================================================================
//  COMPLAINT MODEL — Aligné avec Commentaire_Reclamation (backend)
//  Champs backend : id, objet, description
//  Relation: Commentaire_Reclamation → ManyToOne Client (@JsonIgnore)
// ================================================================

export interface Complaint {
  id?: number | string;
  objet: string;         // backend: "objet"
  description: string;   // backend: "description"
  // Champs front uniquement
  clientId?: string | number;
  status?: 'Ouverte' | 'En cours' | 'Résolue';
  createdAtISO?: string;
}
