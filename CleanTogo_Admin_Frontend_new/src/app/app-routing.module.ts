import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { LoginComponent } from './pages/login/login.component';
import { AdminLayoutComponent } from './layout/admin-layout/admin-layout.component';
import { DashboardComponent } from './pages/dashboard/dashboard.component';
import { ClientsComponent } from './pages/clients/clients.component';
import { DriversComponent } from './pages/drivers/drivers.component';
import { ToursComponent } from './pages/tours/tours.component';
import { PaymentsComponent } from './pages/payments/payments.component';
import { ComplaintsComponent } from './pages/complaints/complaints.component';
import { CommentsComponent } from './pages/comments/comments.component';
import { ProfileComponent } from './pages/profile/profile.component';

import { AuthGuard } from './core/guards/auth.guard';

const routes: Routes = [
  { path: 'login', component: LoginComponent },
  {
    path: '',
    component: AdminLayoutComponent,
    canActivate: [AuthGuard],
    children: [
      { path: '', component: DashboardComponent },
      { path: 'clients', component: ClientsComponent },
      { path: 'drivers', component: DriversComponent },
      { path: 'tours', component: ToursComponent },
      { path: 'payments', component: PaymentsComponent },
      { path: 'complaints', component: ComplaintsComponent },
      { path: 'comments', component: CommentsComponent },
      { path: 'profile', component: ProfileComponent }
    ]
  },
  { path: '**', redirectTo: '' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {}
