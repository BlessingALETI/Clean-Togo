import { Component, OnInit } from '@angular/core';
import { CommentsService } from '../../core/services/comments.service';
import { UsersService } from '../../core/services/users.service';
import { Comment } from '../../models/comment.model';
import { User } from '../../models/user.model';

@Component({
  selector: 'app-comments',
  templateUrl: './comments.component.html',
  styleUrls: ['./comments.component.scss']
})
export class CommentsComponent implements OnInit {
  loading = true;
  list: Comment[] = [];
  clients: User[] = [];

  constructor(private svc: CommentsService, private users: UsersService) {}

  ngOnInit(): void {
    this.users.listClients().subscribe(c => this.clients = c);
    this.svc.list().subscribe(l => { this.list = l; this.loading = false; });
  }

  clientName(id: string): string {
    return this.clients.find(x => x.id === id)?.fullName ?? id;
  }

  stars(n: number): string {
    return '★'.repeat(n) + '☆'.repeat(5-n);
  }
}
