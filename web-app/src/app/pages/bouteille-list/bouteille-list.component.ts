import { Component, OnInit,ViewChild } from '@angular/core';
import { MatPaginator, MatPaginatorModule } from '@angular/material/paginator';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { Bouteille, BouteilleService } from '@services/bouteille-service/bouteille.service';
@Component({
  selector: 'app-bouteille-list',
  standalone: true,
  imports: [
    MatTableModule,
    MatPaginatorModule
  ],
  providers:[BouteilleService],
  templateUrl: './bouteille-list.component.html',
  styleUrl: './bouteille-list.component.scss'
})
export class BouteilleListComponent  implements OnInit {
  @ViewChild(MatPaginator) paginator: MatPaginator;
  public displayedColumns = ['identifiant', 'contenance', 'statut', 'date', 'detenteur', 'roleDetenteur'];
  public dataSource: any;
 
  constructor(private tablesService:BouteilleService) {
    this.dataSource = new MatTableDataSource<Bouteille>(this.tablesService.getBouteilles());
  }

  ngOnInit(): void {
    
  }

  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
  }
}
