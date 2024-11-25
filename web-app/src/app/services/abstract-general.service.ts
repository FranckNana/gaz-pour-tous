import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";
import { UserData, UserJson } from "../common/models/userJson";

export abstract class GeneralService <ITEM>{

    public abstract getUrl(): string;
    constructor(public http: HttpClient) {}
  
  
    public add(ressource: any) {
      return this.http.post(this.getUrl(), ressource);
    }
  
    public update(id:any,ressource: any) {
      return this.http.patch(this.getUrl() + "/" + id, ressource);
    }
    public get(id: string | number) {
      return this.http.get<ITEM>(this.getUrl() + "/" + id);  
    }
  
    public delete(id: string | number) {
      return this.http.delete(this.getUrl() + "/" + id);
    }
    public findById(id:string | number){
      return this.http.get<ITEM>(this.getUrl()+""+ id);
  }
  /*public getAll(): Observable<ITEM[]>{
    return this.http.get<ITEM[]>(this.getUrl());
  }*/
  public getAll() : UserJson[] {
    return UserData.data;
  }
}