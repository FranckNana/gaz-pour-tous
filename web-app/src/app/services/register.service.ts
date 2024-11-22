import { Injectable } from '@angular/core';
import { Marketeur } from '../common/models/marketeur.model';
import { Observable } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';

@Injectable()
export class RegisterService {

  constructor(private http: HttpClient) {}

  saveMarketeur(m: Marketeur) {

    this.http.post<any>("http://localhost:5000/register", m).subscribe(
      () => {
        console.log("Enregistrement ok !");
      },(error) =>{
        console.log(error);
      }
    );  
  }


}
