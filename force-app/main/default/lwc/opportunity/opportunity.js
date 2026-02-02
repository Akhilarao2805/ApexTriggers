import { LightningElement } from 'lwc';

import Opportunity_Object from '@salesforce/schema/Opportunity';
import Opportunity_Id from '@salesforce/schema/Opportunity.Id';
import Name_field from '@salesforce/schema/Opportunity.Name';
import StageName_field from '@salesforce/schema/Opportunity.StageName';
import Amount_field from '@salesforce/schema/Opportunity.Amount';
import CloseDate_field from '@salesforce/schema/Opportunity.CloseDate';

export default class RecordViewFormLDS extends LightningElement {

    objectApiName = Opportunity_Object;

    
    recordId = '006gL00000ES6TpQAL';

    idfield = Opportunity_Id;
    namefield = Name_field;
    stagefield = StageName_field;
    amountfield = Amount_field;
    closedatefield = CloseDate_field;
}