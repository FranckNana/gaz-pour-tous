import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { User } from '../common/models/user.model';
import { GeneralService } from './abstract-general.service';
import { environment } from '../../environments/environment';
@Injectable()
export class UsersService extends GeneralService<User> {


    constructor(public override http:HttpClient) { super(http);}

    public getUrl(): string {
        return environment.BACKEND.USER_API;
    }
 
  
  
}
