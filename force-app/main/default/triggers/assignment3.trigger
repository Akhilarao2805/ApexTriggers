trigger assigment3 on Case (before update) {
        //--->3..Trigger	Prevent changing Case Status back from Closed to any open status if CSAT_Score__c is already filled.	before update, trigger.oldMap, addError()
    if(Trigger.isBefore && Trigger.isUpdate)
    {
     
     for (Case newCase : Trigger.new) {
        Case oldCase = Trigger.oldMap.get(newCase.Id);

        // Check if Case is being reopened
        if (oldCase.Case_Status__c == 'Closed' &&
            newCase.Case_Status__c != 'Closed' &&
            oldCase.CSAT_Score__c != null) {
            newCase.Case_Status__c.addError('You cannot reopen this Case because the CSAT score has already been submitted.');
        }
    }
   }

}