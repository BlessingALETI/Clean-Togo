// ================================================================
//  PAYMENT MODEL — Aligné avec Paiement (backend)
//  Champs backend : id, nomModePaiement, numero, montant, dateVersement
//  Relation: Paiement → ManyToOne Client (client_id, @JsonIgnore)
// ================================================================

export interface Payment {
  id?: number | string;
  nomModePaiement: string;   // backend: "nomModePaiement" (ex: "Mixx", "Flooz", "T-Money")
  numero: string;            // backend: "numero" (numéro de téléphone utilisé)
  montant: number;           // backend: float
  dateVersement?: string;    // backend: Date ISO string
  // Champ front uniquement — non envoyé au backend
  clientId?: string | number;
  status?: 'Payé' | 'Impayé';
}
