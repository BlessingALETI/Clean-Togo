import { Component, OnInit } from '@angular/core';
import { ToursService } from '../../core/services/tours.service';
import { UsersService } from '../../core/services/users.service';
import { Tour } from '../../models/tour.model';
import { User } from '../../models/user.model';

type DayCol = { label: string; dateISO: string; items: Tour[] };

@Component({
  selector: 'app-tours',
  templateUrl: './tours.component.html',
  styleUrls: ['./tours.component.scss']
})
export class ToursComponent implements OnInit {
  loading = true;

  tours: Tour[] = [];
  drivers: User[] = [];
  zones: string[] = [];

  // week view
  week: DayCol[] = [];

  // Create button
  creating = false;

  // modal add/edit
  modalOpen = false;
  editing: Tour | null = null;

  form = {
    id: '',
    dateISO: new Date().toISOString().slice(0, 10),
    zone: '',
    driverId: null as string | null,
    foyersCount: 20,
    status: 'Planifiée' as Tour['status']
  };

  // details drawer (simple)
  details: Tour | null = null;

  constructor(private toursSvc: ToursService, private users: UsersService) {}

  ngOnInit(): void {
    this.users.listDrivers().subscribe(d => (this.drivers = d));
    this.users.getClientZones().subscribe(z => (this.zones = z));
    this.refresh();
  }

  refresh() {
    this.loading = true;
    this.toursSvc.list().subscribe(list => {
      // tri par date
      this.tours = [...list].filter(t => t.dateISO).sort((a, b) => a.dateISO!.localeCompare(b.dateISO!));
      this.week = this.buildWeek(this.mondayOfCurrentWeek(), this.tours);
      this.loading = false;
    });
  }

  // ---- Week helpers ----
  private mondayOfCurrentWeek(): Date {
    const now = new Date();
    const day = now.getDay(); // 0 Sun..6 Sat
    const diff = (day === 0 ? -6 : 1) - day; // make Monday
    const monday = new Date(now);
    monday.setDate(now.getDate() + diff);
    monday.setHours(0, 0, 0, 0);
    return monday;
  }

  private buildWeek(monday: Date, tours: Tour[]): DayCol[] {
    const labels = ['LUNDI','MARDI','MERCREDI','JEUDI','VENDREDI','SAMEDI','DIMANCHE'];
    const cols: DayCol[] = [];

    for (let i = 0; i < 7; i++) {
      const d = new Date(monday);
      d.setDate(monday.getDate() + i);
      const dateISO = d.toISOString().slice(0, 10);
      cols.push({
        label: labels[i],
        dateISO,
        items: tours.filter(t => t.dateISO === dateISO)
      });
    }
    return cols;
  }

  // ---- Display helpers ----
  driverName(id: string | null): string {
    if (!id) return 'Non assigné';
    return this.drivers.find(x => x.id === id)?.fullName ?? 'Inconnu';
  }

  statusClass(s: Tour['status']): string {
    if (s === 'Planifiée') return 'badge-soft';
    if (s === 'En cours') return 'badge-warn';
    return 'badge-ok';
  }

  // ---- Actions UI ----
  openCreate() {
    this.editing = null;
    this.form = {
      id: '',
      dateISO: new Date().toISOString().slice(0, 10),
      zone: '',
      driverId: null,
      foyersCount: 20,
      status: 'Planifiée'
    };
    this.modalOpen = true;
  }

  openEdit(t: Tour) {
    this.editing = t;
    this.form = {
      id: t.id?.toString() ?? '',
      dateISO: t.dateISO ?? new Date().toISOString().slice(0, 10),
      zone: t.zone || '',
      driverId: t.driverId ?? null,
      foyersCount: t.foyersCount ?? 20,
      status: t.status
    };
    this.modalOpen = true;
  }

  closeModal() {
    this.modalOpen = false;
  }

  save() {
    if (!this.form.zone.trim()) return;

    const id = this.editing ? this.form.id : 't' + Math.floor(Math.random() * 100000);

    const t: Tour = {
      id,
      date_passage: this.form.dateISO,
      zone: this.form.zone.trim(),
      driverId: this.form.driverId,
      foyersCount: Number(this.form.foyersCount || 0),
      status: this.form.status,
      dateISO: this.form.dateISO
    };

    this.toursSvc.save(t).subscribe(() => {
      this.closeModal();
      this.refresh();
    });
  }

  remove(t: Tour) {
    const ok = confirm(`Supprimer la tournée "${t.zone}" du ${t.dateISO} ?`);
    if (!ok) return;
    if (!t.id) return;

    this.toursSvc.delete(t.id).subscribe(() => this.refresh());
  }

  openDetails(t: Tour) {
    this.details = t;
  }

  closeDetails() {
    this.details = null;
  }
}