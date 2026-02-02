public with sharing class OneRuleSharing {
    public static void  validateCsatScore(List<Case> newlst){
        CSAT_Policy__c policy= CSAT_Policy__c.getInstance();
        decimal threshold= policy.Minimum_Allowed_CSAT__c;

        if (threshold==null) return;
        for (case cs: newlst){
            if (cs.CSAT_Score__c!=null && cs.CSAT_Score__c<string.valueof(threshold)){
                cs.addError('CSAT Score of ' + cs.CSAT_Score__c + 
                           ' is below the policy threshold of ' + threshold + 
                           ' for your user/profile.');
            }
        }

    }
 
}