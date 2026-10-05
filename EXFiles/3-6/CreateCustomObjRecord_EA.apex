//TODO #1  Declare a variable whose type is Course__c named newCourse  
//         and initialize it to a newly constructed Course__c sObject,
//         assigning the field Name the value '[104] Introduction to Programming',
//         the field Course_Description__c the value 'Learn the basics of programming with OOP',
//         the field Status__c the value 'Active',
//         the field Duration__c the value 5.

//TODO #2  Use the insert statement to insert newCourse into the database.


public class DeliveryCreator{
    public void createNewCourseDelivery(String courseName, Integer numberOfDeliveries){
        Course__c newCourse = new Course__c(Name = courseName);
        insert newCourse;
        
        List<Course_Delivery__c> deliveries = new List<Course_Delivery__c>();

        for (Integer i = 1; i < numberOfDeliveries; i++){
            deliveries.add(new Course_Delivery__c(Course__c = newCourse.Id));
        }

        insert deliveries;
    }
}
