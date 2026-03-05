import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, BehaviorSubject, tap } from 'rxjs';
import { API } from '../api/endpoints';
import { TokenStorageService } from './token-storage.service';

export type LoginRequest = { email: string; password: string };
export type LoginResponse = { token: string; role?: string; email?: string; fullName?: string };

export type CurrentUser = {
  fullName: string;
  email: string;
  role?: string;
};

const USER_KEY = 'cleantogo_user';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private user$ = new BehaviorSubject<CurrentUser | null>(this.readUser());

  constructor(private http: HttpClient, private tokens: TokenStorageService) {}

  login(payload: LoginRequest): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(API.auth.login, payload).pipe(
      tap(res => {
        if (res?.token) this.tokens.set(res.token);

        // if backend returns identity in login response, cache it
        const user: CurrentUser | null = (res?.email || res?.fullName)
          ? { fullName: res.fullName ?? 'Administrateur', email: res.email ?? payload.email, role: res.role }
          : null;

        if (user) this.setUser(user);
      })
    );
  }

  /** Fetch /auth/me and cache it */
  me(): Observable<CurrentUser> {
    return this.http.get<CurrentUser>(API.auth.me).pipe(
      tap(u => this.setUser(u))
    );
  }

  logout() {
    this.tokens.clear();
    localStorage.removeItem(USER_KEY);
    this.user$.next(null);
  }

  token(): string | null {
    return this.tokens.get();
  }

  isAuthenticated(): boolean {
    return !!this.token();
  }

  /** Used by templates (Topbar/Profile) */
  currentUser(): CurrentUser | null {
    return this.user$.value;
  }

  /** Optional: subscribe to user changes */
  userChanges(): Observable<CurrentUser | null> {
    return this.user$.asObservable();
  }

  private setUser(u: CurrentUser) {
    localStorage.setItem(USER_KEY, JSON.stringify(u));
    this.user$.next(u);
  }

  private readUser(): CurrentUser | null {
    try {
      const raw = localStorage.getItem(USER_KEY);
      return raw ? (JSON.parse(raw) as CurrentUser) : null;
    } catch {
      return null;
    }
  }
}
