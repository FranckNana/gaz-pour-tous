import { Injectable } from '@angular/core';
import { Marketeur } from '../common/models/marketeur.model';
import { Observable } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class RegisterService {

  constructor(private http: HttpClient) {}

  saveMarketeur(m: Marketeur) : Observable<any> {

    const headers = new HttpHeaders({
      'accept': 'application/json',
      'Content-Type': 'application/json'
    });

    const data = JSON.stringify(m);

    console.log("service-------"+data )
    
    return this.http.post<any>("http://localhost:5000/register", data, {headers});     
  }


}
