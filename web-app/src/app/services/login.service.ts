import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Login } from '../common/models/login';

@Injectable()
export class LoginService {

  constructor(private http: HttpClient) { }

  login(login: Login) {

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    

    const log = {
      "password" : login.password,
      "profil": login.profil,
      "username": login.username
    }

    //console.log("login",login)
    //console.log("log",log)
    console.log(JSON.stringify(login))
    return this.http.post<any>("http://localhost:5000/login", JSON.stringify(login), { headers }); 
  }


}
