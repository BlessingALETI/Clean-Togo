import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { API } from '../api/endpoints';
import { Tour } from '../../models/tour.model';

@Injectable({ providedIn: 'root' })
export class ToursService {
  constructor(private http: HttpClient) {}

  list(): Observable<Tour[]> {
    return this.http.get<Tour[]>(API.tours);
  }

  save(t: Tour): Observable<Tour> {
    return t.id ? this.http.put<Tour>(`${API.tours}/${t.id}`, t) : this.http.post<Tour>(API.tours, t);
  }

  delete(id: string): Observable<void> {
    return this.http.delete<void>(`${API.tours}/${id}`);
  }
}
