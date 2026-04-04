import { Payment } from './payment.model';
describe('Payment', () => {
  it('should create', () => {
    expect(new Payment('1','c1',5000,'TMoney','Payé','2026-03-01T10:00:00Z')).toBeTruthy();
  });
});
