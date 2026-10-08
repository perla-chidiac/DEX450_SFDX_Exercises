trigger Exercise5_Trigger on Payment__c (before insert, before update, before delete, after insert, after update, after delete) {
    new Exercise5TriggerHandler().run();
}