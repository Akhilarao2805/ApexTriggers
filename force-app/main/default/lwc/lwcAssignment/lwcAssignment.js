import { LightningElement,api,wire } from 'lwc';
import Priority from '@salesforce/schema/Case.Priority';
import Status from '@salesforce/schema/Case.Status';
import Subject from '@salesforce/schema/Case.Subject';
import getRecords from '@salesforce/apex/customerFeedbackAssignment.getRecords';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

const columns=[
     {label:'CustomerFeedback Id', fieldName:'Id'},
       {label:'CustomerFeedback Name', fieldName:'Name'},
         {label:'Status', fieldName:'Status__c'}
];
export default class LwcAssignment extends LightningElement {
    @api recordId;
    @api objectApiName;
    fields=[Priority, Status, Subject]

    handleSubmit(event)
    {
        console.log('onsubmit event recordEditForm'+ event.detail.fields)
        const evt=new ShowToastEvent(
            {
                title:"case record edited successfully",
                message:"Record ID"+event.detail.fields.Id,
                variant:"success"
            }
        );
        this.dispatchEvent(evt);
    }

    data=[];
    columns=columns;
    @wire(getRecords,{ caseId: '$recordId'})
    wiredRecord({data,error})
    {
        if(data)
        {
            this.data=data
        }
        else if(error)
        {
            console.log('an unhandled exception occured', error)
        } 
    }
}