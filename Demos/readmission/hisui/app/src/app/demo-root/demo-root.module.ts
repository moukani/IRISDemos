import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { ContentContainerComponent } from './content-container/content-container.component';

import {CustomMaterialModule} from '../custom-material/custom-material.module';
import { AdmissionRootComponent } from './admission-root/admission-root.component';
import { WaitingListRootComponent } from './waiting-list-root/waiting-list-root.component';
import { AdmissionSearchFormComponent } from './admission-search-form/admission-search-form.component';
import { AdmissionSearchTableComponent } from './admission-search-table/admission-search-table.component';
import { UserDischargeModalComponent } from './user-discharge-modal/user-discharge-modal.component';
import { AnalyticsRootComponent } from './analytics-root/analytics-root.component'
/*Providers*/
import {IrisPatientService} from '../providers/iris-patient.service';

/*Uniform angualr spinners*/
import { NgxSpinnerModule } from 'ngx-spinner';
import { UserDischargeFormComponent } from './user-discharge-form/user-discharge-form.component';
import { WaitingListTableComponent } from './waiting-list-table/waiting-list-table.component';

@NgModule({
  declarations: [
    ContentContainerComponent,
    AdmissionRootComponent,
    WaitingListRootComponent,
    AdmissionSearchFormComponent,
    AdmissionSearchTableComponent,
    UserDischargeModalComponent,
    UserDischargeFormComponent,
    WaitingListTableComponent,
    AnalyticsRootComponent
  ],
  imports: [
    CommonModule,
    CustomMaterialModule,
    FormsModule,
    NgxSpinnerModule
  ],
  exports: [
    ContentContainerComponent,
    AdmissionRootComponent,
    WaitingListRootComponent
  ],
  providers: [IrisPatientService],
  entryComponents: [
    UserDischargeModalComponent,
  ],
})
export class DemoRootModule { }
