export type UserRole = 'CLIENT' | 'DRIVER';

export class User {
  constructor(
    public id: string,
    public role: UserRole,
    public fullName: string,
    public phone: string,
    public quartier: string,
    public abonnement: 'Standard' | 'Premium' | 'Basique',
    public status: 'Actif' | 'En attente' | 'Suspendu'
  ) {}
}
