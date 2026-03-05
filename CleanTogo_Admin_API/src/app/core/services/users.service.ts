import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { API } from '../api/endpoints';
import { User } from '../../models/user.model';

@Injectable({ providedIn: 'root' })
export class UsersService {
  constructor(private http: HttpClient) {}

  // Clients
  listClients(): Observable<User[]> {
    return this.http.get<User[]>(API.clients);
  }

  saveClient(u: User): Observable<User> {
    return u.id ? this.http.put<User>(`${API.clients}/${u.id}`, u) : this.http.post<User>(API.clients, u);
  }

  deleteClient(id: string): Observable<void> {
    return this.http.delete<void>(`${API.clients}/${id}`);
  }

  // Drivers
  listDrivers(): Observable<User[]> {
    return this.http.get<User[]>(API.drivers);
  }

  saveDriver(u: User): Observable<User> {
    return u.id ? this.http.put<User>(`${API.drivers}/${u.id}`, u) : this.http.post<User>(API.drivers, u);
  }

  deleteDriver(id: string): Observable<void> {
    return this.http.delete<void>(`${API.drivers}/${id}`);
  }

  // Zones derived from clients (recommended endpoint)
  getClientZones(): Observable<string[]> {
    return this.http.get<string[]>(`${API.clients}/zones`);
  }
}
