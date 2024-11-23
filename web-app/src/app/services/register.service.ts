import { Injectable } from '@angular/core';
import { Marketeur } from '../common/models/marketeur.model';
import { Observable } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from '../../environments/environment';

@Injectable()
export class RegisterService {

  server_url : String = environment.server_url;

  constructor(private http: HttpClient) {}

  saveMarketeur(m: Marketeur) {

    this.http.post<any>(this.server_url + environment.BACKEND_ROUTES.REGISTER_API_POST, m).subscribe(
      () => {
        console.log("Enregistrement ok !");
      },(error) =>{
        console.log(error);
      }
    );  
  }


}
