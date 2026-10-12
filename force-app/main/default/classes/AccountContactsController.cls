public with sharing class AccountContactsController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsByAccountId(Id accountId, Integer maxRecords){
        Integer recordLimit = (maxRecords != null && maxRecords > 0) ? maxRecords : 100;

        List<Contact> contacts = [SELECT Id, FirstName, LastName, Email, Phone, Title FROM Contact WHERE AccountId = :accountId ORDER BY CreatedDate DESC LIMIT :recordLimit];
        return contacts;
    }
}