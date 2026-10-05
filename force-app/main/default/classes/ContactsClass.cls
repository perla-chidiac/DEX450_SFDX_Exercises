public with sharing class ContactsClass {
    public static void standaloneDML(){
        Contact name1 = new Contact(LastName = 'Minkowitz');
        Contact name2 = new Contact(LastName = 'Singh');
            
        List<Contact> contacts = new List<Contact>();
        contacts.add(name1);
        contacts.add(name2);
        
        insert contacts;
        
        System.debug('Name1 Id:' + name1.Id);
        System.debug('Name2 Id:' + name2.Id);
    }
    
    public static void databaseMethodDml(){
        Contact name1 = new Contact();
        Contact name2 = new Contact(LastName = 'Picasso');

        List<Contact> contacts = new List<Contact>();
        contacts.add(name1);
        contacts.add(name2);

        Database.insert(contacts);
    }

    public static void databaseMethodPartialCommit(){
        Contact name1 = new Contact();
        Contact name2 = new Contact(LastName = 'Picasso');
        
        List<Contact> contacts = new List<Contact>();
        contacts.add(name1);
        contacts.add(name2);

        Database.insert(contacts,false);
        System.debug('Name2 Id:' + name2.Id);
    }

    public static void exceptionsDML() {
        List<Contact> contacts = new List<Contact>();

        Contact noName = new Contact();
        contacts.add(noName);

        Contact newContact = new Contact(LastName = 'Benett');
        contacts.add(newContact);

        Contact longName = new Contact(LastName = '00085chars00085chars00085chars00085chars00085chars00085chars00085chars00085chars00085');
        contacts.add(longName);

        // A new list based on the current list - to use later.
        List<Contact> newListContact = new List<Contact>(contacts);

        // TODO #1: Declare a variable whose type is a List of Database.SaveResult
        //     sObjects named lsr and initialize it to the result of calling
        //     the insert method of the Database class passing in as parameters
        //     the list contacts and the Boolean value false to indicate a partial commit.
        List<Database.SaveResult> lsr = Database.insert(contacts, false);
		
        // TODO #2: Create a for loop with an iterator of type Database.SaveResult
        //     named sr that iterates over the List lsr.
        for (Database.SaveResult sr : lsr) {
		
            // TODO #3: Within the for loop create an if statement that uses the
            //     isSuccess method of the Database.SaveResult class to
            //     determine if the insert of sr was unsuccessful.
            if (!sr.isSuccess()) {
			
                // TODO #4: Within the if statement create a for loop with an iterator
                //     of type Database.Error named err that iterates over the
                //     result returned by calling the getErrors method of the
                //     class Database.SaveResult on the variable sr.
                for (Database.Error err : sr.getErrors() ){
				
                    // TODO #5: Create an Error_log__c entry that saves the results
                    //      of calling the getStatusCode method and the getMessage
                    //      method of the Database.error class on the err variable.
                    Error_Log__c error_DML = new Error_Log__c();
                    error_DML.Source__c = 'exceptionsDML';
                    System.debug('logLevel');
                    error_DML.Message__c = err.getMessage();
                    insert error_DML;
                }
            }
        }
        
        newListContact[1] = null;
        try {
            List<Database.SaveResult> lsr2 = Database.insert(newListContact, false);
        } catch(ListException e) {
            Error_Log__c error_null = new Error_Log__c();
            error_null.Source__c = 'exceptionsDML';
            error_null.Message__c = e.getMessage();
            insert error_null;
        }
    }
}