import { Comment } from './comment.model';
describe('Comment', () => {
  it('should create', () => {
    expect(new Comment('1','c1',5,'Top','2026-03-01T10:00:00Z')).toBeTruthy();
  });
});
