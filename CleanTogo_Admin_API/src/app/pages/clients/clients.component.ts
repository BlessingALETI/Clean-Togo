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
      this.clients = list;
      this.apply();
      this.loading = false;
    });
  }

  apply() {
    const s = this.q.trim().toLowerCase();
    this.filtered = !s ? this.clients : this.clients.filter(c =>
      c.fullName.toLowerCase().includes(s) ||
      c.phone.toLowerCase().includes(s) ||
      c.quartier.toLowerCase().includes(s)
    );
  }
}
