trigger Assigment12 on Customer_Feedback__c (before insert,after insert,before update,after update) {
    
    if (trigger.isafter && (trigger.isInsert || trigger.isUpdate)){
        HandlerClsforCF.autoShareCase(trigger.new);
    }
    
    
    /*FeedbackTriggerHandler handler=new FeedbackTriggerHandler();
    if(trigger.isbefore){
        if(trigger.isInsert){
        handler.onbeforeInsert(trigger.new);
    }
        if (  trigger.isUpdate){
            handler.onBeforeUpdate(trigger.old, trigger.new);
        }
    }*/
}