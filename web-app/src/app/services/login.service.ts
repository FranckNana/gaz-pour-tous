import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Login } from '../common/models/login';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class LoginService {

  server_url : String = environment.server_url;

  constructor(private http: HttpClient) { }

  login(login: Login) {
    return this.http.post<any>(this.server_url + environment.BACKEND_ROUTES.LOGIN_API_POST, login); 
  }

  logout(){
    const token = localStorage.getItem('token');
    const headers = new HttpHeaders({
      'Authorization': `Bearer ${token}` // Ajout du token dans l'en-tête Authorization
    });

    localStorage.clear()
    return this.http.get<any>(this.server_url + environment.BACKEND_ROUTES.LOGOUT_API_GET, { headers } ).subscribe({
      next: () => {
        console.log('Déconnexion réussie');
      },
      error: (err) => {
        console.error('Erreur lors de la déconnexion', err);
      }
    }); 
  }

  isUserConnected(){
    return sessionStorage.getItem('username');
  }


}
