trigger assigment8 on Case (before insert,after update) {
     //--->8..When Case CSAT_Score__c is updated, write a CSAT_History__c record capturing old/new scores and user.
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        List <CSAT_History__c> csat=new List <CSAT_History__c>();
        for(case cs:Trigger.New)
        {
           case oldCSAT=Trigger.oldMap.get(cs.Id);
           CSAT_History__c history=new CSAT_History__c();
            if(cs.CSAT_Score__c!=oldCSAT.CSAT_Score__c)
            {
                history.Case__c=cs.Id;
                history.Old_CSAT_Score__c=oldCSAT.CSAT_Score__c;
                history.New_CSAT_Score__c=cs.CSAT_Score__c;
                history.Changed_by__c=UserInfo.getUserId();
                csat.add(history);
                
            }
        }
        if(!csat.isEmpty())
        {
            insert csat;
        }
    }

}