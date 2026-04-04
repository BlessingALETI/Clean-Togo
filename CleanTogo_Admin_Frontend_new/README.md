# CleanTogo Admin — API (Spring Boot)
Ce projet correspond au **dashboard web admin** de la plateforme CleanTogo (gestion des déchets).

## Lancer avec Proxy (recommandé)
1) Démarrer ton Spring Boot sur `http://localhost:8080`
2) Lancer Angular:
```bash
npm install
ng serve --proxy-config proxy.conf.json -o
```

## Configuration API
- `src/environments/environment.ts` : `apiBaseUrl` (dev)
- `src/environments/environment.prod.ts` : prod

## Endpoints
Voir `src/app/core/api/endpoints.ts`.

### Auth
- POST `/api/auth/login` => `{ token }`
- GET  `/api/auth/me`

### Dashboard
- GET `/api/dashboard/stats`
- GET `/api/dashboard/actions`

### CRUD
- Clients:    `/api/clients` (+ `/api/clients/{id}`) + zones: `/api/clients/zones`
- Drivers:    `/api/drivers` (+ `/api/drivers/{id}`)
- Tours:      `/api/tours` (+ `/api/tours/{id}`)
- Payments:   `/api/payments` (+ `/api/payments/{id}`)
- Complaints: `/api/complaints` (+ `/api/complaints/{id}`)
- Comments:   `/api/comments` (+ `/api/comments/{id}`)

## Auth Bearer
Un interceptor ajoute automatiquement:
`Authorization: Bearer <token>`

Fichiers:
- `src/app/core/http/auth.interceptor.ts`
- `src/app/core/services/token-storage.service.ts`
