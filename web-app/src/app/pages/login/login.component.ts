import { Component, EventEmitter, Output } from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { Settings, SettingsService } from '@services/settings.service';
import { MatSidenavModule } from '@angular/material/sidenav';
import { FlexLayoutModule } from '@ngbracket/ngx-layout';
import { MatCardModule } from '@angular/material/card';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSelectModule } from '@angular/material/select';
import { LoginService } from '@services/login.service';
import { CommonModule } from '@angular/common';
import { Login } from '../../common/models/login';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [
    RouterModule,
    ReactiveFormsModule,
    FlexLayoutModule,
    MatSidenavModule,
    MatCardModule,
    MatInputModule,
    MatButtonModule,
    MatIconModule,
    MatSelectModule,
    CommonModule
  ],
  providers: [LoginService],
  templateUrl: './login.component.html'
})
export class LoginComponent {

  public form: FormGroup;
  public settings: Settings;
  isError : boolean = false;

  constructor(public settingsService: SettingsService,public loginService: LoginService, public fb: FormBuilder, public router: Router){
    this.settings = this.settingsService.settings; 
    this.form = this.fb.group({
      'profil': ['', Validators.compose([Validators.required])],
      'username': ['', Validators.compose([Validators.required])],
      'password': ['', Validators.compose([Validators.required, Validators.minLength(6)])] 
    });
  }

  public onSubmit(values:Object):void {
    if (this.form.valid) {
      const formValue = this.form.value;
      const loginObj = new Login(formValue['password'], formValue['profil'], formValue['username']);
      this.loginService.login(loginObj);/*.subscribe(
        () => {
          this.router.navigate(['/gestion']);
        },(error) =>{
          this.isError = true;
          console.log(error)
        }
      );*/
      localStorage.setItem('username', loginObj.username);
      localStorage.setItem('profil', loginObj.profil);
      this.router.navigate(['/gestion']);
    }
  }

  ngAfterViewInit(){
    setTimeout(() => {
      this.settings.loadingSpinner = false; 
    });  
  }

}
