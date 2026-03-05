import { TestBed } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { AuthService } from './auth.service';

describe('AuthService', () => {
  it('should login with demo credentials', () => {
    TestBed.configureTestingModule({ imports: [RouterTestingModule] });
    const auth = TestBed.inject(AuthService);

    expect(auth.login('admin@cleantogo.tg', 'admin123')).toBeTrue();
    expect(auth.isAuthenticated()).toBeTrue();
  });
});
