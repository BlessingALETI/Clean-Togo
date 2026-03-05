import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { AuthInterceptor } from './core/http/auth.interceptor';

// Layout
import { AdminLayoutComponent } from './layout/admin-layout/admin-layout.component';
import { SidebarComponent } from './layout/sidebar/sidebar.component';
import { TopbarComponent } from './layout/topbar/topbar.component';

// Pages
import { LoginComponent } from './pages/login/login.component';
import { DashboardComponent } from './pages/dashboard/dashboard.component';
import { ClientsComponent } from './pages/clients/clients.component';
import { DriversComponent } from './pages/drivers/drivers.component';
import { ToursComponent } from './pages/tours/tours.component';
import { PaymentsComponent } from './pages/payments/payments.component';
import { ComplaintsComponent } from './pages/complaints/complaints.component';
import { CommentsComponent } from './pages/comments/comments.component';
import { ProfileComponent } from './pages/profile/profile.component';

// Shared
import { StatsCardComponent } from './shared/stats-card/stats-card.component';
import { TableEmptyComponent } from './shared/table-empty/table-empty.component';

@NgModule({
  declarations: [
    AppComponent,
    AdminLayoutComponent,
    SidebarComponent,
    TopbarComponent,
    LoginComponent,
    DashboardComponent,
    ClientsComponent,
    DriversComponent,
    ToursComponent,
    PaymentsComponent,
    ComplaintsComponent,
    CommentsComponent,
    ProfileComponent,
    StatsCardComponent,
    TableEmptyComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    AppRoutingModule
  ],
  bootstrap: [AppComponent]
})
export class AppModule {}
