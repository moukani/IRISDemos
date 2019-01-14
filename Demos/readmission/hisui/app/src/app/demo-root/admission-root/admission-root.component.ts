import { Component, OnInit } from '@angular/core';

/*Providers*/
import {IrisPatientService, EMRUser, UserSearchRequest, DischargeRequest} from '../../providers/iris-patient.service';
import { NgxSpinnerService } from 'ngx-spinner';
import {MatDialog} from '@angular/material';

import {UserDischargeModalComponent} from '../user-discharge-modal/user-discharge-modal.component';

@Component({
  selector: 'app-admission-root',
  templateUrl: './admission-root.component.html',
  styleUrls: ['./admission-root.component.css']
})
export class AdmissionRootComponent implements OnInit {

  requestNum = 0;
  userSearchRequest: UserSearchRequest = new UserSearchRequest();
  dischargeRequest: DischargeRequest = new DischargeRequest();
  currentlySelectedUser: EMRUser;
  patientList: EMRUser[] = [];

  /*Binding any methods that are shared with children so they may be called in the parent context*/
  sharedUserSearch = this.searchPatients.bind(this);
  sharedDialogOpen = this.openDialog.bind(this);

  constructor(
    private IPS: IrisPatientService,
    private spinner: NgxSpinnerService,
    private dialog: MatDialog) {}

  ngOnInit() {}

  openDialog(selectedUser): void {
    this.currentlySelectedUser = selectedUser;
    const dialogRef = this.dialog.open(UserDischargeModalComponent, {
      width: '400px',
      data: {user: this.currentlySelectedUser}
    });

    dialogRef.afterClosed().subscribe(result => {
      this.currentlySelectedUser = null;
      console.log('The dialog was closed');
      console.log('Currently Selected User', this.currentlySelectedUser);
    });
  }

  searchPatients(): any {
    console.log("searching Users", this.userSearchRequest);
    if(this.requestNum % 2 === 0){
      this.patientList = this.IPS.sp1(this.userSearchRequest);
    }else{
      this.patientList = this.IPS.sp2(this.userSearchRequest);
    }
    this.requestNum ++;
  }


}
