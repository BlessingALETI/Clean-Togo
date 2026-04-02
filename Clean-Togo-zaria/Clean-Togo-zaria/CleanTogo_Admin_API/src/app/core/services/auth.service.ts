import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, BehaviorSubject, tap, map, catchError, of } from 'rxjs';
import { API } from '../api/endpoints';
import { TokenStorageService } from './token-storage.service';

export interface LoginRequest  { email: string; password: string; }

// Backend retourne : token, username, email, role
export interface LoginResponse {
  token:     string;
  username?: string;
  email?:    string;
  role?:     string;
}

export interface CurrentUser {
  fullName: string;
  email:    string;
  role?:    string;
  id?:      string | number;
}

const USER_KEY = 'cleantogo_user';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private user$ = new BehaviorSubject<CurrentUser | null>(this.readUser());

  constructor(private http: HttpClient, private tokens: TokenStorageService) {}

  // POST /api/auth/authenticate  {email, password}
  // Backend retourne : {token, username, email, role}
  login(payload: LoginRequest): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(API.auth.login, payload).pipe(
      tap(res => {
        if (res?.token) this.tokens.set(res.token);
        const user: CurrentUser = {
          fullName: res.username ?? res.email ?? 'Administrateur',
          email:    res.email ?? payload.email,
          role:     res.role,
        };
        this.setUser(user);
      })
    );
  }

  // Pas de /auth/me dans le backend → on charge depuis /utilisateurs/findAll
  // Cette méthode charge le profil en cherchant par email
  loadProfile(): Observable<CurrentUser | null> {
    const cached = this.readUser();
    if (!cached?.email) return of(null);

    return this.http.get<any[]>(API.utilisateurs.findAll).pipe(
      map(list => {
        const u = list.find(x => x.email === cached.email);
        if (!u) return cached;
        const user: CurrentUser = {
          fullName: `${u.prenom ?? ''} ${u.nom ?? ''}`.trim() || u.username || cached.fullName,
          email:    u.email,
          role:     u.role,
          id:       u.id,
        };
        this.setUser(user);
        return user;
      }),
      catchError(() => of(cached))
    );
  }

  logout() {
    this.tokens.clear();
    localStorage.removeItem(USER_KEY);
    this.user$.next(null);
  }

  token():           string | null   { return this.tokens.get(); }
  isAuthenticated(): boolean         { return !!this.token(); }
  currentUser():     CurrentUser | null { return this.user$.value; }
  userChanges():     Observable<CurrentUser | null> { return this.user$.asObservable(); }

  private setUser(u: CurrentUser) {
    localStorage.setItem(USER_KEY, JSON.stringify(u));
    this.user$.next(u);
  }

  private readUser(): CurrentUser | null {
    try {
      const raw = localStorage.getItem(USER_KEY);
      return raw ? JSON.parse(raw) : null;
    } catch { return null; }
  }
}
