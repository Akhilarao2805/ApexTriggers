public class caseHandlerTrigger12 {
    //---->Implement CaseTrigger 
    public static void beforeInsert(List<case> newcases)
    {
        
            for(case cs:newcases)
            {
                if(cs.Type==null)
                {
                    cs.Type.addError('field shouldnot be blank');
                }
            }
        
        
    }
    
    public static void afterInsert(List<case> newCase)
    {
        
            List <Contact> conlist=new List <Contact>();
            for(Case c:newCase)
            {
                if(c.CSAT_Score__c !=null && c.ContactId!=null)
                {
                    Contact con=new Contact();
                    con.LeadSource='Web';
                    con.Id=c.ContactId;
                    conlist.add(con);
                }
                
            }
            if(!conlist.isEmpty())
            {
               update conlist;
            } 
        
    }
   

}