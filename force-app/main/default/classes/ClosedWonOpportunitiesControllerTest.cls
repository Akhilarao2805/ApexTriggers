/**
 * @description Unit tests for ClosedWonOpportunitiesController
 */
@IsTest
private class ClosedWonOpportunitiesControllerTest {
    @TestSetup
    static void setupData() {
        // Users
        User u = [SELECT Id FROM User WHERE IsActive = true AND Profile.Name = 'System Administrator' LIMIT 1];

        // Accounts
        Account a1 = new Account(Name = 'Acme Corp');
        Account a2 = new Account(Name = 'Globex Inc');
        insert new List<Account>{ a1, a2 };

        // Opportunities
        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(Name = 'Opp CW 1', StageName = 'Closed Won', CloseDate = Date.today(), AccountId = a1.Id, Amount = 1000),
            new Opportunity(Name = 'Opp CW 2', StageName = 'Closed Won', CloseDate = Date.today().addDays(-5), AccountId = a2.Id, Amount = 2500),
            new Opportunity(Name = 'Opp Open No Account', StageName = 'Prospecting', CloseDate = Date.today().addDays(10)), // should be filtered out
            new Opportunity(Name = 'Opp CW No Account', StageName = 'Closed Won', CloseDate = Date.today()) // should be filtered out
        };
        insert opps;
    }

    @IsTest
    static void testGetClosedWonOppsDefaultParams() {
        Test.startTest();
        List<ClosedWonOpportunitiesController.OpportunityRow> rows =
            ClosedWonOpportunitiesController.getClosedWonOpps(null, null, null);
        Test.stopTest();

        System.assertNotEquals(null, rows, 'Rows should not be null');
        System.assert(rows.size() >= 2, 'Should return at least the two Closed Won with Account opportunities');
        for (ClosedWonOpportunitiesController.OpportunityRow r : rows) {
            System.assertEquals('Closed Won', r.stageName, 'Stage should be Closed Won');
            System.assertNotEquals(null, r.accountId, 'Account must be populated');
        }
    }

    @IsTest
    static void testGetClosedWonOppsSortingAndLimit() {
        Test.startTest();
        // Limit 1, ensure sorting works and returns only a single row
        List<ClosedWonOpportunitiesController.OpportunityRow> rows =
            ClosedWonOpportunitiesController.getClosedWonOpps(1, 'CloseDate', 'DESC');
        Test.stopTest();

        System.assertEquals(1, rows.size(), 'Limit should restrict results to 1');
        System.assertEquals('Closed Won', rows[0].stageName);
    }

    @IsTest
    static void testGetClosedWonOppsInvalidSortFieldFallsBack() {
        Test.startTest();
        // invalid sort field should fallback to CloseDate
        List<ClosedWonOpportunitiesController.OpportunityRow> rows =
            ClosedWonOpportunitiesController.getClosedWonOpps(50, 'InvalidField__c', 'DOWN');
        Test.stopTest();

        System.assertNotEquals(null, rows);
        System.assert(rows.size() > 0, 'Should still return results despite invalid sort inputs');
    }
}
