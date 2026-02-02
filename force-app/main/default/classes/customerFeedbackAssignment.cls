/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : customerFeedbackAssignment
 * Author          : <YourName>
 * Created Date    : Jan 22, 2026
 * Last Modified By: <YourName>
 * Last Modified On: Jan 22, 2026
 * Description     : This class implements for......
 *  
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  Jan 22, 2026  │ <YourName>   │ Initial version
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */

public with sharing class customerFeedbackAssignment {

    @AuraEnabled(cacheable=true)
    public static List<Customer_Feedback__c> getRecords(Id caseId) {

        List<Customer_Feedback__c> lstcf = [SELECT Id,  Name,Status__c  FROM Customer_Feedback__c WHERE Case__c = :caseId ORDER BY CreatedDate DESC LIMIT 5 ];

        return lstcf;
    }
}