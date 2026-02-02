public class HandlerClsforCF {
    public static void  autoShareCase(list<Customer_Feedback__c> lstCf){
        //storing caseids
        set<id> caseids=new Set<id>();
        for (Customer_Feedback__c cf: lstCF){
            if (cf.Case__c !=null && (cf.Score__c ==1 ||cf.Score__c ==2 ||cf.Score__c ==3 )){
                caseids.add(cf.case__c);
            }
        }
        if (caseids.isempty()){
            return;
        }

        //Fetching csm id
        id csmRole = [
            SELECT Id
            FROM UserRole
            WHERE Name = 'Customer Success Manager'
            LIMIT 1
        ].id;
 
        // 2. Get corresponding GROUP (this is the KEY FIX)
        id roleGroup = [
            SELECT Id
            FROM Group
            WHERE Type IN ('Role', 'RoleAndSubordinates')
            AND RelatedId = :csmRole
            LIMIT 1
        ].id;
       //creating caseshare
       List<CaseShare> shares=new  List<CaseShare>();
        for (id caseid: caseids){
            caseShare cs= new CaseShare();
            cs.CaseId=caseid;
            cs.UserOrGroupId=roleGroup;
            cs.CaseAccessLevel='Edit';
            cs.RowCause= Schema.CaseShare.RowCause.Manual;

            shares.add(cs);
        }
        if (!shares.isempty()){
            insert shares;
        }
    }
 
}