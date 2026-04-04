import { Complaint } from './complaint.model';
describe('Complaint', () => {
  it('should create', () => {
    expect(new Complaint('1','c1','Retard','Le camion n\'est pas passé','Ouverte','2026-03-01T10:00:00Z')).toBeTruthy();
  });
});
