import { DashboardStats } from './dashboard-stats.model';
describe('DashboardStats', () => {
  it('should create', () => {
    expect(new DashboardStats(100,80,500000,10)).toBeTruthy();
  });
});
