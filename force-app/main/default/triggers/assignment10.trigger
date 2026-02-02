trigger assigment10 on Case (before insert) {
    //--->10..Case_Article_Suggestion_Rule__mdt (Category, Priority, Suggestion_Type__c) to set custom field Suggested_Article_Action__c on Case when created.
if(Trigger.isBefore && Trigger.isInsert)
{
    //get all the rules from custom Metadata
    List<Case_Article_Suggestion_Rule__mdt> rules=[SELECT Category__c,Priority__c,Suggestion__c FROM Case_Article_Suggestion_Rule__mdt];
    
    //create map for rule check
    Map<string,string> ruleMap=new map<string,string>();
    
    for(Case_Article_Suggestion_Rule__mdt   rule:rules)
    {
        string key=rule.Category__c + '|'+rule.Priority__c;
        ruleMap.put(key,rule.Suggestion__c);
    }
    //Assign suggested article action on case
    for(case c:Trigger.New)
    {
        if(c.Type!=null && c.Priority!=null)
        {
            string casekey=c.Type +'|' + c.Priority;
            if(ruleMap.containskey(casekey))
            {
                c.Suggested_Article_Action__c=ruleMap.get(caseKey);
            }
        }
    }
    
}   

}