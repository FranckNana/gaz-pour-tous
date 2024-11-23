import { Component, OnInit,ViewChild } from '@angular/core';
import { MatCardModule } from '@angular/material/card';
import { MatInputModule } from '@angular/material/input';
import { MatPaginator, MatPaginatorModule } from '@angular/material/paginator';
import { MatSelectModule } from '@angular/material/select';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { Bouteille, BouteilleService } from '@services/bouteille-service/bouteille.service';
import { SharedModule } from '../../shared/shared.module';
import { FormControl } from '@angular/forms';
import { StatutEnum } from '../../models/statut.enum';
@Component({
  selector: 'app-bouteille-list',
  standalone: true,
  imports: [
    SharedModule
  ],
  providers:[BouteilleService],
  templateUrl: './bouteille-list.component.html',
  styleUrl: './bouteille-list.component.scss'
})
export class BouteilleListComponent  implements OnInit {
  @ViewChild(MatPaginator) paginator: MatPaginator;
  public displayedColumns = ['identifiant', 'contenance', 'statut', 'date', 'detenteur', 'roleDetenteur', 'capaciteEnKg'];
  public dataSource: any;
 
  constructor(private tablesService:BouteilleService) {
    this.dataSource = new MatTableDataSource<Bouteille>(this.tablesService.getBouteilles());
  }

  ngOnInit(): void {
    
  }
  //Select with custom trigger text
  toppings2 = new FormControl();
  toppingList2 = ['En cours de livraison', 'Livrée', 'En stock' ,'Remplissage'];

  public isEncours(element:any){
    return element.statut === StatutEnum.EN_COURS_LIVRAISON;
  }


  public isEnStock(element:any){
    return element.statut === StatutEnum.EN_STOCK;
  }

  public isLivre(element:any){
    return element.statut === StatutEnum.LIVREE;
  }
  public isRemplis(element:any){
    return element.statut === StatutEnum.REMPLISSAGE;
  }


  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
  }
}
