import { Injectable } from "@angular/core";

export interface Bouteille {
    identifiant: string;
    contenance: number;
    statut: string;
    date_maj: string; 
    detenteur: string;
    roleDetenteur: string
  }

  const data: Bouteille[] = [
    { identifiant: "B4581", contenance: 201, statut: 'En cours de livraison', date_maj: '19/11/2024', detenteur: 'NANA', roleDetenteur: 'Emplisseur'},
    { identifiant: "B4582", contenance: 51, statut: 'En cours de livraison', date_maj: '19/11/2024', detenteur: 'Wendlassida', roleDetenteur: 'Transporteur' },
    { identifiant: "B4583", contenance: 5201, statut: 'En cours de livraison', date_maj: '19/11/2024', detenteur: 'Franck', roleDetenteur: 'Marketeur' },
    { identifiant: "B4524", contenance: 71, statut: 'En cours de livraison', date_maj: '19/11/2024', detenteur: 'Judicael', roleDetenteur: 'Transport' },
    { identifiant: "B4585", contenance: 1451, statut: 'En cours de livraison', date_maj: '19/11/2024', detenteur: 'Kima', roleDetenteur: 'Revendeur' },
    { identifiant: "B4516", contenance: 5201, statut: 'Livré', date_maj: '19/11/2024', detenteur: 'Thierry', roleDetenteur: 'Client' },
    { identifiant: "B4537", contenance: 621, statut: 'remplissage', date_maj: '19/11/2024', detenteur: 'Sandy', roleDetenteur: 'Transporteur' },
    { identifiant: "B4588", contenance: 5201, statut: 'En cours de livraison', date_maj: '19/11/2024', detenteur: 'Tertius', roleDetenteur: 'Client' },
    { identifiant: "B4589", contenance: 5201, statut: 'En cours de livraison', date_maj: '19/11/2024', detenteur: 'Steve', roleDetenteur: 'Marketeur' },
    { identifiant: "B4580", contenance: 301, statut: 'En cours de livraison', date_maj: '19/11/2024', detenteur: 'Armel', roleDetenteur: 'Client' },
  ]


  @Injectable()
  export  class BouteilleService{
    constructor(){}

    getBouteilles(){
      return data;
    }
  }