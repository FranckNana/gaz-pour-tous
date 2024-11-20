import { Injectable } from "@angular/core";

export interface Bouteille {
    identifiant: string;
    contenance: number;
    statut: string;
    date_maj: string;
  }

  const data: Bouteille[] = [
    { identifiant: "B4588", contenance: 201, statut: 'En cours de livraison', date_maj: '19/11/2024' },
    { identifiant: "B4587", contenance: 51, statut: 'En cours de livraison', date_maj: '19/11/2024' },
    { identifiant: "B4584", contenance: 5201, statut: 'En cours de livraison', date_maj: '19/11/2024' },
    { identifiant: "B4528", contenance: 71, statut: 'En cours de livraison', date_maj: '19/11/2024' },
    { identifiant: "B4580", contenance: 1451, statut: 'En cours de livraison', date_maj: '19/11/2024' },
    { identifiant: "B4518", contenance: 5201, statut: 'Livré', date_maj: '19/11/2024' },
    { identifiant: "B4538", contenance: 621, statut: 'remplissage', date_maj: '19/11/2024' },
    { identifiant: "B4589", contenance: 5201, statut: 'En cours de livraison', date_maj: '19/11/2024' },
    { identifiant: "B4580", contenance: 5201, statut: 'En cours de livraison', date_maj: '19/11/2024' },
    { identifiant: "B4589", contenance: 301, statut: 'En cours de livraison', date_maj: '19/11/2024' },
  ]
  @Injectable()
  export  class BouteilleService{
 constructor(){}

  getBouteilles(){
    return data;
  }
  }