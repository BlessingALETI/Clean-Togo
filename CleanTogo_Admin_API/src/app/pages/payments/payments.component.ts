import { Component, OnInit } from '@angular/core';
import { PaymentsService } from '../../core/services/payments.service';
import { UsersService } from '../../core/services/users.service';
import { Payment } from '../../models/payment.model';
import { User } from '../../models/user.model';

@Component({
  selector: 'app-payments',
  templateUrl: './payments.component.html',
  styleUrls: ['./payments.component.scss']
})
export class PaymentsComponent implements OnInit {
  loading = true;
  payments: Payment[] = [];
  clients: User[] = [];

  constructor(private pay: PaymentsService, private users: UsersService) {}

  ngOnInit(): void {
    this.users.listClients().subscribe(c => this.clients = c);
    this.pay.list().subscribe(list => {
      this.payments = list;
      this.loading = false;
    });
  }

  clientName(id: string): string {
    return this.clients.find(x => x.id === id)?.fullName ?? id;
  }

  totalPaid(): number {
    return this.payments.filter(p=>p.status==='Payé').reduce((s,p)=>s+p.amountFCFA,0);
  }
}
