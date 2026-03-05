export class Tour {
  constructor(
    public id: string,
    public dateISO: string,     // YYYY-MM-DD
    public zone: string,
    public driverId: string | null,
    public foyersCount: number,
    public status: 'Planifiée' | 'En cours' | 'Terminée'
  ) {}
}
