import { Component, OnInit } from '@angular/core';
import { UsersService } from '../../core/services/users.service';
import { User } from '../../models/user.model';

@Component({
  selector: 'app-clients',
  templateUrl: './clients.component.html',
  styleUrls: ['./clients.component.scss']
})
export class ClientsComponent implements OnInit {
  loading = true;
  q = '';
  clients: User[] = [];
  filtered: User[] = [];

  // modal edit
  editing: User | null = null;
  editForm = {
    id: '',
    nom: '',
    prenom: '',
    email: '',
    phone: '',
    username: '',
    role: 'CLIENT' as User['role'],
    statut: true as boolean,
    quartier: '',
    abonnement: 'Standard' as any,
    status: 'Actif' as any
  };

  constructor(private users: UsersService) {}

  ngOnInit(): void {
    this.users.listClients().subscribe(list => {
      this.clients = list;
      this.apply();
      this.loading = false;
    });
  }

  apply() {
    const s = this.q.trim().toLowerCase();
    this.filtered = !s ? this.clients : this.clients.filter(c =>
      (c.nom && c.nom.toLowerCase().includes(s)) ||
      (c.prenom && c.prenom.toLowerCase().includes(s)) ||
      (c.email && c.email.toLowerCase().includes(s)) ||
      (c.phone && c.phone.toLowerCase().includes(s)) ||
      (c.username && c.username.toLowerCase().includes(s))
    );
  }

  openEdit(c: User) {
    this.editing = c;

    this.editForm = {
      id: c.id?.toString() ?? '',
      nom: c.nom ?? '',
      prenom: c.prenom ?? '',
      email: c.email ?? '',
      phone: c.phone ?? '',
      username: c.username ?? '',
      role: c.role,
      statut: c.statut,
      quartier: c.quartier ?? '',
      abonnement: c.abonnement,
      status: c.status
    };
  }

  closeEdit() {
    this.editing = null;
  }

  saveEdit() {
    if (!this.editing) return;

    const updated: User = {
      id: this.editForm.id,
      role: this.editForm.role,
      nom: this.editForm.nom.trim(),
      prenom: this.editForm.prenom.trim(),
      email: this.editForm.email.trim(),
      phone: this.editForm.phone.trim(),
      username: this.editForm.username.trim(),
      statut: this.editForm.statut,
      quartier: this.editForm.quartier.trim(),
      abonnement: this.editForm.abonnement,
      status: this.editForm.status
    };

    // Sauvegarde via service (MockStore pour l'instant)
    this.users.saveClient(updated);
    // Mise à jour du tableau local
    const i = this.clients.findIndex(x => x.id === updated.id);
    if (i >= 0) this.clients[i] = updated;

    this.apply();
    this.closeEdit();
  }

remove(c: User) {
  if (c.id == null) return;

  const ok = confirm(`Supprimer le client "${c.nom} ${c.prenom}" ?`);
  if (!ok) return;

  this.users.deleteClient(c.id).subscribe(() => {
    this.clients = this.clients.filter(x => x.id !== c.id);
    this.apply();
  });
}
}