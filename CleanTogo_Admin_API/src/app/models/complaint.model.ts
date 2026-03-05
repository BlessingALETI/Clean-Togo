export class Complaint {
  constructor(
    public id: string,
    public clientId: string,
    public title: string,
    public message: string,
    public status: 'Ouverte' | 'En cours' | 'Résolue',
    public createdAtISO: string
  ) {}
}
