import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { API } from '../api/endpoints';
import { DashboardStats } from '../../models/dashboard-stats.model';

export type RecentAction = {
  title: string;
  desc: string;
  time: string;
  type: string;
};

@Injectable({ providedIn: 'root' })
export class DashboardService {
  constructor(private http: HttpClient) {}

  getStats(): Observable<DashboardStats> {
    return this.http.get<DashboardStats>(API.dashboard.stats);
  }

  getRecentActions(): Observable<RecentAction[]> {
    return this.http.get<RecentAction[]>(API.dashboard.recentActions);
  }
}
