import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { API } from '../api/endpoints';
import { Payment } from '../../models/payment.model';

@Injectable({ providedIn: 'root' })
export class PaymentsService {
  constructor(private http: HttpClient) {}

  // GET /paiements/findAll
  list(): Observable<Payment[]> {
    return this.http.get<Payment[]>(API.paiements.findAll);
  }

  // GET /paiements/findById/{id}
  getById(id: string | number): Observable<Payment> {
    return this.http.get<Payment>(API.paiements.findById(id));
  }

  // POST /paiements/save  → crée un paiement
  // PUT  /paiements/update/{id} → modifie
  save(item: Payment): Observable<Payment> {
    if (item.id) {
      return this.http.put<Payment>(API.paiements.update(item.id), item);
    }
    return this.http.post<Payment>(API.paiements.save, item);
  }

  // DELETE /paiements/delete/{id}
  delete(id: string | number): Observable<void> {
    return this.http.delete<void>(API.paiements.delete(id));
  }
}
