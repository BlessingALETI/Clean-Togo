import { ComplaintsService } from './complaints.service';
import { MockStoreService } from './mock-store.service';

describe('ComplaintsService', () => {
  it('should list complaints', (done) => {
    const s = new ComplaintsService(new MockStoreService());
    s.list().subscribe(list => {
      expect(Array.isArray(list)).toBeTrue();
      done();
    });
  });
});
