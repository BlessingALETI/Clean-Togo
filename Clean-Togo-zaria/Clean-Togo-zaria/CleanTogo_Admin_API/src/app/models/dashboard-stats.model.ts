// ================================================================
//  DASHBOARD STATS — Calculé côté front depuis les vraies données
//  Le backend n'a pas d'endpoint /dashboard/stats dédié.
//  Le DashboardService récupère clients + paiements + courses
//  et calcule les stats localement.
// ================================================================

export interface DashboardStats {
  totalClients: number;
  totalChauffeurs: number;
  totalCourses: number;
  totalPaiements: number;
  montantTotal: number;        // somme des montants des paiements
  tauxCollecte?: number;       // % calculé (courses passées / total)
  revenusMensuelsFCFA?: number;
  tauxImpayes?: number;
}
