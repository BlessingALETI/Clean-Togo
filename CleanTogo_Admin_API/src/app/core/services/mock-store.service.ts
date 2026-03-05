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
      new User('c1','CLIENT','Koffi Mensah','+228 90 12 34 56','Bè-Kpota','Standard','Actif'),
      new User('c2','CLIENT','Amah Ayi','+228 91 23 45 67','Adidogomé','Basique','En attente'),
      new User('c3','CLIENT','Sarah K.','+228 99 88 77 66','Agoè','Premium','Actif')
    ];
    const drivers: User[] = [
      new User('d1','DRIVER','Michel C.','+228 92 11 22 33','Tokoin','Standard','Actif'),
      new User('d2','DRIVER','Jean Doe','+228 93 33 44 55','Bè','Standard','Actif')
    ];

    const tours: Tour[] = [
      new Tour('t1', dayISO(today), 'Bè-Kpota', 'd1', 45, 'En cours'),
      new Tour('t2', dayISO(new Date(today.getTime()+86400000)), 'Adidogomé', null, 38, 'Planifiée')
    ];

    const payments: Payment[] = [
      new Payment('p1','c1',5000,'TMoney','Payé', iso(new Date(today.getTime()-3*86400000))),
      new Payment('p2','c2',5000,'Flooz','Impayé', iso(new Date(today.getTime()-5*86400000))),
      new Payment('p3','c3',10000,'TMoney','Payé', iso(new Date(today.getTime()-10*86400000)))
    ];

    const complaints: Complaint[] = [
      new Complaint('r1','c2','Retard de ramassage','Le camion n\'est pas passé ce matin.','Ouverte', iso(new Date(today.getTime()-2*86400000))),
      new Complaint('r2','c1','Bac cassé','Merci de remplacer le bac.','En cours', iso(new Date(today.getTime()-7*86400000)))
    ];

    const comments: Comment[] = [
      new Comment('m1','c1',4,'Service correct, à améliorer les horaires.', iso(new Date(today.getTime()-9*86400000))),
      new Comment('m2','c3',5,'Très bon service 👍', iso(new Date(today.getTime()-1*86400000)))
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
}
