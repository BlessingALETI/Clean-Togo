import { Component, OnInit } from '@angular/core';
import { DashboardService } from '../../core/services/dashboard.service';
import { DashboardStats } from '../../models/dashboard-stats.model';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
  loading = true;
  stats: DashboardStats | null = null;

  constructor(private dash: DashboardService) {}

  ngOnInit(): void {
    this.dash.getStats().subscribe(s => {
      this.stats = s;
      this.loading = false;
    });
  }
}
