import { Component, OnInit } from '@angular/core';
import { UsersService } from '../../core/services/users.service';
import { User } from '../../models/user.model';

@Component({
  selector: 'app-drivers',
  templateUrl: './drivers.component.html',
  styleUrls: ['./drivers.component.scss']
})
export class DriversComponent implements OnInit {
  loading = true;

  drivers: User[] = [];

  // modal (add/edit)
  editing: User | null = null;     // si null => ajout, sinon => modification
  modalOpen = false;

  form = {
    id: '',
    nom: '',
    prenom: '',
    email: '',
    phone: '',
    username: '',
    quartier: '',
    statut: true as boolean,
    role: 'CHAUFFEUR' as User['role'],
    abonnement: 'Standard' as any,
    status: 'Actif' as any
  };

  constructor(private users: UsersService) {}

  ngOnInit(): void {
    this.refresh();
  }

  refresh() {
    this.loading = true;
    this.users.listDrivers().subscribe(list => {
      this.drivers = list;
      this.loading = false;
    });
  }

  openAdd() {
    this.editing = null;
    this.form = {
      id: '',
      nom: '',
      prenom: '',
      email: '',
      phone: '',
      username: '',
      quartier: '',
      statut: true,
      role: 'CHAUFFEUR',
      abonnement: 'Standard',
      status: 'Actif'
    };
    this.modalOpen = true;
  }

  openEdit(d: User) {
    this.editing = d;
    this.form = {
      id: String(d.id) || '',
      nom: d.nom || '',
      prenom: d.prenom || '',
      email: d.email || '',
      phone: d.phone || '',
      username: d.username || '',
      quartier: d.quartier || '',
      statut: d.statut,
      role: d.role,
      abonnement: d.abonnement,
      status: d.status
    };
    this.modalOpen = true;
  }

  close() {
    this.modalOpen = false;
  }

  save() {
    if (!this.form.nom.trim() || !this.form.prenom.trim() || !this.form.email.trim() || !this.form.phone.trim()) return;

    const id = this.editing ? this.form.id : ('d' + Math.floor(Math.random() * 100000));

    const driver: User = {
      id,
      role: 'CHAUFFEUR',
      nom: this.form.nom.trim(),
      prenom: this.form.prenom.trim(),
      email: this.form.email.trim(),
      phone: this.form.phone.trim(),
      username: this.form.username.trim(),
      quartier: this.form.quartier.trim(),
      statut: this.form.statut,
      abonnement: this.form.abonnement,
      status: this.form.status
    };

    this.users.saveDriver(driver);
    this.close();
    this.refresh();
  }

  remove(d: User) {
    const ok = confirm(`Supprimer le chauffeur "${d.nom} ${d.prenom}" ?`);
    if (!ok) return;

    if (d.id !== undefined) {
      this.users.deleteDriver(d.id).subscribe(() => this.refresh());
    }
  }
}