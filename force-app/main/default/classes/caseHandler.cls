public class caseHandler {
    //2-->when case is created if origin is blank then automatically assigns default value using custom list
    public static void caseCreation(List <case> newCases)
    {
        Case_Config__c config= Case_Config__c.getvalues('Origin');
        if(config==null || string.isBlank(config.Default_Origin__c))
        {
            return;
        }
        for(case cs:newCases)
        {
            if(string.isBlank(cs.Origin__c))
            {
                cs.Origin__c=config.Default_Origin__c;
            }
        }
    }

}