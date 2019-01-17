import { Component, OnInit, Inject } from '@angular/core';

import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

/*Providers*/
import { NgxSpinnerService } from 'ngx-spinner';
import {IrisPatientService, EMRUser, DischargeRequest} from '../../providers/iris-patient.service';

export interface DialogData {
  user: EMRUser;
  discharge: any
}

@Component({
  selector: 'app-user-discharge-modal',
  templateUrl: './user-discharge-modal.component.html',
  styleUrls: ['./user-discharge-modal.component.css']
})
export class UserDischargeModalComponent implements OnInit {

  patient: EMRUser;
  allowDischarge: boolean;
  hasError: boolean;

  constructor(
    private IPS: IrisPatientService,
    private spinner: NgxSpinnerService,
    public dialogRef: MatDialogRef<UserDischargeModalComponent>,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {

      /*Creating a shallow copy for editing in the dialog while still Keeping it as the correct class type*/
      this.patient = Object.assign( Object.create( Object.getPrototypeOf(data.user)), data.user)
      this.allowDischarge = this.patient.encounterStatus !== "D";
  }

  ngOnInit() {}

  onNoClick(): void {
    this.dialogRef.close();
  }

  dischargePatient(): void {
    console.log("dischargingPatient: ", this.patient);
    this.hasError = false;

    const dischargeRequest = new DischargeRequest(
      this.patient.firstName,
      this.patient.lastName,
      this.patient.MRN,
      this.patient.encounterId,
      this.patient.dischargeDestination);

    this.IPS.dischargePatient(dischargeRequest).subscribe(res => {
      try{
        this.spinner.show();
        setTimeout(() => { /*Adding in so dischrge spinner can display to users*/
          this.spinner.hide();
          if(res && res.requestResult){
            if(res.requestResult.status === "OK"){
              this.data.discharge(this.patient.encounterNumber);
              this.onNoClick();
            }else{
              this.hasError = true;
            }
          }
        }, 2000);
      }catch(err){
        this.spinner.hide();
        console.log("issue discharing error closing dialog: ", err);
        this.hasError = true;
      }
    },
    (err) => {
      console.log("Error Discharging User: ", err)
      this.hasError = true;
      this.spinner.hide();
    });
  }
}
