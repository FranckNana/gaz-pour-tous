import { Component, OnInit, ViewEncapsulation } from '@angular/core';
import { FlexLayoutModule } from '@ngbracket/ngx-layout';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatMenuModule } from '@angular/material/menu';
import { MatToolbarModule } from '@angular/material/toolbar';
import { Router, RouterModule } from '@angular/router';
import { Login } from '../../../common/models/login';
import { LoginService } from '@services/login.service';

@Component({
  selector: 'app-user-menu',
  standalone: true,
  imports: [
    RouterModule,
    FlexLayoutModule,
    MatButtonModule,
    MatIconModule,
    MatMenuModule,
    MatToolbarModule
  ],
  providers: [LoginService],
  templateUrl: './user-menu.component.html',
  styleUrls: ['./user-menu.component.scss'],
  encapsulation: ViewEncapsulation.None,
})
export class UserMenuComponent implements OnInit {
  public userImage = 'img/users/user.jpg';
  username : string;
  profil: string;

  constructor(public loginService : LoginService, public router: Router) { }

  ngOnInit() {
    this.username = localStorage.getItem('username')!;
    this.profil = localStorage.getItem('profil')!;
  }

  onLogOut(){
    this.loginService.logout();
    localStorage.removeItem('username')
    localStorage.removeItem('profil')
    this.router.navigate(['/login']);
  }

}
