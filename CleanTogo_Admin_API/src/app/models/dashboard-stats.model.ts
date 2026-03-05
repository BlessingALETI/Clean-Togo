export class DashboardStats {
  constructor(
    public totalClients: number,
    public tauxCollecte: number,     // 0..100
    public revenusMensuelsFCFA: number,
    public tauxImpayes: number       // 0..100
  ) {}
}
