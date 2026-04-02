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

  constructor(private users: UsersService) {}

  ngOnInit(): void {
    this.users.listClients().subscribe(list => {
      this.clients = list.map(c => ({
        ...c,
        // backend: nom + prenom séparés → on construit fullName
        fullName:    `${c.prenom ?? ''} ${c.nom ?? ''}`.trim(),
        // backend: pas de quartier → on affiche l'email ou vide
        quartier:    (c as any).quartier ?? '—',
        // backend: pas d'abonnement → vide
        abonnement:  (c as any).abonnement ?? '—',
        // backend: statut boolean → on convertit en texte
        status:      c.statut ? 'Actif' : 'Suspendu',
      }));
      this.apply();
      this.loading = false;
    });
  }

  apply() {
    const s = this.q.trim().toLowerCase();
    this.filtered = !s ? this.clients : this.clients.filter(c =>
      (c.fullName ?? '').toLowerCase().includes(s) ||
      (c.phone    ?? '').toLowerCase().includes(s) ||
      (c.email    ?? '').toLowerCase().includes(s)
    );
  }
}
