import { Component, OnInit } from '@angular/core';
import { ComplaintsService } from '../../core/services/complaints.service';
import { UsersService } from '../../core/services/users.service';
import { Complaint } from '../../models/complaint.model';
import { User } from '../../models/user.model';

@Component({
  selector: 'app-complaints',
  templateUrl: './complaints.component.html',
  styleUrls: ['./complaints.component.scss']
})
export class ComplaintsComponent implements OnInit {
  loading = true;
  list: Complaint[] = [];
  clients: User[] = [];

  constructor(private svc: ComplaintsService, private users: UsersService) {}

  ngOnInit(): void {
    this.users.listClients().subscribe(c => this.clients = c);
    this.refresh();
  }

  refresh() {
    this.loading = true;
    this.svc.list().subscribe(l => { this.list = l; this.loading = false; });
  }

  clientName(id: string | number | undefined): string {
    if (!id) return 'Inconnu';
    return this.clients.find(x => String(x.id) === String(id))?.fullName ?? String(id);
  }

  setStatus(c: Complaint, status: Complaint['status']) {
    // id peut être number ou string — on le cast en string | number (jamais undefined ici)
    if (c.id == null) return;
    this.svc.updateStatus(c.id, status ?? '').subscribe(() => this.refresh());
  }
}
