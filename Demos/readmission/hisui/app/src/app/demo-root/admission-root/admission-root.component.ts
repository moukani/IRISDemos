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

  userSearchRequest: UserSearchRequest = new UserSearchRequest();
  currentlySelectedUser: EMRUser = this.IPS.getEmpyUser();
  patientList: EMRUser[] = [];

  /*Binding any methods that are shared with children so they may be called in the parent context*/
  sharedUserSearch = this.searchPatients.bind(this);
  sharedDialogOpen = this.openDialog.bind(this);
  sharedDischargePatient = this.dischargePatient.bind(this);

  constructor(
    private IPS: IrisPatientService,
    private spinner: NgxSpinnerService,
    private dialog: MatDialog) {

      this.IPS.resetDemoEmitter.subscribe(shouldReset =>{
        if(shouldReset){
          this.resetDemo();
          window.alert("Demo Reset");
        }
      },
      (err) =>{
        window.alert("Error Resetting Demo");
      });

    }

  ngOnInit() {}

  resetDemo() :void {
    this.userSearchRequest = new UserSearchRequest();
    this.currentlySelectedUser = this.IPS.getEmpyUser();
    this.patientList = [];
  }

  openDialog(selectedUser): void {
    this.currentlySelectedUser = selectedUser;
    const dialogRef = this.dialog.open(UserDischargeModalComponent, {
      width: '400px',
      data: {user: this.currentlySelectedUser, discharge: this.sharedDischargePatient}
    });

    dialogRef.afterClosed().subscribe(result => {
      console.log('The dialog was closed');
      console.log('Currently Selected User', this.currentlySelectedUser);
    });
  }

  admissionSort(a: any, b: any): number {
    return (b.startDate - a.startDate);
  }

  clearDischargedPatient(encounterNumber: string): void {
    let dischargedPatient: EMRUser = this.patientList.find( rec =>{
      return rec.encounterNumber === encounterNumber;
    });

    if (dischargedPatient){
      dischargedPatient.endDate = new Date();
      dischargedPatient.encounterStatus = "D";
    }
  }

  searchPatients(): void {
    console.log("searching Users", this.userSearchRequest);
    this.IPS.searchForUser(
      this.userSearchRequest.MRN,
      this.userSearchRequest.firstName,
      this.userSearchRequest.lastName,
      this.userSearchRequest.encounterNumber).subscribe( res =>{
          try{
            if(res && res.requestResult && res.encounters){
              if(res.requestResult.status === "OK"){
                this.patientList = res.encounters.map(this.IPS.EMRUserBuilder).sort(this.admissionSort);
              }
            }
          }catch(err){
            console.log("error transforming encounter data: ", err);
          }
        },
        (err) => {console.log("Error Loading User List: ", err);});
  }

  dischargePatient(patient: EMRUser): void {
    console.log("dischargingPatient: ", this.currentlySelectedUser);

    const dischargeRequest = new DischargeRequest(
      patient.firstName,
      patient.lastName,
      patient.MRN,
      patient.encounterId,
      patient.dischargeDestination);

    this.IPS.dischargePatient(dischargeRequest).subscribe(res => {
      try{
        this.spinner.show();
        this.dialog.closeAll();
        setTimeout(() => { /*Adding in so dischrge spinner can display to users*/
          this.spinner.hide();
          if(res && res.requestResult){
            if(res.requestResult.status === "OK"){
              this.clearDischargedPatient(patient.encounterNumber);
            }
          }
        }, 2000);
      }catch(err){
        this.spinner.hide();
        console.log("issue discharing error closing dialog: ", err);
      }
    },
    (err) => {
      console.log("Error Discharging User: ", err)
      this.spinner.hide();
    })
  }
}
