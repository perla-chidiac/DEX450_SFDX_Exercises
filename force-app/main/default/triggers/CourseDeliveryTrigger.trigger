trigger CourseDeliveryTrigger on Course_Delivery__c (before insert, before update) {
    // Retrieve the Custom Metadata Type record
    Trigger_Switch__mdt tsw = Trigger_Switch__mdt.getInstance('Course_Delivery_Trigger');

    if (tsw == null || tsw.Active_Flag__c == true){
    //     // Get Holidays
    //     Set<Date> allHolidays = new Set<Date>();
    //     for(Holiday h : [SELECT ActivityDate FROM Holiday]){
    //         allHolidays.add(h.ActivityDate);
    //     }

    //     for (Course_Delivery__c cd : Trigger.new) {
    //         // Always check Inserts, but only check Updates when the Delivery Date just changed:
    //         Boolean checkDate = (Trigger.isInsert ||
    //                             Trigger.oldMap.get(cd.Id).Start_Date__c != cd.Start_Date__c);
                    
    //         if (checkDate && cd.Start_Date__C != NULL){
    //             if(allHolidays.contains(cd.Start_Date__c)){
    //                 cd.Start_Date__c.addError(label.Invalid_Delivery_Start_Date);
    //             }
    //         }
    //     }
        CourseDeliveryTriggerHandler.preventInvalidCourseDeliveries(Trigger.new, Trigger.oldMap);
    }
}