import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { API } from '../api/endpoints';

// ⚠️ Le backend n'a pas de table "comments" séparée.
// Les commentaires/réclamations sont dans Commentaire_Reclamation (objet + description)
// Ce service utilise donc le même endpoint que ComplaintsService.

@Injectable({ providedIn: 'root' })
export class CommentsService {
  constructor(private http: HttpClient) {}

  // GET /commentaireReclamations/findAll
  list(): Observable<any[]> {
    return this.http.get<any[]>(API.reclamations.findAll);
  }

  // POST /commentaireReclamations/save
  save(item: any): Observable<any> {
    if (item?.id) {
      return this.http.put<any>(API.reclamations.update(item.id), item);
    }
    return this.http.post<any>(API.reclamations.save, item);
  }

  // DELETE /commentaireReclamations/delete/{id}
  delete(id: string | number): Observable<void> {
    return this.http.delete<void>(API.reclamations.delete(id));
  }
}
