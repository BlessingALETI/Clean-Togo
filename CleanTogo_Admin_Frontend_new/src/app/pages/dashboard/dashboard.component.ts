import { AfterViewInit, Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { DashboardService } from '../../core/services/dashboard.service';
import { DashboardStats } from '../../models/dashboard-stats.model';
import { ToursService } from '../../core/services/tours.service';
import { Tour } from '../../models/tour.model';

import Chart from 'chart.js/auto';

type ActionItem = {
  title: string;
  desc: string;
  time: string;
  type: 'Planning' | 'Paiement' | 'Réclamation';
  badgeClass: string;
  dotClass: string;
};

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit, AfterViewInit {
  loading = true;
  stats: DashboardStats | null = null;

  tours: Tour[] = [];
  actions: ActionItem[] = [];

  @ViewChild('zoneChart') zoneChart!: ElementRef<HTMLCanvasElement>;
  private chart?: Chart;

  constructor(
    private dash: DashboardService,
    private toursSvc: ToursService
  ) {}

  ngOnInit(): void {
    // Stats cards
    this.dash.getStats().subscribe(s => {
      this.stats = s;
      this.loading = false;
    });

    // Données pour le graphique
    this.toursSvc.list().subscribe(list => {
      this.tours = list;
      this.buildActions(list);
      this.renderZoneChart(); // si canvas déjà prêt, ça marche
    });
  }

  ngAfterViewInit(): void {
    // Si les données arrivent après le canvas, on render aussi ici
    this.renderZoneChart();
  }

  private renderZoneChart() {
    if (!this.zoneChart?.nativeElement) return;
    if (!this.tours?.length) return;

    // Calcul: nombre de tournées par zone (simple)
    const map = new Map<string, number>();
    for (const t of this.tours) {
      if (t.zone) {
        map.set(t.zone, (map.get(t.zone) ?? 0) + 1);
      }
    }

    const labels = Array.from(map.keys());
    const values = Array.from(map.values());

    // détruire ancien chart si refresh
    if (this.chart) this.chart.destroy();

    this.chart = new Chart(this.zoneChart.nativeElement, {
      type: 'bar',
      data: {
        labels,
        datasets: [{
          label: 'Nombre de tournées',
          data: values
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false }
        },
        scales: {
          y: { beginAtZero: true }
        }
      }
    });
  }

  private buildActions(list: Tour[]) {
    // Actions démo (tu peux ensuite les brancher à un endpoint “logs”)
    // Ici: on génère 3 actions intelligentes à partir des tournées
    const last = [...list].slice(-3).reverse();

    this.actions = last.map((t, idx) => {
      const when = t.dateISO ?? '';
      const isPlanned = t.status === 'Planifiée';
      const isRunning = t.status === 'En cours';

      const type: ActionItem['type'] = 'Planning';
      const badgeClass = 'bg-success-subtle text-success border border-success-subtle';
      const dotClass = 'dot-success';

      return {
        title: isPlanned ? 'Tournée planifiée' : (isRunning ? 'Tournée en cours' : 'Tournée terminée'),
        desc: `Zone: ${t.zone} • Foyers: ${t.foyersCount}`,
        time: when,
        type,
        badgeClass,
        dotClass
      };
    });

    // Tu peux ajouter des actions fixes en plus si tu veux :
    this.actions.unshift({
      title: 'Paiement reçu',
      desc: 'Un paiement a été enregistré (démo).',
      time: new Date().toISOString().slice(0, 10),
      type: 'Paiement',
      badgeClass: 'bg-primary-subtle text-primary border border-primary-subtle',
      dotClass: 'dot-primary'
    });

    this.actions.unshift({
      title: 'Réclamation ouverte',
      desc: 'Une nouvelle réclamation a été créée (démo).',
      time: new Date().toISOString().slice(0, 10),
      type: 'Réclamation',
      badgeClass: 'bg-danger-subtle text-danger border border-danger-subtle',
      dotClass: 'dot-danger'
    });
  }
}