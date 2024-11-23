import { Routes } from '@angular/router';
import { AuthGuardService } from '@services/auth-guard.service';
import { environment } from '../environments/environment';

export const routes: Routes = [
    {
        path: '',
        redirectTo: 'login',
        pathMatch: 'full'
    },
    { 
        path: environment.FRONTEND_ROUTES.LOGIN, 
        loadComponent: () => import('./pages/login/login.component').then(c => c.LoginComponent),
    },
    { 
        path: environment.FRONTEND_ROUTES.REGISTER, 
        loadComponent: () => import('./pages/register/register.component').then(c => c.RegisterComponent)
    },
    {
        path: environment.FRONTEND_ROUTES.GESTION, 
        loadChildren: () => import('./pages/pages.routes').then(p => p.routes),
        canActivate: [AuthGuardService],
    },
    { 
        path: environment.FRONTEND_ROUTES.ERROR, 
        loadComponent: () => import('./pages/errors/error/error.component').then(c => c.ErrorComponent)
    },
    { 
        path: '**', 
        loadComponent: () => import('./pages/errors/not-found/not-found.component').then(c => c.NotFoundComponent) 
    } 
];
