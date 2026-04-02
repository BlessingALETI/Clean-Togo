import { Component, OnInit } from '@angular/core';
import { ToursService } from '../../core/services/tours.service';
import { UsersService } from '../../core/services/users.service';
import { Tour } from '../../models/tour.model';
import { User } from '../../models/user.model';

@Component({
  selector: 'app-tours',
  templateUrl: './tours.component.html',
  styleUrls: ['./tours.component.scss']
})
export class ToursComponent implements OnInit {
  loading  = true;
  tours:   Tour[] = [];
  drivers: User[] = [];
  creating = false;

  // Formulaire de création
  dateISO    = new Date().toISOString().slice(0, 10);
  zone       = '';
  driverId: string | null = null;
  foyersCount = 20;

  constructor(private toursSvc: ToursService, private users: UsersService) {}

  ngOnInit(): void {
    this.users.listDrivers().subscribe(d => this.drivers = d);
    this.refresh();
  }

  refresh() {
    this.loading = true;
    this.toursSvc.list().subscribe(list => {
      // Adapte les champs backend → champs affichés en front
      this.tours = list.map(t => ({
        ...t,
        dateISO:     t.date_passage,
        zone:        t.secteurs?.map(s => s.nom_secteur).join(', ') ?? '',
        foyersCount: t.secteurs?.reduce((sum, s) => sum, 0) ?? 0,
        status:      this.computeStatus(t.date_passage),
      }));
      this.loading = false;
    });
  }

  create() {
    if (!this.zone.trim()) return;
    // Backend attend : { date_passage: "yyyy-MM-dd", secteurs: [] }
    const t: Tour = {
      date_passage: this.dateISO,
      secteurs: this.zone.trim().split(',').map(z => ({ nom_secteur: z.trim() })),
    };
    this.toursSvc.save(t).subscribe(() => {
      this.zone     = '';
      this.driverId = null;
      this.creating = false;
      this.refresh();
    });
  }

  delete(id: string | number | undefined) {
    if (!id) return;
    this.toursSvc.delete(id).subscribe(() => this.refresh());
  }

  driverName(id: string | null): string {
    if (!id) return 'Non assigné';
    return this.drivers.find(x => String(x.id) === id)?.fullName ?? 'Inconnu';
  }

  private computeStatus(dateStr?: string): 'Planifiée' | 'En cours' | 'Terminée' {
    if (!dateStr) return 'Planifiée';
    const d   = new Date(dateStr);
    const now = new Date();
    if (d > now) return 'Planifiée';
    const diff = now.getTime() - d.getTime();
    return diff < 86400000 ? 'En cours' : 'Terminée';
  }
}
