import { Component, OnInit, ViewChild } from '@angular/core';

import {MatPaginator, MatSort, MatTableDataSource} from '@angular/material';

class WaitingUser {
  firstName: string;
  lastName: string;
  description: string;
  admittedOn: Date;

  constructor(covObj){
    this.firstName = covObj.firstName;
    this.lastName = covObj.lastName;
    this.description = covObj.description;
    this.admittedOn = new Date();
  }
}

const MOCKDATA = [
  {firstName: "Clark", lastName: "Kent" , description: "Poked in eye"},
  {firstName: "Ronald", lastName: "Macdonald" , description: "Stomach Ache"},
  {firstName: "Barry", lastName: "Allen" , description: "Hurt left foot"},
  {firstName: "Michael", lastName: "Fitzgerald" , description: "Sore left shoulder"},
  {firstName: "Rocky", lastName: "Balboa" , description: "Cut over left Eye"},
  {firstName: "Clark", lastName: "Kent" , description: "Poked in eye"},
  {firstName: "Clark", lastName: "Kent" , description: "Poked in eye"},
  {firstName: "Clark", lastName: "Kent" , description: "Poked in eye"},
  {firstName: "Clark", lastName: "Kent" , description: "Poked in eye"},
  {firstName: "Clark", lastName: "Kent" , description: "Poked in eye"},
  {firstName: "Clark", lastName: "Kent" , description: "Poked in eye"},
]

@Component({
  selector: 'app-waiting-list-table',
  templateUrl: './waiting-list-table.component.html',
  styleUrls: ['./waiting-list-table.component.css']
})
export class WaitingListTableComponent implements OnInit {

  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;

  displayedColumns: string[] = ['First Name', 'Last Name', 'Description', 'Checked In'];
  dataSource: MatTableDataSource<WaitingUser>;

  constructor() {
    this.dataSource = new MatTableDataSource(MOCKDATA.map(this.createWaitingUser));
  }

  ngOnInit() {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  applyFilter(filterValue: string) {
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  createWaitingUser(conversionObj: any){
    return new WaitingUser(conversionObj)
  }

}
