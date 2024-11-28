import { Component, OnDestroy, OnInit,ViewChild } from '@angular/core';
import { MatCardModule } from '@angular/material/card';
import { MatInputModule } from '@angular/material/input';
import { MatPaginator, MatPaginatorModule } from '@angular/material/paginator';
import { MatSelectModule } from '@angular/material/select';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { Bouteille, BouteilleService } from '@services/bouteille-service/bouteille.service';
import { SharedModule } from '../../shared/shared.module';
import { FormControl } from '@angular/forms';
import { StatutEnum } from '../../models/statut.enum';
import { Subscription } from 'rxjs';
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
  public displayedColumns = ['identifiant', 'statut', 'date', 'detenteur', 'roleDetenteur', 'capaciteEnKg'];

  dataSource : any;
  bouteilles :Bouteille[] = [];

  username: string;
  profile: string;
  
  currentPageStart: number = 0;
  currentPageEnd: number = 0;
  totalItems: number = 0;
  selectedStatuses: string[] = [];

  constructor(private bouteillesService: BouteilleService) {}

  ngOnInit(){

    this.bouteillesService.getBouteilles().subscribe(
      (response: any[]) => {
        this.dataSource = new MatTableDataSource<any[]>(response);
        this.totalItems = response.length;
      },(error)=>{
        console.log("erreur lors de la récupération des boutielles !");
      }
    )

    this.username = sessionStorage.getItem('username')!;
    this.profile = sessionStorage.getItem('profil')!;
  }

  //Select with custom trigger text
  toppings2 = new FormControl();
  toppingList2 = [
    StatutEnum.PLEINE_CHEZ_LE_VENDEUR,
    StatutEnum.PLEINE_CHEZ_LE_CLIENT,
    StatutEnum.CHEZ_LE_MARKETEUR,
    StatutEnum.PRETE_A_ETRE_REMPLIE,
    StatutEnum.VIDE_CHEZ_LE_MARKETEUR,
    StatutEnum.VIDE_CHEZ_LE_CLIENT,
    StatutEnum.VIDE_CHEZ_LE_REVENDEUR,
    StatutEnum.VIDE_EN_COURS_DE_LIVRAISON_AU_MARKETEUR,
    StatutEnum.PRETE_A_LIVREE_AU_MARKETEUR,
    StatutEnum.EN_COURS_DE_LIVRAISON_AU_MARKETEUR,
    StatutEnum.EN_COURS_DE_LIVRAISON_AU_VENDEUR
  ];

  //rouge
  public isFilled(element:any){
    return element.statut === StatutEnum.PLEINE_CHEZ_LE_VENDEUR || StatutEnum.PLEINE_CHEZ_LE_CLIENT || StatutEnum.CHEZ_LE_MARKETEUR || StatutEnum.PRETE_A_ETRE_REMPLIE;
  }

  //vert
  public isEmpty(element:any) {
    return element.statut === StatutEnum.VIDE_CHEZ_LE_MARKETEUR || StatutEnum.VIDE_CHEZ_LE_CLIENT || StatutEnum.VIDE_CHEZ_LE_REVENDEUR || StatutEnum.VIDE_EN_COURS_DE_LIVRAISON_AU_MARKETEUR
  }


  public isInProgress(element:any){
    return element.statut === StatutEnum.PRETE_A_LIVREE_AU_MARKETEUR || StatutEnum.EN_COURS_DE_LIVRAISON_AU_MARKETEUR || StatutEnum.EN_COURS_DE_LIVRAISON_AU_VENDEUR;
  }
  


  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;

    // Écoute des changements de page
    this.paginator.page.subscribe(() => this.updatePaginationInfo());
    this.updatePaginationInfo(); // Initialisation des infos

  }

  updatePaginationInfo() {
    const pageIndex = this.paginator.pageIndex;
    const pageSize = this.paginator.pageSize;

    this.currentPageStart = pageIndex * pageSize + 1; // Index de début
    this.currentPageEnd = Math.min((pageIndex + 1) * pageSize, this.totalItems); // Index de fin
  }


    filterStatus(): void {
    if (this.selectedStatuses.length === 0) {
      this.dataSource.filter = '';
    } else {
      this.dataSource.filterPredicate = (data: any, filter: string) => {
        const selected = filter.split(',');
        return selected.includes(data.status);
      };
      this.dataSource.filter = this.selectedStatuses.join(',');
    }
  }
}
