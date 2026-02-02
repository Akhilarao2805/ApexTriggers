trigger assigment13 on Case (before insert,after insert) {
     //--->13..Implement CaseTrigger 
   if(Trigger.isBefore && Trigger.isInsert)
    {
        caseHandlerTrigger12.beforeInsert(Trigger.New);
    }
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
         caseHandlerTrigger12.afterInsert(Trigger.New);
    }

}