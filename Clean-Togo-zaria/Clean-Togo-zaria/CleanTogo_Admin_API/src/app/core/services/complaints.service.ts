import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { API } from '../api/endpoints';
import { Complaint } from '../../models/complaint.model';

@Injectable({ providedIn: 'root' })
export class ComplaintsService {
  constructor(private http: HttpClient) {}

  // GET /commentaireReclamations/findAll
  list(): Observable<Complaint[]> {
    return this.http.get<Complaint[]>(API.reclamations.findAll);
  }

  // GET /commentaireReclamations/findById/{id}
  getById(id: string | number): Observable<Complaint> {
    return this.http.get<Complaint>(API.reclamations.findById(id));
  }

  // POST /commentaireReclamations/save
  // PUT  /commentaireReclamations/update/{id}
  save(item: Complaint): Observable<Complaint> {
    if (item.id) {
      return this.http.put<Complaint>(API.reclamations.update(item.id), item);
    }
    return this.http.post<Complaint>(API.reclamations.save, item);
  }

  // DELETE /commentaireReclamations/delete/{id}
  delete(id: string | number): Observable<void> {
    return this.http.delete<void>(API.reclamations.delete(id));
  }

  // ⚠️ Le backend n'a pas de PATCH /status → on utilise PUT update
  updateStatus(id: string | number, status: string): Observable<Complaint> {
    return this.http.put<Complaint>(API.reclamations.update(id), { status });
  }
}
