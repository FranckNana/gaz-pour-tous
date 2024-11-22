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

    const httpOptions = {
      headers: new HttpHeaders({
        'Accept': 'text/html, application/xhtml+xml, */*',
        'Content-Type': 'application/x-www-form-urlencoded'
      }),
      responseType: 'text'
    };
    const data = JSON.stringify(m);

    console.log("service-------"+data )
    this.http.get("https://filesamples.com/samples/code/json/sample1.json").subscribe()
    return this.http.post<any>("http://localhost:5000/register", data, {headers} );     
  }


}
