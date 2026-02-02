trigger assigment4 on Case (before insert,after update) {
    // ---->4..When a Case is closed, automatically create a Customer_Feedback__c record linked to the Case with default Status__c = 'Pending'.
   if(Trigger.isAfter && Trigger.isUpdate)
   {
       List<Customer_Feedback__c> feedbackList = new List<Customer_Feedback__c>();

    for (Case cs : Trigger.new) {

        Case oldCase = Trigger.oldMap.get(cs.Id);
        if (oldCase.Case_Status__c != 'Closed' &&
            cs.Case_Status__c == 'Closed') {
            Customer_Feedback__c feedback = new Customer_Feedback__c();
            feedback.Case__c = cs.Id;        // Link to Case
            feedback.Status__c = 'Pending';  // Default status

            feedbackList.add(feedback);
        }
    }

    if (!feedbackList.isEmpty()) {
        insert feedbackList;
    }
   }

}