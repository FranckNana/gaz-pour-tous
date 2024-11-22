import { Component } from '@angular/core';
import { SharedModule } from '../../shared/shared.module';
import { FlexLayoutModule } from '@ngbracket/ngx-layout';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { InfoCardsComponent } from './info-cards/info-cards.component';



@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [
    SharedModule,
    FlexLayoutModule,
    MatCardModule,
    MatIconModule,
    InfoCardsComponent,
  ],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.scss'
})
export class DashboardComponent {

}
