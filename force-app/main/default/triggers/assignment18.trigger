trigger assigment18 on Case (before insert,after update) {
    
    //---->18..When Case Origin is changed from Phone to Email or vice versa, log the change in Case_Origin_History__c (old origin, new origin, date).
    
   if(Trigger.isAfter && Trigger.isUpdate)
    {
        List<Case_Origin_History__c> caseorigin=new List<Case_Origin_History__c>();
        
        for(case newcase:Trigger.New)
        {
            case oldcase=Trigger.oldMap.get(newcase.Id);
            
            if(oldcase==null)
            {
                return;
            }
            
            string oldOrigin=oldcase.Origin;
            string newOrigin=newcase.Origin;
            
            if(oldOrigin!= newOrigin)
            {
                Boolean phoneToEmail= oldOrigin=='Email' && newOrigin=='Phone';
                Boolean EmailToPhone=oldOrigin=='Phone' && newOrigin=='Email';
                
                if(phoneToEmail ||EmailToPhone)
                {
                   Case_Origin_History__c originHistory=new Case_Origin_History__c();
                    originHistory.Case__c=newcase.Id;
                    originHistory.New_Origin__c=newOrigin;
                    originHistory.Old_Origin__c=oldOrigin;
                    originHistory.Change_Date__c=system.now();
                    caseorigin.add(originHistory);
                }
            }
        }
        if(!caseorigin.isEmpty())
        {
            insert caseorigin;
        }
    }
    

}