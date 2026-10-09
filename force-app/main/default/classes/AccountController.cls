public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(Integer maxRecords){
        List<Account> accounts = [SELECT Id, Name FROM Account ORDER BY CreatedDate DESC LIMIT :maxRecords];
        return accounts;
    }

    @AuraEnabled
    public static string createAccount(String accountName){
        Account newAccount = new Account(Name = accountName);
        insert newAccount;
        return JSON.serialize(newAccount);
    }
}