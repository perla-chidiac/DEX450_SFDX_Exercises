public with sharing class Exercise5 {


   public static void handleBeforeDelete(List<Payment__c> oldPayments){
        for(Payment__c p : oldPayments){
            if(p.Status__c == 'Paid'){
                p.addError('A paid payment cannot be deleted.');
            }
        }
    }
    
    public static void handleAfterInsertUpdateDelete(List<Payment__c> newPayment, Map<Id, Payment__c> oldMap){
        Set<Id> oppIds = new Set<Id>();

        if(newPayment != null){
            for(Payment__c p : newPayment){
                if(p.Opportunity__c != null){
                    oppIds.add(p.Opportunity__c);
                }
                if(oldMap != null && oldMap.get(p.Id).Opportunity__c != p.Opportunity__c){
                    if(oldMap.get(p.Id).Opportunity__c != null){
                        oppIds.add(oldMap.get(p.Id).Opportunity__c);
                    }
                }
            }
        } else if(oldMap != null){
            for (Payment__c p : oldMap.values()) {
                if(p.Opportunity__c != null){
                    oppIds.add(p.Opportunity__c);
                }
            }
        }
            
        if(!oppIds.isEmpty()){
            recalculateOpportunities(oppIds, newPayment);
        }
    }

    private static void recalculateOpportunities(Set<Id> oppIds, List<Payment__c> TriggerNew){
        List<Opportunity> parentOpps = [
            SELECT Id, Amount, Total_Paid__c, (SELECT Id, Amount__c, Status__c FROM Payments__r)
            FROM Opportunity
            WHERE Id IN :oppIds
        ];
        List<Opportunity> oppsToUpdate = new List<Opportunity>();

        for(Opportunity opp : parentOpps){
            Decimal runningTotalPaid = 0.0;
            Decimal maxOppAmount = opp.Amount != null ? opp.Amount : 0.0;

            for(Payment__c p : opp.Payments__r){
                if(p.Status__c == 'Paid' && p.Amount__c != null){
                    runningTotalPaid += p.Amount__c;
                }
            }
            if(runningTotalPaid > maxOppAmount){
                if(TriggerNew != null){
                    for(Payment__c p : TriggerNew){
                        if(p.Opportunity__c == opp.Id && p.Status__c == 'Paid'){
                            p.addError('The total paid amount( '+ runningTotalPaid+ ') cannot exceed the Opportunity amount ('+ maxOppAmount + ').');
                        }
                    }
                }
            }
            else {
                opp.Total_Paid__c = runningTotalPaid;
                oppsToUpdate.add(opp);
            }
        }

        if(!oppsToUpdate.isEmpty()){
            update oppsToUpdate;
        }
    }
}