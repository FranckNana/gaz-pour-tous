import { Routes } from '@angular/router';
import { PagesComponent } from './pages.component';
import { AuthGuardService } from '@services/auth-guard.service';

export const routes: Routes = [
  {
    path: '',
    component: PagesComponent,
    children: [
      {
        path: '',
        loadComponent: () => import('./dashboard/dashboard.component').then(c => c.DashboardComponent),
        //canActivate: [AuthGuardService],
        data: { breadcrumb: 'Dashboard' },
      },
      {
        path: 'users',
        loadComponent: () => import('./users/users.component').then(c => c.UsersComponent),
        //canActivate: [AuthGuardService],
        data: { breadcrumb: 'Users' },       
      },
      {
        path: 'bouteille',
        loadComponent: () => import('./bouteille-list/bouteille-list.component').then(c => c.BouteilleListComponent),
        //canActivate: [AuthGuardService],
        data: { breadcrumb: 'Bouteilles' },
      },
      {
        path: 'rapport-sub',
        loadComponent: () => import('./rapport-sub/rapport-sub.component').then(c => c.RapportSubComponent),
        //canActivate: [AuthGuardService],
        data: { breadcrumb: 'Rapport-sub' },
      },
      { 
        path: 'profile', 
        loadChildren: () => import('./profile/profile.routes').then(p => p.routes),
        //canActivate: [AuthGuardService],
        data: { breadcrumb: 'Profile' }
      },
    ]
  }
];