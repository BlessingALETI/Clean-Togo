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

  constructor(private users: UsersService) {}

  ngOnInit(): void {
    this.users.listDrivers().subscribe(list => {
      // Calcule fullName depuis nom + prenom (backend renvoie les deux séparément)
      this.drivers = list.map(d => ({
        ...d,
        fullName: `${d.prenom ?? ''} ${d.nom ?? ''}`.trim()
      }));
      this.loading = false;
    });
  }
}
