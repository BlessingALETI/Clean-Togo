import { UsersService } from './users.service';
import { MockStoreService } from './mock-store.service';

describe('UsersService', () => {
  it('should list clients', (done) => {
    const s = new UsersService(new MockStoreService());
    s.listClients().subscribe(list => {
      expect(list.length).toBeGreaterThan(0);
      done();
    });
  });
});
