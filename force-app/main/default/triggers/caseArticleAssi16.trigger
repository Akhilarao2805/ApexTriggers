trigger caseArticleAssi16 on Case_Article__c (after insert,after delete) {
    Set<Id> articleIds = new Set<Id>();
    if (Trigger.isInsert) {
        for (Case_Article__c ca : Trigger.new) articleIds.add(ca.Knowledge_Article_Id__c);
    }
    if (Trigger.isDelete) {
        for (Case_Article__c ca : Trigger.old) articleIds.add(ca.Knowledge_Article_Id__c);
    }
    articleUsageSummaryAss16.updateSummaries(articleIds);

}