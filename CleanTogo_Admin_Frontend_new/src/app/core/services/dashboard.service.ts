import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, forkJoin, map } from 'rxjs';
import { API } from '../api/endpoints';
import { DashboardStats } from '../../models/dashboard-stats.model';

export interface RecentAction {
  title: string;
  desc:  string;
  time:  string;
  type:  string;
}

@Injectable({ providedIn: 'root' })
export class DashboardService {
  constructor(private http: HttpClient) {}

  // ⚠️ Le backend n'a pas d'endpoint /dashboard/stats.
  // On calcule les stats en appelant les vrais endpoints :
  //   - GET /clients/findAll       → totalClients
  //   - GET /chauffeurs/findAll    → totalChauffeurs
  //   - GET /courses/findAll       → totalCourses, tauxCollecte
  //   - GET /paiements/findAll     → totalPaiements, montantTotal
  getStats(): Observable<DashboardStats> {
    return forkJoin({
      clients:    this.http.get<any[]>(API.clients.findAll),
      chauffeurs: this.http.get<any[]>(API.chauffeurs.findAll),
      courses:    this.http.get<any[]>(API.courses.findAll),
      paiements:  this.http.get<any[]>(API.paiements.findAll),
    }).pipe(
      map(({ clients, chauffeurs, courses, paiements }) => {
        const now = new Date();
        const coursesPassees = courses.filter(c => {
          const d = c.date_passage ? new Date(c.date_passage) : null;
          return d && d <= now;
        });
        const montantTotal = paiements.reduce((sum, p) => sum + (p.montant ?? 0), 0);

        return {
          totalClients:        clients.length,
          totalChauffeurs:     chauffeurs.length,
          totalCourses:        courses.length,
          totalPaiements:      paiements.length,
          montantTotal,
          tauxCollecte:        courses.length > 0 ? Math.round((coursesPassees.length / courses.length) * 100) : 0,
          revenusMensuelsFCFA: montantTotal,
          tauxImpayes:         0,
        };
      })
    );
  }

  // Actions récentes = derniers paiements + dernières réclamations
  getRecentActions(): Observable<RecentAction[]> {
    return forkJoin({
      paiements:   this.http.get<any[]>(API.paiements.findAll),
      reclamations: this.http.get<any[]>(API.reclamations.findAll),
    }).pipe(
      map(({ paiements, reclamations }) => {
        const actions: RecentAction[] = [];

        paiements.slice(-5).reverse().forEach(p => {
          actions.push({
            title: `Paiement ${p.nomModePaiement}`,
            desc:  `${p.montant ?? 0} FCFA — N° ${p.numero ?? ''}`,
            time:  p.dateVersement ? new Date(p.dateVersement).toLocaleDateString('fr-FR') : '',
            type:  'payment',
          });
        });

        reclamations.slice(-3).reverse().forEach(r => {
          actions.push({
            title: `Réclamation : ${r.objet}`,
            desc:  r.description,
            time:  '',
            type:  'complaint',
          });
        });

        return actions;
      })
    );
  }
}
