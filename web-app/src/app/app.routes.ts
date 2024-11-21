import { Routes } from '@angular/router';

export const routes: Routes = [
    {
        path: '',
        redirectTo: 'login',
        pathMatch: 'full'
    },
    { 
        path: 'login', 
        loadComponent: () => import('./pages/login/login.component').then(c => c.LoginComponent),
    },
    { 
        path: 'register', 
        loadComponent: () => import('./pages/register/register.component').then(c => c.RegisterComponent),
    },
    {
        path: 'gestion', 
        loadChildren: () => import('./pages/pages.routes').then(p => p.routes)
    },
    { 
        path: 'error', 
        loadComponent: () => import('./pages/errors/error/error.component').then(c => c.ErrorComponent),
        data: { breadcrumb: 'Error' }  
    },
    { 
        path: '**', 
        loadComponent: () => import('./pages/errors/not-found/not-found.component').then(c => c.NotFoundComponent)  
    }
];
