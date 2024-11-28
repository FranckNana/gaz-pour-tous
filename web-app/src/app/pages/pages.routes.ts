import { Routes } from '@angular/router';
import { PagesComponent } from './pages.component';
import { environment } from '../../environments/environment';

export const routes: Routes = [
  {
    path: '',
    component: PagesComponent,
    children: [
      {
        path: '',
        redirectTo: environment.FRONTEND_ROUTES.DASHBOARD,
        pathMatch: 'full'
      },
      {
        path: environment.FRONTEND_ROUTES.DASHBOARD,
        loadComponent: () => import('./dashboard/dashboard.component').then(c => c.DashboardComponent),
        data: { breadcrumb: 'Tableau de bord' },
      },
      {
        path: environment.FRONTEND_ROUTES.BOUTEILES,
        loadComponent: () => import('./bouteille-list/bouteille-list.component').then(c => c.BouteilleListComponent),
        data: { breadcrumb: 'Bouteilles' },
      },

      {
        path: environment.FRONTEND_ROUTES.USERS,
        loadComponent: () => import('./users/users.component').then(c => c.UsersComponent),
        data: { breadcrumb: 'Utilisateurs' },       
      },

      {
        path:  environment.FRONTEND_ROUTES.RAPPORTS,
        loadComponent: () => import('./rapport-sub/rapport-sub.component').then(c => c.RapportSubComponent),
        data: { breadcrumb: 'Rapport-sub' },
      },
      { 
        path: environment.FRONTEND_ROUTES.PROFILE,
        loadChildren: () => import('./profile/profile.routes').then(p => p.routes),
        data: { breadcrumb: 'Profile' }
      },
    ]
  }
]; 