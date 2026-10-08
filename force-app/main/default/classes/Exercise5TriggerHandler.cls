public with sharing class Exercise5TriggerHandler extends TriggerHandler implements ITriggerHandler{

    private Map<Id, Payment__c> newMap;
    private Map<Id, Payment__c> oldMap;
    private List<Payment__c> TriggerNew;
    private List<Payment__c> TriggerOld;
    
    public Exercise5TriggerHandler(){
        this.newMap = (Map<Id, Payment__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Payment__c>) Trigger.oldMap;
        this.TriggerNew= (List<Payment__c>) Trigger.New;
        this.TriggerOld= (List<Payment__c>) Trigger.Old;
    }
    
    
    //Use this variable to disable this trigger from transaction
    public static Boolean TriggerDisabled = false;
    
    //check if the trigger is disabled from transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    
    public override void beforeInsert() {
        
    }

    public override void afterInsert() {
        Exercise5.handleAfterInsertUpdateDelete(TriggerNew, oldMap);
    }
    public  override void beforeUpdate() {
        
    }

    public override void afterUpdate() {
        Exercise5.handleAfterInsertUpdateDelete(TriggerNew, oldMap);
    }
    
    public override void beforeDelete() {
        Exercise5.HandleBeforeDelete(TriggerOld);
    }
    
    public override void afterDelete() {
        Exercise5.handleAfterInsertUpdateDelete(TriggerNew, oldMap);
    }
    
    public override void afterUnDelete() {
        
    }
}