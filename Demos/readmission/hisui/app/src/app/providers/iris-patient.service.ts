import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';

import DemoConfig from '../config/demo_config';

export class EMRUser {
  firstName: string;
  lastName: string;
  MRN: string;
  encounterNumber: string;
  startDate: Date;
  startTime: string;
  endDate: Date;
  endTime: string;
  DoB: Date;
  encounterStatus: string;
  encounterType: string;
  dischargeDestination: string;
  gender: string;

  prettyPrintDate(dateForConversion: Date): string{

    let output: string = "";

    if(dateForConversion){
      output = (dateForConversion.getMonth() + 1) + "/" +
      dateForConversion.getDate() + "/" +
      dateForConversion.getFullYear();
    }

    return output;
  }

  constructor(
    firstName: string,
    lastName: string,
    mrn: string,
    encounterNumber: string,
    startDate: string,
    startTime: string,
    endDate: string,
    endTime: string,
    dob: string,
    encounterStatus: string,
    encounterType: string,
    dischargeDestination: string,
    gender: string
  ){
    this.firstName = firstName;
    this.lastName = lastName;
    this.MRN = mrn;
    this.encounterNumber = encounterNumber;
    this.startDate = new Date(startDate);
    this.startTime = startTime;
    this.endDate = new Date(endDate);
    this.endTime = endTime;
    this.DoB = new Date(dob);
    this.encounterStatus = encounterStatus;
    this.encounterType = encounterType;
    this.dischargeDestination = dischargeDestination;
    this.gender = gender;
  }
}

export class UserSearchRequest {
  firstName: string;
  lastName: string;
  MRN: string;
  encounterNumber: string;
  admissionDate: Date;

  constructor(){
    this.firstName = "";
    this.lastName = "";
    this.MRN = "";
    this.encounterNumber = "";
    this.admissionDate = new Date();
  }
}

export class DischargeRequest {
  firstName: string;
  lastName: string;
  MRN: string;
  encounterId: string;

  constructor(firstName: string, lastName: string, MRN: string, encounterNumber: string){
    this.firstName = firstName;
    this.lastName = lastName;
    this.MRN = MRN;
    this.encounterId = encounterNumber;
  }

}

@Injectable({
  providedIn: 'root'
})
export class IrisPatientService {

  constructor(private http: HttpClient) { }

  EMRUserBuilder(conversionObj: any): EMRUser{
    return new EMRUser(
      conversionObj.FirstName,
      conversionObj.LastName,
      conversionObj.MRN,
      conversionObj.EncounterNumber,
      conversionObj.StartDate,
      conversionObj.StartTime,
      conversionObj.EndDate,
      conversionObj.EndTime,
      conversionObj.DoB,
      conversionObj.EncounterStatus,
      conversionObj.EncounterType,
      conversionObj.DischargeDestination,
      conversionObj.Gender
    );
  }

  getEmpyUser(): EMRUser {
    return new EMRUser("", "", "", "","", "", "", "", "", "", "", "", "");
  }

  getAuthHeader(): HttpHeaders{
    const header = new HttpHeaders()
            .set("Authorization", "Basic " + btoa(DemoConfig.CREDENTIALS.userName + ":" + DemoConfig.CREDENTIALS.password));

    return header;
  }

  resetDemo(): Observable<any> {
    const header = this.getAuthHeader();

    return this.http.get(
      DemoConfig.URL.resetDemo,
      {
          headers: header
      }
    )
  }

  dischargePatient(dischargeObj: DischargeRequest): Observable<any>{
    const header = this.getAuthHeader();

    return this.http.post(
      DemoConfig.URL.dischargeUser,
      dischargeObj,
      {
          headers: header
      }
    )
  }

  searchForUser(MRN: string, firstName: string, lastName: string): Observable<any>{

    const header = this.getAuthHeader();
    const params = new HttpParams()
      .set("MRN", MRN || "")
      .set("firstName", firstName || "")
      .set("lastName", lastName || "")


    return this.http.get(
      DemoConfig.URL.userList,
      {
        headers: header,
        params: params
      }
    )
  }
}
