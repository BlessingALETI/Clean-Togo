import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../../core/services/auth.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent {
  email    = '';
  password = '';
  error    = '';
  loading  = false;

  constructor(private auth: AuthService, private router: Router) {}

  submit() {
    this.error   = '';
    this.loading = true;

    this.auth.login({ email: this.email, password: this.password }).subscribe({
      next: () => {
        // Pas de /auth/me dans le backend → on charge le profil via /utilisateurs/findAll
        this.auth.loadProfile().subscribe();
        this.loading = false;
        this.router.navigateByUrl('/dashboard');
      },
      error: (e) => {
        this.loading = false;
        this.error = e?.error?.message || 'Identifiants incorrects ou API indisponible.';
      }
    });
  }
}
