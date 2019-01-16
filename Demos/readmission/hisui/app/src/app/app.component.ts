import { Component, OnInit} from '@angular/core';

/*Providers*/
import {IrisPatientService} from './providers/iris-patient.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent{
  title = 'readmission-ui';

  constructor(private IPS: IrisPatientService){}

  resetDemo(): void {
    this.IPS.resetDemo().subscribe( x => {
      console.log(x);
      if(x.requestResult.status === "OK"){
        window.alert("Demo Reset");
      }else{
        window.alert("Error Resetting Demo");
      }
    })
  }
}
