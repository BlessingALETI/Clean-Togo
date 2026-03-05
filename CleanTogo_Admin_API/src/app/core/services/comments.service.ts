import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { API } from '../api/endpoints';

@Injectable({ providedIn: 'root' })
export class CommentsService {
  constructor(private http: HttpClient) { }

  list(): Observable<any[]> {
    return this.http.get<any[]>(API.comments);
  }

  save(item: any): Observable<any> {
    return item?.id ? this.http.put<any>(`${API.comments}/${item.id}`, item) : this.http.post<any>(API.comments, item);
  }

  delete(id: string): Observable<void> {
    return this.http.delete<void>(`${API.comments}/${id}`);
  }
}
