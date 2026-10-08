trigger Exercise4_Trigger on Offer__c (before insert, before update) {
    new Exercise4TriggerHandler().run();
}