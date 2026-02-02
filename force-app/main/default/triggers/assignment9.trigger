trigger assigment9 on Case (before insert,after update) {
    
    //--->9..When a Case is closed, update Last_Case_Closed_Date__c and average CSAT__c fields on Account using all closed Cases.
   if (Trigger.isAfter && Trigger.isUpdate) {

    Set<Id> accountIds = new Set<Id>();

    for (Case cs : Trigger.New) {
        Case oldCs = Trigger.oldMap.get(cs.Id);

        if (cs.Case_Status__c == 'Closed' &&
            oldCs.Case_Status__c != 'Closed' &&
            cs.AccountId != null) {

            accountIds.add(cs.AccountId);
        }
    }

    if (accountIds.isEmpty()) {
        return;
    }

    List<Case> closedCases = [
        SELECT AccountId, ClosedDate, CSAT_Score__c, Case_Status__c
        FROM Case
        WHERE Case_Status__c = 'Closed'
        AND AccountId IN :accountIds
    ];

    Map<Id, Date> lastClosedDate = new Map<Id, Date>();
    Map<Id, Integer> csatSum = new Map<Id, Integer>();
    Map<Id, Integer> csatCount = new Map<Id, Integer>();

    for (Case c : closedCases) {

        // Latest Closed Date
        if (c.ClosedDate != null) {
            Date closedDateOnly = system.today();

            if (!lastClosedDate.containsKey(c.AccountId) ||
                closedDateOnly > lastClosedDate.get(c.AccountId)) {

                lastClosedDate.put(c.AccountId, closedDateOnly);
            }
        }

        // CSAT Average calculation
        if (c.CSAT_Score__c != null) {
            Integer csatValue = Integer.valueOf(c.CSAT_Score__c);

            csatSum.put(
                c.AccountId,
                (csatSum.containsKey(c.AccountId)
                    ? csatSum.get(c.AccountId)
                    : 0) + csatValue
            );

            csatCount.put(
                c.AccountId,
                (csatCount.containsKey(c.AccountId)
                    ? csatCount.get(c.AccountId)
                    : 0) + 1
            );
        }
    }

    List<Account> accountToUpdate = new List<Account>();

    for (Id accId : accountIds) {
        Account acc = new Account();
        acc.Id = accId;

        if (lastClosedDate.containsKey(accId)) {
            acc.Last_Case_Closed_Date__c = lastClosedDate.get(accId);
        }

        if (csatCount.containsKey(accId) &&
            csatCount.get(accId) > 0) {

            acc.Average_CSAT__c =
                (Decimal) csatSum.get(accId) /
                csatCount.get(accId);
        }

        accountToUpdate.add(acc);
    }

    update accountToUpdate;
}
    
    

}