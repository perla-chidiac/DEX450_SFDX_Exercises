public with sharing class AccountOpportunityController {

    public class AccountOpportunityWrapper{
        @AuraEnabled public Account acc {get;set;}
        @AuraEnabled public Integer oppCount {get;set;}
        @AuraEnabled public Decimal totalAmount {get;set;}
        @AuraEnabled public List<Opportunity> oppList {get;set;}

        public AccountOpportunityWrapper(Account acc, List<Opportunity> oppList) {
            this.acc = acc;
            this.oppList = oppList;
            this.oppCount = oppList.size();

            Decimal total = 0;
            for (Opportunity opp : oppList){
                if(opp.Amount != null){
                    total += opp.Amount;
                }
            }

            this.totalAmount = total;
        }
    }
    
    @AuraEnabled(cacheable = true)
    public static List<AccountOpportunityWrapper> getAccountOpportunity(){
       List<AccountOpportunityWrapper> wrapperList = new List<AccountOpportunityWrapper>();

       // query account with opportunity
       List<Account> accountsWithOpps = [SELECT Id, Name, (SELECT Id, Name, StageName, Amount FROM Opportunities)
                                        FROM Account
                                        LIMIT 20
                                        ];

        for (Account acc : accountsWithOpps){
            wrapperList.add(new AccountOpportunityWrapper(acc, acc.Opportunities));      
        }

        return wrapperList;
    }

    @AuraEnabled
    public static void updateOpportunityStage(Id opportunityId, String newStage){
        try{
            Opportunity opp = new Opportunity(Id = opportunityId, StageName = newStage);
            update opp;
        } catch(Exception ex){
            throw new AuraHandledException('Error updating opportunity'+ ex.getMessage());
        }
    } 
}