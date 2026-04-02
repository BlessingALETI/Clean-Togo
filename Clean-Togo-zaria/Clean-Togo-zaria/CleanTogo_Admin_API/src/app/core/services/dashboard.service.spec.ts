import { DashboardService } from './dashboard.service';
import { MockStoreService } from './mock-store.service';

describe('DashboardService', () => {
  it('should compute stats', (done) => {
    const s = new DashboardService(new MockStoreService());
    s.getStats().subscribe(stats => {
      expect(stats.totalClients).toBeGreaterThan(0);
      done();
    });
  });
});
