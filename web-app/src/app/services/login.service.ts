import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Login } from '../common/models/login';
import { environment } from '../../environments/environment';
import { tap } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class LoginService {

  server_url: String = environment.server_url;

  constructor(private http: HttpClient) { }

  login(login: Login) {

    const headers = new HttpHeaders({
      'Accept': 'text/plain'
    });

    headers.append('Content-Type', 'application/json');
    //let options = new RequestOptions({ headers: headers, withCredentials: true });

    return this.http.post<any>(this.server_url + environment.BACKEND_ROUTES.LOGIN_API_POST, login, { headers, observe: 'response', /*responseType: 'text' as 'json'*/ })
          .pipe(tap(resp => {
            console.log(resp.headers.get('Set-cookie'))
            console.log(resp.headers.get('set-cookie'))
            console.log(resp)
            console.log(document.cookie)
            console.log(this.getCookie('session'))
          }))
    ;
  }

  logout() {
    const headers = new HttpHeaders({
      'Accept': 'text/plain'
    });
    return this.http.get<any>(this.server_url + environment.BACKEND_ROUTES.LOGOUT_API_GET, { headers, responseType: 'text' as 'json' });
  }

  isUserConnected() {
    return sessionStorage.getItem('username');
  }

  getCookie(name: string) {
    let ca: Array<string> = document.cookie.split(';');
    console.log()
    let caLen: number = ca.length;
    let cookieName = `${name}=`;
    let c: string;

    for (let i: number = 0; i < caLen; i += 1) {
      c = ca[i].replace(/^\s+/g, '');
      if (c.indexOf(cookieName) == 0) {
        return c.substring(cookieName.length, c.length);
      }
    }
    return '';
  }


  private deleteCookie(name: string) {
    this.setCookie(name, '', -1);
  }

  private setCookie(name: string, value: string, expireMinutes: number, path: string = '/') {
    let d: Date = new Date();
    d.setTime(d.getTime() + expireMinutes * 60 * 1000);
    let expires: string = `expires=${d.toUTCString()}`;
    let cpath: string = path ? `; path=${path}` : '';
    document.cookie = `${name}=${value}; ${expires}${cpath}`;
  }


}
