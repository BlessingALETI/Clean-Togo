import { MockStoreService } from './mock-store.service';

describe('MockStoreService', () => {
  it('should seed and return clients', () => {
    const s = new MockStoreService();
    const clients = s.getClients();
    expect(Array.isArray(clients)).toBeTrue();
    expect(clients.length).toBeGreaterThan(0);
  });
});
