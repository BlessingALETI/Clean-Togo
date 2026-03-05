import { User } from './user.model';
describe('User', () => {
  it('should create', () => {
    expect(new User('1','CLIENT','Test','+228 90 00 00 00','Agoè','Standard','Actif')).toBeTruthy();
  });
});
