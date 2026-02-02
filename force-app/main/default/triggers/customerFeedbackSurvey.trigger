trigger customerFeedbackSurvey on Customer_Feedback__c (after insert, after update) {
    //-->11..Trigger	Maintain Total_Surveys__c and Average_Score__c on Account from related Customer_Feedback__c records whenever feedback is created/updated.	aggregate SOQL, GROUP BY, Maps, upsert summary	Medium
    if(Trigger.isAfter &&(Trigger.isInsert || Trigger.isUpdate))
    {
         // Step 1: Collect Account Ids
        Set<Id> accountIds = new Set<Id>();

        for (Customer_Feedback__c fb : Trigger.New) {
            if (fb.Account__c != null) {
                accountIds.add(fb.Account__c);
            }
        }

        if (accountIds.isEmpty()) {
            return;
        }

        // Step 2: Aggregate feedback data
        List<AggregateResult> results = [
            SELECT Account__c accId,
                   COUNT(Id) totalCount,
                   AVG(Score__c) avgScore
            FROM Customer_Feedback__c
            WHERE Account__c IN :accountIds
            GROUP BY Account__c
        ];

        // Step 3: Prepare Account updates
        Map<Id, Account> accountsToUpdate = new Map<Id, Account>();

        for (AggregateResult ar : results) {
            Id accId = (Id) ar.get('accId');
            Integer total = (Integer) ar.get('totalCount');
            Decimal avg = (Decimal) ar.get('avgScore');

            accountsToUpdate.put(accId,
                new Account(
                    Id = accId,
                    Total_Surveys__c = total,
                    Average_Score__c = avg
                )
            );
        }

        // Step 4: Update Accounts
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate.values();
        }
    }

}