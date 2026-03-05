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
      this.drivers = list;
      this.loading = false;
    });
  }
}
