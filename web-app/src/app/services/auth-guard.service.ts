import { Injectable } from '@angular/core';
import { LoginService } from './login.service';
import { ActivatedRouteSnapshot, CanActivate, Router, RouterStateSnapshot } from '@angular/router';

@Injectable({
  providedIn: 'root'
})
export class AuthGuardService implements CanActivate{

    constructor(private logService: LoginService,
      private router: Router) {}

    canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): boolean {
      const token = this.logService.isUserConnected();
        if (token != null) {
        return true;
      } else {
        console.log("not connected !")
        this.router.navigateByUrl('/login');
        return false;
      }
    }
}
