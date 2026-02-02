trigger assigment2 on Case (before insert) {
       //--->2..When a Case is created with Priority = 'High' and Status = 'New', change the Status to 'In Progress'.
     if(Trigger.isBefore && Trigger.isInsert)
    {
       caseHandler.caseCreation(Trigger.New);
    }

}