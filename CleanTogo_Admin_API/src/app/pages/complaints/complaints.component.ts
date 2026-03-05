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

  clientName(id: string): string {
    return this.clients.find(x => x.id === id)?.fullName ?? id;
  }

  setStatus(c: Complaint, status: Complaint['status']) {
    this.svc.updateStatus(c.id, status).subscribe(() => this.refresh());
  }
}
