trigger knowledgeArticleAss16 on Knowledge__kav (after insert,after update) {
  Set<Id> kavIds = new Set<Id>();
    for (Knowledge__kav kav : Trigger.new) {
        kavIds.add(kav.Id);
    }
    articleUsageSummaryAss16.updateSummaries(kavIds);

}