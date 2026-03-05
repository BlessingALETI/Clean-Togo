import { environment } from '../../../environments/environment';

const base = environment.apiBaseUrl.replace(/\/$/, '');

export const API = {
  base,
  auth: {
    login: `${base}/auth/login`,
    me: `${base}/auth/me`,
  },
  dashboard: {
    stats: `${base}/dashboard/stats`,
    recentActions: `${base}/dashboard/actions`,
  },
  clients: `${base}/clients`,
  drivers: `${base}/drivers`,
  tours: `${base}/tours`,
  payments: `${base}/payments`,
  complaints: `${base}/complaints`,
  comments: `${base}/comments`,
  profile: `${base}/profile`,
};
