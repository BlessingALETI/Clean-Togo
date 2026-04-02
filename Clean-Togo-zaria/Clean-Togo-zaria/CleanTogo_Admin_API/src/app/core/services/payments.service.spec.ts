import { PaymentsService } from './payments.service';
import { MockStoreService } from './mock-store.service';

describe('PaymentsService', () => {
  it('should list payments', (done) => {
    const s = new PaymentsService(new MockStoreService());
    s.list().subscribe(list => {
      expect(list.length).toBeGreaterThan(0);
      done();
    });
  });
});
