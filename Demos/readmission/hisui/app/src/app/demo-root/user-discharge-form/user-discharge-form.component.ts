import { Component, OnInit, Input } from '@angular/core';

/*Providers*/
import {EMRUser} from '../../providers/iris-patient.service';

@Component({
  selector: 'app-user-discharge-form',
  templateUrl: './user-discharge-form.component.html',
  styleUrls: ['./user-discharge-form.component.css']
})
export class UserDischargeFormComponent implements OnInit {

  @Input() user: EMRUser;

  specialties = [
    "Back",
    "Hand",
    "Finger",
    "Cardiology",
    "Podiatry",
    "Ophthamology"
  ]

  dtypes = [
    "Home",
    "ICU",
    "Deceased"
  ]

  constructor() {}

  ngOnInit() {
    if(this.user.endDate === null || this.user.encounterStatus === 'A'){
      this.user.endDate = new Date();
    }
  }

  compareFn: ((f1: any, f2: any) => boolean) | null = this.compareByValue;

  compareByValue(f1: any, f2: any) {
    return f1 && f2 && f1.toLowerCase() === f2.toLowerCase();
  }
}
