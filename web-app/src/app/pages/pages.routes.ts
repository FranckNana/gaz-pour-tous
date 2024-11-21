import { Routes } from '@angular/router';
import { PagesComponent } from './pages.component';

export const routes: Routes = [
  {
    path: '',
    component: PagesComponent,
    children: [
      {
        path: '',
        loadComponent: () => import('./dashboard/dashboard.component').then(c => c.DashboardComponent),
        data: { breadcrumb: 'Dashboard' }
      },
      {
        path: 'users',
        loadComponent: () => import('./users/users.component').then(c => c.UsersComponent),
        data: { breadcrumb: 'Users' }
      },
      {
        path: 'bouteille',
        loadComponent: () => import('./bouteille-list/bouteille-list.component').then(c => c.BouteilleListComponent),
        data: { breadcrumb: 'Bouteilles' }
      },
      {
        path: 'rapport-sub',
        loadComponent: () => import('./rapport-sub/rapport-sub.component').then(c => c.RapportSubComponent),
        data: { breadcrumb: 'Rapport-sub' }
      },
      { 
        path: 'profile', 
        loadChildren: () => import('./profile/profile.routes').then(p => p.routes),
        data: { breadcrumb: 'Profile' } 
      },
    ]
  }
];