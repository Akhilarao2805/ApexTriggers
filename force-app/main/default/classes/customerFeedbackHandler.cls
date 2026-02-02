public class customerFeedbackHandler {
    //-->13..Customer_Feedback__c trigger using handler classes with beforeInsert, afterInsert, etc.
    public static void beforeInsert(List<Customer_Feedback__c> newfeedback)
    {
        for(Customer_Feedback__c cf:newfeedback)
        {
            if(cf.Score__c==null)
            {
                cf.addError('field should not be blank');
            }
        }    
 
    }
    
           public static void afterInsert(List<Customer_Feedback__c> newfeedbacks)
        {
             List<case> cs=new List<case>();
            for(Customer_Feedback__c cfb: newfeedbacks){
               
                if(cfb.Status__c!=null)
                {
                    case c=new case();
                    cfb.Case__c=c.Id;
                    c.Comments='updated using customer feedback record';
                    cs.add(c);
                }
            }
           if(!cs.isEmpty())
           {
               update cs;
           }
        }

}