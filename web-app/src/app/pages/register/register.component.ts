import { Component } from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { Settings, SettingsService } from '@services/settings.service';
import { emailValidator, matchingPasswords } from '../../theme/utils/app-validators';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { FlexLayoutModule } from '@ngbracket/ngx-layout';
import { Marketeur } from '../../common/models/marketeur.model';
import { TypeProfile } from '../../common/models/typeProfile.model';
import { RegisterService } from '@services/register.service';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [
    RouterModule,
    ReactiveFormsModule,
    FlexLayoutModule,
    MatSidenavModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule,
    MatInputModule
  ],
  providers: [RegisterService],
  templateUrl: './register.component.html'
})
export class RegisterComponent {

  public form: FormGroup;
  public settings: Settings;

  constructor(public settingsService: SettingsService, public registerService: RegisterService, public fb: FormBuilder, public router: Router){
    this.settings = this.settingsService.settings; 
    this.form = this.fb.group({
      'username': [null, Validators.compose([Validators.required,])],
      'password': ['', Validators.required],
      'confirmPassword': ['', Validators.required]
    },{validator: matchingPasswords('password', 'confirmPassword')});
  }

  public onSubmit(values: Object): void {
    if (this.form.valid) {
      const formValue = this.form.value;
      const newMarketer = new Marketeur(
        formValue['password'],
        Array.of(TypeProfile.marketeur.toString()),
        formValue['username']
      )
      this.registerService.saveMarketeur(newMarketer);   
      this.router.navigate(['/login']); 
    }
  }

  ngAfterViewInit(){
    setTimeout(() => {
      this.settings.loadingSpinner = false; 
    }); 
  }

}
