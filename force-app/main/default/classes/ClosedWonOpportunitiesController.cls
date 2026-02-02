/**
 * @description Apex controller to fetch Closed Won Opportunities related to an Account for LWC datatable.
 * Enforces sharing, bulkified query with limit and selectable fields.
 * Uses USER_MODE for queries where applicable and WITH SECURITY_ENFORCED to respect FLS.
 */
public with sharing class ClosedWonOpportunitiesController {
    // Use constants instead of Apex enums for cross-version compatibility in metadata parsing
    public static final String SORT_ASC = 'ASC';
    public static final String SORT_DESC = 'DESC';

    public class OpportunityRow {
        @AuraEnabled public Id id;
        @AuraEnabled public String name;
        @AuraEnabled public Decimal amount;
        @AuraEnabled public Date closeDate;
        @AuraEnabled public String stageName;
        @AuraEnabled public Id accountId;
        @AuraEnabled public String accountName;
        @AuraEnabled public Id ownerId;
        @AuraEnabled public String ownerName;

        public OpportunityRow(Opportunity o) {
            this.id = o.Id;
            this.name = o.Name;
            this.amount = o.Amount;
            this.closeDate = o.CloseDate;
            this.stageName = o.StageName;
            this.accountId = (o.AccountId);
            this.accountName = (o.Account != null ? o.Account.Name : null);
            this.ownerId = (o.OwnerId);
            this.ownerName = (o.Owner != null ? o.Owner.Name : null);
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<OpportunityRow> getClosedWonOpps(Integer limitSize, String sortBy, String sortDirection) {
        Integer finalLimit = (limitSize == null || limitSize <= 0 || limitSize > 200) ? 200 : limitSize;
        String sortField = String.isBlank(sortBy) ? 'CloseDate' : sortBy;
        String sortDir = String.isBlank(sortDirection) ? SORT_DESC : sortDirection;

        // Allowlist sortable fields to avoid injection and invalid fields
        Set<String> sortable = new Set<String>{ 'Name', 'Amount', 'CloseDate', 'StageName' };
        if (!sortable.contains(sortField)) {
            sortField = 'CloseDate';
        }
        if (sortDir != SORT_ASC && sortDir != SORT_DESC) {
            sortDir = SORT_DESC;
        }

        // Build dynamic query string for ORDER BY, enforce USER_MODE and FLS with WITH SECURITY_ENFORCED.
        // We can't bind ORDER BY dynamically in static SOQL, so we use Database.query with a safe allowlist.
        String orderClause = ' ORDER BY ' + sortField + ' ' + sortDir + ' ';
        String soql = 
            'SELECT Id, Name, Amount, CloseDate, StageName, AccountId, Account.Name, OwnerId, Owner.Name ' +
            'FROM Opportunity WITH USER_MODE WITH SECURITY_ENFORCED ' +
            'WHERE StageName = :stage AND AccountId != null' +
            orderClause +
            ' LIMIT :lim';
        
        Integer lim = finalLimit;
        String stage = 'Closed Won';
        // Replace bind-style with string formatting of limit; stage will be concatenated safely using escapeSingleQuotes
        String finalQuery = 'SELECT Id, Name, Amount, CloseDate, StageName, AccountId, Account.Name, OwnerId, Owner.Name ' +
                            'FROM Opportunity WITH USER_MODE WITH SECURITY_ENFORCED ' +
                            'WHERE StageName = \'' + String.escapeSingleQuotes(stage) + '\' AND AccountId != null' +
                            orderClause +
                            ' LIMIT ' + String.valueOf(lim);
        List<Opportunity> opps = Database.query(finalQuery);

        List<OpportunityRow> rows = new List<OpportunityRow>();
        for (Opportunity o : opps) {
            rows.add(new OpportunityRow(o));
        }
        return rows;
    }
}
