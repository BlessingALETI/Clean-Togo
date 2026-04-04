import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { API } from '../api/endpoints';
import { map } from 'rxjs/operators';
import { User, RegisterRequest } from '../../models/user.model';

@Injectable({ providedIn: 'root' })
export class UsersService {
  saveClient(updated: any) {
    throw new Error('Method not implemented.');
  }
  saveDriver(driver: any) {
    throw new Error('Method not implemented.');
  }
  constructor(private http: HttpClient) {}

  // ── CLIENTS  GET /clients/findAll ─────────────────────────────
  listClients(): Observable<User[]> {
    return this.http.get<User[]>(API.clients.findAll);
  }

  getClient(id: string | number): Observable<User> {
    return this.http.get<User>(API.clients.findById(id));
  }

  // PUT /clients/update/{id}
  updateClient(id: string | number, data: Partial<User>): Observable<User> {
    return this.http.put<User>(API.clients.update(id), data);
  }

  // DELETE /clients/delete/{id}
  deleteClient(id: string | number): Observable<void> {
    return this.http.delete<void>(API.clients.delete(id));
  }

  // ── CHAUFFEURS  GET /chauffeurs/findAll ───────────────────────
  listDrivers(): Observable<User[]> {
    return this.http.get<User[]>(API.chauffeurs.findAll);
  }

  getDriver(id: string | number): Observable<User> {
    return this.http.get<User>(API.chauffeurs.findById(id));
  }

  // PUT /chauffeurs/update/{id}
  updateDriver(id: string | number, data: Partial<User>): Observable<User> {
    return this.http.put<User>(API.chauffeurs.update(id), data);
  }

  // DELETE /chauffeurs/delete/{id}
  deleteDriver(id: string | number): Observable<void> {
    return this.http.delete<void>(API.chauffeurs.delete(id));
  }

  // ── CRÉATION via /api/auth/register ───────────────────────────
  // (pour créer un CLIENT ou CHAUFFEUR)
  createUser(req: RegisterRequest): Observable<any> {
    return this.http.post<any>(API.auth.register, req);
  }

  // ── UTILISATEURS (tous) GET /utilisateurs/findAll ─────────────
  listAll(): Observable<User[]> {
    return this.http.get<User[]>(API.utilisateurs.findAll);
  }

  updateUtilisateur(id: string | number, data: Partial<User>): Observable<User> {
    return this.http.put<User>(API.utilisateurs.update(id), data);
  }

  deleteUtilisateur(id: string | number): Observable<void> {
    return this.http.delete<void>(API.utilisateurs.delete(id));
  }

  getClientZones(): Observable<string[]> {
  return this.listClients().pipe(
    map(list => {
      const zones = list
        .map(c => (c.quartier || '').trim())
        .filter(z => !!z);
      return Array.from(new Set(zones)).sort((a, b) => a.localeCompare(b));
    })
  );
}
}
