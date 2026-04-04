import { ToursService } from './tours.service';
import { MockStoreService } from './mock-store.service';

describe('ToursService', () => {
  it('should list tours', (done) => {
    const s = new ToursService(new MockStoreService());
    s.list().subscribe(list => {
      expect(Array.isArray(list)).toBeTrue();
      done();
    });
  });
});
