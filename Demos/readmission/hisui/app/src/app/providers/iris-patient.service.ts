import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export class EMRUser {
  firstName: string;
  lastName: string;
  MRN: string;
  admissionNumber: string;
  admissionStartDate: Date;
  admissionEndDate: Date;
  specialty: string;
  dischargeType: string;
  dischargedBy: string;

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
    admissionNumber: string,
    admissionStartDate: Date,
    admissionEndDate: Date,
    specialty: string,
    dischargeType: string,
    dischargedBy: string
  ){
    this.firstName = firstName;
    this.lastName = lastName;
    this.MRN = mrn;
    this.admissionNumber = admissionNumber;
    this.admissionStartDate = admissionStartDate;
    this.admissionEndDate = admissionEndDate;
    this.specialty = specialty;
    this.dischargeType = dischargeType;
    this.dischargedBy = dischargedBy;
  }
}

export class UserSearchRequest {
  firstName: string;
  lastName: string;
  MRN: string;
  admissionNumber: string;
  admissionDate: Date;

  constructor(){
    this.firstName = "";
    this.lastName = "";
    this.MRN = "";
    this.admissionNumber = "";
    this.admissionDate = new Date();
  }
}

export class DischargeRequest {
  firstName: string;
  lastName: string;
  admissionNumber: string;
  dischargeDate: Date;
}

const PatientData1 = [
  {
    firstName: "Phillip",
    lastName: "Booth",
    MRN: "1",
    admissionNumber: "1",
    admissionStartDate: new Date(2018, 0, 8),
    admissionEndDate: null,
    specialty: "cardiology",
    dischargeType: null,
    dischargedBy: null
  },
  {
    firstName: "Amir",
    lastName: "Samary",
    MRN: "2",
    admissionNumber: "2",
    admissionStartDate: new Date(2018, 0, 9),
    admissionEndDate: null,
    specialty: "podiatry",
    dischargeType: null,
    dischargedBy: null
  },
  {
    firstName: "Iain",
    lastName: "Bray",
    MRN: "3",
    admissionNumber: "3",
    admissionStartDate: new Date(2018, 0, 10),
    admissionEndDate: null,
    specialty: "ophthamology",
    dischargeType: null,
    dischargedBy: null
  }
]

const PatientData2 = [
  {
    firstName: "Phillip",
    lastName: "Booth",
    MRN: "4",
    admissionNumber: "4",
    admissionStartDate: new Date(2018, 0, 9),
    admissionEndDate: null,
    specialty: "back",
    dischargeType: null,
    dischargedBy: null
  },
  {
    firstName: "Amir",
    lastName: "Samary",
    MRN: "5",
    admissionNumber: "5",
    admissionStartDate: new Date(2018, 0, 10),
    admissionEndDate: null,
    specialty: "hand",
    dischargeType: null,
    dischargedBy: null
  },
  {
    firstName: "Iain",
    lastName: "Bray",
    MRN: "6",
    admissionNumber: "6",
    admissionStartDate: new Date(2018, 0, 11),
    admissionEndDate: null,
    specialty: "finger",
    dischargeType: null,
    dischargedBy: null
  }
]

@Injectable({
  providedIn: 'root'
})
export class IrisPatientService {

  constructor(private http: HttpClient) { }

  EMRUserBuilder(converisonObj: any): EMRUser{
    return new EMRUser(
      converisonObj.firstName,
      converisonObj.lastName,
      converisonObj.MRN,
      converisonObj.admissionNumber,
      converisonObj.admissionStartDate,
      converisonObj.admissionEndDate,
      converisonObj.specialty,
      converisonObj.dischargeType,
      converisonObj.dischargedBy
    );
  }

  sp1(usr: UserSearchRequest): any{
    console.log(usr);
    let EMRUSerList = PatientData1.map(this.EMRUserBuilder)
    return EMRUSerList;
  }

  sp2(usr: UserSearchRequest): any{
    console.log(usr);
    let EMRUSerList = PatientData2.map(this.EMRUserBuilder)
    return EMRUSerList;
  }

  dis(dr: DischargeRequest): any{
    console.log(dr);
    return 1;
  }

  /*searchPatients(): Observable<any>{

  }

  dischargePatient(): Observable<any>{

  }*/
}
