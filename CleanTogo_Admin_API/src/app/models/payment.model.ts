export class Payment {
  constructor(
    public id: string,
    public clientId: string,
    public amountFCFA: number,
    public method: 'TMoney' | 'Flooz' | 'Cash',
    public status: 'Payé' | 'Impayé',
    public createdAtISO: string // ISO datetime
  ) {}
}
