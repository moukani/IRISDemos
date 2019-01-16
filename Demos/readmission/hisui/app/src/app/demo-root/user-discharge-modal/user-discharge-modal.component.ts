import { Component, OnInit, Inject } from '@angular/core';

import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

/*Models*/
import {EMRUser, DischargeRequest} from '../../providers/iris-patient.service';

/*Providers*/
import { NgxSpinnerService } from 'ngx-spinner';

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

  shallowUserDataCopy: EMRUser;
  allowDischarge: boolean;

  constructor(
    private spinner: NgxSpinnerService,
    public dialogRef: MatDialogRef<UserDischargeModalComponent>,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {

      /*Creating a shallow copy for editing in the dialog while still Keeping it as the correct class type*/
      this.shallowUserDataCopy = Object.assign( Object.create( Object.getPrototypeOf(data.user)), data.user)
      this.allowDischarge = this.shallowUserDataCopy.encounterStatus !== "D";
    }

  onNoClick(): void {
    this.dialogRef.close();
  }

  dischargePatient(): void {
    this.data.discharge(this.shallowUserDataCopy);
  }

  ngOnInit() {}

}
