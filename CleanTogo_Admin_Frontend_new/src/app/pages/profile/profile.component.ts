import { Component, OnInit } from '@angular/core';
import { AuthService } from '../../core/services/auth.service';

type Role = 'ADMIN' | 'CLIENT' | 'CHAUFFEUR' ;

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.scss']
})
export class ProfileComponent implements OnInit {
  admin = { fullName: '', email: '', role: 'ADMIN' as Role };

  // modals
  editOpen = false;
  rolesOpen = false;
  passOpen = false;

  // forms
  editForm = { fullName: '', email: '' };
  roleForm = { role: 'ADMIN' as Role };
  passForm = { oldPass: '', newPass: '', confirm: '' };

  toast: { type: 'success' | 'danger'; msg: string } | null = null;

  constructor(public auth: AuthService) {}

  ngOnInit(): void {
    this.reload();
  }

  reload() {
    const a = this.auth.getCurrentAdmin();
    this.admin = { fullName: a.fullName, email: a.email, role: a.role };
  }

  // ---- Edit profile ----
  openEdit() {
    this.editForm = { fullName: this.admin.fullName, email: this.admin.email };
    this.editOpen = true;
  }
  saveEdit() {
    if (!this.editForm.fullName.trim() || !this.editForm.email.trim()) return;

    this.auth.updateCurrentAdmin(this.editForm.fullName.trim(), this.editForm.email.trim(), this.admin.role);
    this.editOpen = false;
    this.reload();
    this.showToast('success', 'Profil mis à jour.');
  }

  // ---- Roles ----
  openRoles() {
    this.roleForm = { role: this.admin.role };
    this.rolesOpen = true;
  }
  saveRole() {
    this.auth.updateCurrentAdmin(this.admin.fullName, this.admin.email, this.roleForm.role);
    this.rolesOpen = false;
    this.reload();
    this.showToast('success', 'Rôle mis à jour.');
  }

  // ---- Password ----
  openPassword() {
    this.passForm = { oldPass: '', newPass: '', confirm: '' };
    this.passOpen = true;
  }
  savePassword() {
    if (!this.passForm.oldPass || !this.passForm.newPass) return;
    if (this.passForm.newPass.length < 6) {
      return this.showToast('danger', 'Le nouveau mot de passe doit contenir au moins 6 caractères.');
    }
    if (this.passForm.newPass !== this.passForm.confirm) {
      return this.showToast('danger', 'Confirmation incorrecte.');
    }

    const r = this.auth.changePassword(this.passForm.oldPass, this.passForm.newPass);
    if (!r.ok) return this.showToast('danger', r.message);

    this.passOpen = false;
    this.showToast('success', r.message);
  }

  closeAll() {
    this.editOpen = false;
    this.rolesOpen = false;
    this.passOpen = false;
  }

  roleLabel(r: Role) {
    if (r === 'ADMIN') return 'Administrateur';
    if (r === 'CLIENT') return 'Client';
    if (r === 'CHAUFFEUR') return 'Chauffeur';
    return 'Cuisinier';
  }

  private showToast(type: 'success' | 'danger', msg: string) {
    this.toast = { type, msg };
    setTimeout(() => (this.toast = null), 2500);
  }
}