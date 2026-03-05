export class Comment {
  constructor(
    public id: string,
    public clientId: string,
    public rating: number, // 1..5
    public message: string,
    public createdAtISO: string
  ) {}
}
