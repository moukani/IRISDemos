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

  dtypes = [
    {value: '001', viewValue: 'Home'},
    {value: '002', viewValue: 'Assisted Living Community'},
    {value: '003', viewValue: 'Community Care Nursing Home'},
    {value: '004', viewValue: 'Skilled Nursing Facility'},
    {value: '005', viewValue: 'Rehab Hospital'}
  ]

  constructor() {}

  ngOnInit() {
    if(this.user.endDate === null || this.user.encounterStatus === 'A'){
      this.user.endDate = new Date();
      this.user.dischargeDestination = "001";
    }
  }

  compareFn: ((f1: any, f2: any) => boolean) | null = this.compareByValue;

  compareByValue(f1: any, f2: any) {
    return f1 && f2 && f1.toLowerCase() === f2.toLowerCase();
  }
}
