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
  loading = true;
  tours: Tour[] = [];
  drivers: User[] = [];
  creating = false;

  // simple form
  dateISO = new Date().toISOString().slice(0,10);
  zone = '';
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
      this.tours = list;
      this.loading = false;
    });
  }

  create() {
    if (!this.zone.trim()) return;
    const id = 't' + Math.floor(Math.random()*100000);
    const t = new Tour(id, this.dateISO, this.zone.trim(), this.driverId, this.foyersCount, 'Planifiée');
    this.toursSvc.save(t).subscribe(() => {
      this.zone = '';
      this.driverId = null;
      this.creating = false;
      this.refresh();
    });
  }

  driverName(id: string | null): string {
    if (!id) return 'Non assigné';
    return this.drivers.find(x => x.id === id)?.fullName ?? 'Inconnu';
  }
}
