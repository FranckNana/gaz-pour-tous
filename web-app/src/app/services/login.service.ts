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

    const headers = new HttpHeaders({
      'Accept': 'text/plain'
    });

    return this.http.post<any>(this.server_url + environment.BACKEND_ROUTES.LOGIN_API_POST, login, { headers, responseType: 'text' as 'json'}); 
  }

  logout(){
    const headers = new HttpHeaders({
      'Accept': 'text/plain'
    });
    return this.http.get<any>(this.server_url + environment.BACKEND_ROUTES.LOGOUT_API_GET,{ headers, responseType: 'text' as 'json'}); 
  }

  isUserConnected(){
    return sessionStorage.getItem('username');
  }


}
