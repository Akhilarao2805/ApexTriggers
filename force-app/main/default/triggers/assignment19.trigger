trigger assigment19 on Case (before insert,before update) {
    //--->19..Ensure no Case can be closed with Type = 'Incident' unless at least one Knowledge__kav link exists via Case_Knowledge_Link__c.
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        //collecting incident case ids that are being closed
        set<Id> caseIds =new set<Id>();
        for(case cs:Trigger.New)
        {
            case oldcase=Trigger.oldMap.get(cs.Id);
            if(cs.Case_Status__c =='Closed' && cs.Type=='Incident' && oldcase.Case_Status__c !='Closed')
            {
                caseIds.add(cs.Id);
            }
        }
        if(caseIds.isEmpty())
        {
            return;
        }
        set<Id> caseWithValidKnowledge=new set<Id>();
         
        List<Case_Knowledge_Link__c> caselink=[SELECT Id,Case__c,Knowledge__c FROM Case_Knowledge_Link__c WHERE Case__c IN:caseIds AND Knowledge__c!=null ];
        for(Case_Knowledge_Link__c link:caselink)
        {
            caseWithValidKnowledge.add(link.Case__c);
        }
        
        //prevent closing if no valid knowledge link exist
        for(case c:Trigger.New)
        {
            if(caseIds.contains(c.Id) && !caseWithValidKnowledge.contains(c.Id))
            {
                c.addError('Incident cases cannot be closed unless atlease one knowledge article is linked');
            }
        }
        
    }

}