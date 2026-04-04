import { Tour } from './tour.model';
describe('Tour', () => {
  it('should create', () => {
    expect(new Tour('1','2026-03-01','Bè-Kpota',null,12,'Planifiée')).toBeTruthy();
  });
});
