import { AdminUser } from './admin-user.model';
describe('AdminUser', () => {
  it('should create', () => {
    expect(new AdminUser('1','Admin','a@b.c')).toBeTruthy();
  });
});
