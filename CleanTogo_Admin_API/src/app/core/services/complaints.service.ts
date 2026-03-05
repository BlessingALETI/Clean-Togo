import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { API } from '../api/endpoints';

@Injectable({ providedIn: 'root' })
export class ComplaintsService {
  constructor(private http: HttpClient) {}

  list(): Observable<any[]> {
    return this.http.get<any[]>(API.complaints);
  }

  save(item: any): Observable<any> {
    return item?.id
      ? this.http.put<any>(`${API.complaints}/${item.id}`, item)
      : this.http.post<any>(API.complaints, item);
  }

  delete(id: string): Observable<void> {
    return this.http.delete<void>(`${API.complaints}/${id}`);
  }

  /** Update only status (endpoint à adapter selon ton Spring Boot) */
  updateStatus(id: string, status: string): Observable<any> {
    // Option A (souvent utilisé): PATCH /complaints/{id}/status {status}
    return this.http.patch<any>(`${API.complaints}/${id}/status`, { status });

    // Option B: PATCH /complaints/{id} {status}
    // return this.http.patch<any>(`${API.complaints}/${id}`, { status });
  }
}
