trigger assigment7 on Case (before insert,after update) {
    //--->7..When a Case is updated and a Primary_Article__c lookup is populated, ensure no other Case_Knowledge_Link__c for that Case is marked Is_Primary__c = true.
if(Trigger.isAfter && Trigger.isUpdate)
{
    set<Id> caseIds=new set <Id>();
    Map<Id,Id> caseToPrimaryArticle=new Map<Id,Id>();
    for(case cs:Trigger.New)
    {
        case oldcs=Trigger.oldMap.get(cs.Id);
        if(cs.Primary_Article__c !=null && cs.Primary_Article__c!=oldcs.Primary_Article__c)
        {
            caseIds.add(cs.Id);
            caseToPrimaryArticle.put(cs.Id,cs.Primary_Article__c);
        }
    }
    if(caseIds.isEmpty())
    {
        return;
    }
    List<Case_Knowledge_Link__c> links=[SELECT Id,Case__c,Knowledge__c,Is_Primary__c FROM Case_Knowledge_Link__c WHERE Case__c IN:caseIds];
    
    //one primary arcticle per case
    for(Case_Knowledge_Link__c link:links)
    {
        if(link.Knowledge__c== caseToPrimaryArticle.get(link.Case__c))
        {
            link.Is_Primary__c=true;
        }
        else{
            link.Is_Primary__c=false;
        }
    }
    update links;
}
   

}