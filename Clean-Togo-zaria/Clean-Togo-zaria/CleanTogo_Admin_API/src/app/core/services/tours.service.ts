import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { API } from '../api/endpoints';
import { Tour } from '../../models/tour.model';

@Injectable({ providedIn: 'root' })
export class ToursService {
  constructor(private http: HttpClient) {}

  // GET /courses/findAll
  list(): Observable<Tour[]> {
    return this.http.get<Tour[]>(API.courses.findAll);
  }

  // GET /courses/findById/{id}
  getById(id: string | number): Observable<Tour> {
    return this.http.get<Tour>(API.courses.findById(id));
  }

  // POST /courses/save  → crée une course
  // PUT  /courses/update/{id} → modifie
  save(t: Tour): Observable<Tour> {
    if (t.id) {
      return this.http.put<Tour>(API.courses.update(t.id), t);
    }
    return this.http.post<Tour>(API.courses.save, t);
  }

  // DELETE /courses/delete/{id}
  delete(id: string | number): Observable<void> {
    return this.http.delete<void>(API.courses.delete(id));
  }
}
