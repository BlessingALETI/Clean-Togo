import { CommentsService } from './comments.service';
import { MockStoreService } from './mock-store.service';

describe('CommentsService', () => {
  it('should list comments', (done) => {
    const s = new CommentsService(new MockStoreService());
    s.list().subscribe(list => {
      expect(Array.isArray(list)).toBeTrue();
      done();
    });
  });
});
