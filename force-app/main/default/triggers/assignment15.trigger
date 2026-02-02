trigger assigment15 on Case (before insert,before update) {
    if (trigger.isBefore &&( trigger.isinsert || trigger.isUpdate)){
        
        OneRuleSharing.validateCsatScore(trigger.New);
    }

}