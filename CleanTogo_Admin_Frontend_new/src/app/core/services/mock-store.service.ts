import { Injectable } from '@angular/core';
import { User } from '../../models/user.model';
import { Tour } from '../../models/tour.model';
import { Payment } from '../../models/payment.model';
import { Complaint } from '../../models/complaint.model';
import { Comment } from '../../models/comment.model';

/**
 * Stockage local (front only) : permet de faire une démo sans backend.
 * Si un backend existe, vous remplacerez les méthodes des services par des appels HTTP.
 */
@Injectable({ providedIn: 'root' })
export class MockStoreService {
  private key = 'ct_mock_db_v1';

  private seed() {
    const today = new Date();
    const iso = (d: Date) => d.toISOString();
    const dayISO = (d: Date) => d.toISOString().slice(0,10);

    const clients: User[] = [
      { id: 'c1', nom: 'Koffi', prenom: 'Mensah', email: 'koffi.mensah@email.com', phone: '+228 90 12 34 56', username: 'koffi_m', statut: true, role: 'CLIENT', quartier: 'Bè-Kpota', abonnement: 'Standard', status: 'Actif' },
      { id: 'c2', nom: 'Amah', prenom: 'Ayi', email: 'amah.ayi@email.com', phone: '+228 91 23 45 67', username: 'amah_a', statut: false, role: 'CLIENT', quartier: 'Adidogomé', abonnement: 'Basique', status: 'En attente' },
      { id: 'c3', nom: 'Sarah', prenom: 'K.', email: 'sarah.k@email.com', phone: '+228 99 88 77 66', username: 'sarah_k', statut: true, role: 'CLIENT', quartier: 'Agoè', abonnement: 'Premium', status: 'Actif' }
    ];
    const drivers: User[] = [
      { id: 'd1', nom: 'Michel', prenom: 'C.', email: 'michel.c@email.com', phone: '+228 92 11 22 33', username: 'michel_c', statut: true, role: 'CHAUFFEUR', quartier: 'Tokoin', abonnement: 'Standard', status: 'Actif' },
      { id: 'd2', nom: 'Jean', prenom: 'Doe', email: 'jean.doe@email.com', phone: '+228 93 33 44 55', username: 'jean_d', statut: true, role: 'CHAUFFEUR', quartier: 'Bè', abonnement: 'Standard', status: 'Actif' }
    ];

    const tours: Tour[] = [
      { id: 't1', date: dayISO(today), address: 'Bè-Kpota', driverId: 'd1', weight: 45, status: 'En cours' } as unknown as Tour,
      { id: 't2', date: dayISO(new Date(today.getTime()+86400000)), address: 'Adidogomé', driverId: null, weight: 38, status: 'Planifiée' } as unknown as Tour
    ];

    const payments: Payment[] = [
      { id: 'p1', clientId: 'c1', amount: 5000, method: 'TMoney', status: 'Payé', date: iso(new Date(today.getTime()-3*86400000)) } as unknown as Payment,
      { id: 'p2', clientId: 'c2', amount: 5000, method: 'Flooz', status: 'Impayé', date: iso(new Date(today.getTime()-5*86400000)) } as unknown as Payment,
      { id: 'p3', clientId: 'c3', amount: 10000, method: 'TMoney', status: 'Payé', date: iso(new Date(today.getTime()-10*86400000)) } as unknown as Payment
    ];

    const complaints: Complaint[] = [
      { id: 'r1', clientId: 'c2', subject: 'Retard de ramassage', description: 'Le camion n\'est pas passé ce matin.', status: 'Ouverte', date: iso(new Date(today.getTime()-2*86400000)) } as unknown as Complaint,
      { id: 'r2', clientId: 'c1', subject: 'Bac cassé', description: 'Merci de remplacer le bac.', status: 'En cours', date: iso(new Date(today.getTime()-7*86400000)) } as unknown as Complaint
    ];

    const comments: Comment[] = [
      { id: 'm1', clientId: 'c1', rating: 4, text: 'Service correct, à améliorer les horaires.', date: iso(new Date(today.getTime()-9*86400000)) } as unknown as Comment,
      { id: 'm2', clientId: 'c3', rating: 5, text: 'Très bon service 👍', date: iso(new Date(today.getTime()-1*86400000)) } as unknown as Comment
    ];

    return { clients, drivers, tours, payments, complaints, comments };
  }

  private load(): any {
    const raw = localStorage.getItem(this.key);
    if (!raw) {
      const seeded = this.seed();
      localStorage.setItem(this.key, JSON.stringify(seeded));
      return seeded;
    }
    try { return JSON.parse(raw); } catch {
      const seeded = this.seed();
      localStorage.setItem(this.key, JSON.stringify(seeded));
      return seeded;
    }
  }

  private save(db: any) {
    localStorage.setItem(this.key, JSON.stringify(db));
  }

  getClients(): User[] { return this.load().clients as User[]; }
  getDrivers(): User[] { return this.load().drivers as User[]; }
  getTours(): Tour[] { return this.load().tours as Tour[]; }
  getPayments(): Payment[] { return this.load().payments as Payment[]; }
  getComplaints(): Complaint[] { return this.load().complaints as Complaint[]; }
  getComments(): Comment[] { return this.load().comments as Comment[]; }

  upsertClient(u: User) {
    const db = this.load();
    const i = (db.clients as User[]).findIndex((x: User) => x.id === u.id);
    if (i >= 0) db.clients[i] = u; else db.clients.push(u);
    this.save(db);
  }

  upsertDriver(u: User) {
    const db = this.load();
    const i = (db.drivers as User[]).findIndex((x: User) => x.id === u.id);
    if (i >= 0) db.drivers[i] = u; else db.drivers.push(u);
    this.save(db);
  }

  upsertTour(t: Tour) {
    const db = this.load();
    const i = (db.tours as Tour[]).findIndex((x: Tour) => x.id === t.id);
    if (i >= 0) db.tours[i] = t; else db.tours.push(t);
    this.save(db);
  }

  upsertPayment(p: Payment) {
    const db = this.load();
    const i = (db.payments as Payment[]).findIndex((x: Payment) => x.id === p.id);
    if (i >= 0) db.payments[i] = p; else db.payments.push(p);
    this.save(db);
  }

  updateComplaintStatus(id: string, status: Complaint['status']) {
    const db = this.load();
    const c = (db.complaints as Complaint[]).find((x: Complaint) => x.id === id);
    if (c) c.status = status;
    this.save(db);
  }

  deleteClient(id: string) {
  const db = this.load();
  db.clients = (db.clients as any[]).filter((x: any) => x.id !== id);
  this.save(db);
}

deleteDriver(id: string) {
  const db = this.load();
  db.drivers = (db.drivers as any[]).filter((x: any) => x.id !== id);
  this.save(db);
}

deleteTour(id: string) {
  const db = this.load();
  db.tours = (db.tours as any[]).filter((x: any) => x.id !== id);
  this.save(db);
}

getAdminAccount() {
  const db = this.load();

  // init si absent
  if (!db.adminAccount) {
    db.adminAccount = {
      fullName: 'Administrateur',
      email: 'admin@cleantogo.tg',
      role: 'ADMIN',
      password: 'admin123'
    };
    this.save(db);
  }

  return db.adminAccount;
}

updateAdminAccount(payload: { fullName: string; email: string; role: string }) {
  const db = this.load();
  db.adminAccount = { ...this.getAdminAccount(), ...payload };
  this.save(db);
}

changeAdminPassword(oldPass: string, newPass: string): { ok: boolean; message: string } {
  const db = this.load();
  const acc = this.getAdminAccount();

  if (acc.password !== oldPass) {
    return { ok: false, message: "Ancien mot de passe incorrect." };
  }

  db.adminAccount = { ...acc, password: newPass };
  this.save(db);
  return { ok: true, message: "Mot de passe modifié avec succès." };
}
}
