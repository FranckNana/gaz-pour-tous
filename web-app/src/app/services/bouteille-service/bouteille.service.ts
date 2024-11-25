import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { environment } from "../../../environments/environment";
import { Observable, Subject } from "rxjs";

export interface Bouteille {
    bottleId: string;
    state: string;
    last_update: any; 
    currentOwnerId: string;
    capacity: number;
}

  /*const data: Bouteille[] = [
    { identifiant: "B4581", statut: 'Livrée', date_maj: '19/11/2024', detenteur: 'NANA', roleDetenteur: 'Emplisseur' , capaciteEnKg: 5},
    { identifiant: "B4582", statut: 'En cours de livraison', date_maj: '19/11/2024', detenteur: 'Wendlassida', roleDetenteur: 'Transporteur', capaciteEnKg: 5 },
    { identifiant: "B4583", statut: 'En cours de livraison', date_maj: '19/11/2024', detenteur: 'Franck', roleDetenteur: 'Marketeur', capaciteEnKg: 5 },
    { identifiant: "B4524", statut: 'En cours de livraison', date_maj: '19/11/2024', detenteur: 'Judicael', roleDetenteur: 'Transport', capaciteEnKg: 5 },
    { identifiant: "B4585", statut: 'En cours de livraison', date_maj: '19/11/2024', detenteur: 'Kima', roleDetenteur: 'Revendeur', capaciteEnKg: 5 },
    { identifiant: "B4516", statut: 'Livrée', date_maj: '19/11/2024', detenteur: 'Thierry', roleDetenteur: 'Client', capaciteEnKg: 3.5 },
    { identifiant: "B4537", statut: 'Remplissage', date_maj: '19/11/2024', detenteur: 'Sandy', roleDetenteur: 'Transporteur', capaciteEnKg: 5 },
    { identifiant: "B4588", statut: 'En stock', date_maj: '19/11/2024', detenteur: 'Tertius', roleDetenteur: 'Client', capaciteEnKg: 5 },
    { identifiant: "B4589", statut: 'En stock', date_maj: '19/11/2024', detenteur: 'Steve', roleDetenteur: 'Marketeur', capaciteEnKg: 5 },
    { identifiant: "B4580", statut: 'Remplissage', date_maj: '19/11/2024', detenteur: 'Armel', roleDetenteur: 'Client', capaciteEnKg: 3.2 },
  ]
*/

  @Injectable({
    providedIn: 'root'
  })
  export  class BouteilleService{

    server_url : String = environment.server_url;

    bouteilles: Bouteille[] = [];
    bouteillesSubject = new Subject<Bouteille[]>();

    constructor(private http: HttpClient){
    }


    emitBouteilles(){
      this.bouteillesSubject.next(this.bouteilles.slice());
    }


    getBouteilles() {
      const token = localStorage.getItem('token');
      const headers = new HttpHeaders({
        'Authorization': `Bearer ${token}`
      });

      return this.http.get<Bouteille>(this.server_url + environment.BACKEND_ROUTES.CURRENT_BOTTLES_POST, { headers } );/*.subscribe(
        (response: any) => {
          this.bouteilles = response;
          //this.emitBouteilles();
        },(error)=>{
          console.log("erreur lors de la récupération des boutielles !");
        }
      ); */

    }

    get(){
      this.getBouteilles();
      return this.bouteilles;
    }

  }