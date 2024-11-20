import { DatePipe } from "@angular/common";
import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { MatBottomSheet } from "@angular/material/bottom-sheet";
import { MatDialog } from "@angular/material/dialog";
import { MatSnackBar } from "@angular/material/snack-bar";
import { TranslateService } from '@ngx-translate/core';
import { Settings } from "./settings.service";
import { AlertDialogComponent } from "../shared/alert-dialog/alert-dialog.component";
import { ConfirmDialogComponent, ConfirmDialogModel } from "../shared/confirm-dialog/confirm-dialog.component";

@Injectable({providedIn:'root'})
export class AppService{

constructor(public http:HttpClient, 
              private datePipe:DatePipe,
              private bottomSheet: MatBottomSheet, 
              private snackBar: MatSnackBar,
              public dialog: MatDialog,
              public appSettings:Settings,
              public translateService: TranslateService) { }  

  public openCart(component:any){  
    this.bottomSheet.open(component, {
      direction: (this.appSettings.rtl) ? 'rtl':'ltr'
    }).afterDismissed().subscribe(isRedirect=>{  
      if(isRedirect){ 
        window.scrollTo(0,0);  
      }        
    });  
  }

  public openDialog(component:any, data:any, panelClass:any){ 
    return this.dialog.open(component, {
      data: data, 
      panelClass: panelClass,
      autoFocus: false,
      direction: (this.appSettings.rtl) ? 'rtl':'ltr'
    });  
  } 

  public getTranslateValue(key:string, param:string = ''){  
    let value = null;
    this.translateService.get(key, { param: param }).subscribe((res: string) => {
      value = res;
    }) 
    return value; 
  } 
 
  public openConfirmDialog(title:string, message:string, isActive:boolean = true, buttonDroit: string = "Oui") {  
    const dialogData = new ConfirmDialogModel(title, message,isActive, buttonDroit); 
    const dialogRef = this.dialog.open(ConfirmDialogComponent, {
      maxWidth: "400px",
      data: dialogData
    }); 
    return dialogRef; 
  }

  public openAlertDialog(message:string) {   
    const dialogRef = this.dialog.open(AlertDialogComponent, {
      maxWidth: "400px",
      data: message
    }); 
    return dialogRef; 
  }

}