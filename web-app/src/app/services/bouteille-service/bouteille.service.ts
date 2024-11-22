import { Injectable } from "@angular/core";

export interface Bouteille {
    identifiant: string;
    contenance: number;
    statut: string;
    date_maj: string; 
    detenteur: string;
    roleDetenteur: string;
    capaciteEnKg: number;
  }

  const data: Bouteille[] = [
    { identifiant: "B4581", contenance: 201, statut: 'Livrée', date_maj: '19/11/2024', detenteur: 'NANA', roleDetenteur: 'Emplisseur' , capaciteEnKg: 5},
    { identifiant: "B4582", contenance: 51, statut: 'En cours de livraison', date_maj: '19/11/2024', detenteur: 'Wendlassida', roleDetenteur: 'Transporteur', capaciteEnKg: 5 },
    { identifiant: "B4583", contenance: 5201, statut: 'En cours de livraison', date_maj: '19/11/2024', detenteur: 'Franck', roleDetenteur: 'Marketeur', capaciteEnKg: 5 },
    { identifiant: "B4524", contenance: 71, statut: 'En cours de livraison', date_maj: '19/11/2024', detenteur: 'Judicael', roleDetenteur: 'Transport', capaciteEnKg: 5 },
    { identifiant: "B4585", contenance: 1451, statut: 'En cours de livraison', date_maj: '19/11/2024', detenteur: 'Kima', roleDetenteur: 'Revendeur', capaciteEnKg: 5 },
    { identifiant: "B4516", contenance: 5201, statut: 'Livrée', date_maj: '19/11/2024', detenteur: 'Thierry', roleDetenteur: 'Client', capaciteEnKg: 3.5 },
    { identifiant: "B4537", contenance: 621, statut: 'Remplissage', date_maj: '19/11/2024', detenteur: 'Sandy', roleDetenteur: 'Transporteur', capaciteEnKg: 5 },
    { identifiant: "B4588", contenance: 5201, statut: 'En stock', date_maj: '19/11/2024', detenteur: 'Tertius', roleDetenteur: 'Client', capaciteEnKg: 5 },
    { identifiant: "B4589", contenance: 5201, statut: 'En stock', date_maj: '19/11/2024', detenteur: 'Steve', roleDetenteur: 'Marketeur', capaciteEnKg: 5 },
    { identifiant: "B4580", contenance: 301, statut: 'Remplissage', date_maj: '19/11/2024', detenteur: 'Armel', roleDetenteur: 'Client', capaciteEnKg: 3.2 },
  ]


  @Injectable()
  export  class BouteilleService{
    constructor(){}

    getBouteilles(){
      return data;
    }
  }