trigger caseKnowledgeLinkTrigger on Case_Knowledge_Link__c (after insert,after delete) {
   set<Id> knowledgeIds= new set<Id>();
    if(Trigger.isInsert && Trigger.isAfter)
    {
        for(Case_Knowledge_Link__c link:Trigger.New)
        {
            if(link.Knowledge__c!=null)
            {
                knowledgeIds.add(link.Knowledge__c);
            }
        }
    }
    if(Trigger.isAfter && Trigger.isDelete)
    {
        for(Case_Knowledge_Link__c link:Trigger.old)
        {
            if(link.Knowledge__c!=null)
            {
                knowledgeIds.add(link.Knowledge__c);
            }
        }
    }
    
    if(knowledgeIds.isEmpty())
    {
        return;
    }
    //query all the links for affected knowledge articles
     List<Case_Knowledge_Link__c> allLinks=[SELECT Id, Knowledge__c FROM Case_Knowledge_Link__c WHERE Knowledge__c IN:knowledgeIds];
    //count using map
    Map<Id,Integer> knowledgeToCount=new Map<Id,Integer>();
    for(Case_Knowledge_Link__c link:allLinks)
    {
        if(!knowledgeToCount.containsKey(link.Knowledge__c))
        {
            knowledgeToCount.put(link.Knowledge__c,1);
        }
        else{
            knowledgeToCount.put(link.Knowledge__c,knowledgeToCount.get(link.Knowledge__c)+1);
        }
    }
    
    //knowledge records to update
    List<Knowledge__kav> knowledgeToUpdate=new List<Knowledge__kav>();
    for(Id KId:knowledgeIds)
    {
        Integer countValue=knowledgeToCount.containsKey(KId)? knowledgeToCount.get(KId):0;
        knowledgeToUpdate.add(new Knowledge__kav(Id=kId,Linked_Case_Count__c=countValue ) );
        
    }
    
    //update knowledge records
        if(!knowledgeToUpdate.isEmpty())
    {
        update knowledgeToUpdate;
    }
    
   
}