# CleanTogo Admin (Angular) — Frontend uniquement

Ce projet correspond au **dashboard web admin** de la plateforme CleanTogo (gestion des déchets).
Il fonctionne **sans backend** grâce à un petit stockage local (MockStoreService).

## Connexion (démo)
- Email: `admin@cleantogo.tg`
- Mot de passe: `admin123`

## Lancer
```bash
npm install
ng serve -o
```

## Structure
- `src/app/pages/*` : pages (dashboard, clients, chauffeurs, planning, finances...)
- `src/app/core/services/*` : services (auth, users, tours, paiements...)
- `src/app/models/*` : modèles (User, Tour, Payment, Complaint...)
- Chaque component a : `.ts + .html + .scss + .spec.ts`
