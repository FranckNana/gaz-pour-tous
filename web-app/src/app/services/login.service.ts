import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Login } from '../common/models/login';

@Injectable({
  providedIn: 'root'
})
export class LoginService {

  constructor(private http: HttpClient) { }

  login(login: Login) {

    const headers = new HttpHeaders({
      'Accept': 'text/plain'
    });

    return this.http.post<any>("http://localhost:5000/login", login, { headers, responseType: 'text' as 'json'}); 
  }

  logout(){
    const headers = new HttpHeaders({
      'Accept': 'text/plain'
    });
    return this.http.get<any>("http://localhost:5000/logout",{ headers, responseType: 'text' as 'json'}); 
  }

  isUserConnected(){
    return sessionStorage.getItem('username');
  }


}
