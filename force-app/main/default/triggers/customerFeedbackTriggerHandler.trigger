trigger customerFeedbackTriggerHandler on Customer_Feedback__c (before delete) {
    //--->17..Prevent deletion of Customer_Feedback__c if the related Case is still open
     if(Trigger.isBefore && Trigger.isDelete)
  {
      set<Id> caseIds=new set<Id>();
      for(Customer_Feedback__c cfk:Trigger.old)
      {
          if(cfk.Case__c !=null)
          {
              caseIds.add(cfk.Case__c);
          }
      }
      if(caseIds.isEmpty())
      {
          return;
      }
      
      //query related cases
      List<case> cslst=[SELECT Id,Case_Status__c FROM case WHERE Id IN:caseIds ];
      
      Map<Id,case> caseMap=new Map<Id, case>();
      
      for(case c:cslst)
      {
          caseMap.put(c.Id,c);
      }
      
      //prevent deletion if case is not closed
      for(Customer_Feedback__c fb:Trigger.old)
      {
          case relatedCase=caseMap.get(fb.Case__c);
          if(relatedCase!=null && relatedCase.Case_Status__c !='Closed')
          {
              fb.addError('Customer Feedback cannot be deleted while the related Case is still open.');
          }
      }
      
  }

}