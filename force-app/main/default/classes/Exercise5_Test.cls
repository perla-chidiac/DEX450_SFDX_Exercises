@isTest
private class Exercise5_Test {
    @isTest
    static void testPaymentCalculationsAndValidations() {
        // 1. Setup: Create a test Opportunity with an Amount of 10,000
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Amount = 10000,
            Identifier__c = 'AAA'
        );
        insert opp;

        // 2. Test Insert: Add a Paid payment of 4,000
        Payment__c p1 = new Payment__c(
            Opportunity__c = opp.Id,
            Amount__c = 4000,
            Status__c = 'Paid',
            Payment_Date__c = Date.today()
        );
        insert p1;

        // Verify the Opportunity Total Paid updated to 4,000
        opp = [SELECT Total_Paid__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(4000, opp.Total_Paid__c, 'Total Paid should be 4000 after first payment.');

        // 3. Test Insert: Add a Pending payment of 3,000
        Payment__c p2 = new Payment__c(
            Opportunity__c = opp.Id,
            Amount__c = 3000,
            Status__c = 'Pending'
        );
        insert p2;

        // Verify Total Paid stays at 4,000 because p2 is Pending
        opp = [SELECT Total_Paid__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(4000, opp.Total_Paid__c, 'Total Paid should remain 4000 when adding a Pending payment.');

        // 4. Test Overlimit Rule: Add a Paid payment of 7,000 (4,000 + 7,000 = 11,000, which exceeds 10,000)
        Payment__c p3 = new Payment__c(
            Opportunity__c = opp.Id,
            Amount__c = 7000,
            Status__c = 'Paid',
            Payment_Date__c = Date.today()
        );
        
        Test.startTest();
        try {
            insert p3;
            System.assert(false, 'An exception should have been thrown because the total exceeds the Opportunity amount.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('cannot exceed the Opportunity amount'), 'The over-limit error message should be fired.');
        }

        // 5. Test Status Change (Cancellation): Update p1 from Paid to Cancelled
        p1.Status__c = 'Cancelled';
        update p1;

        // Verify Total Paid decrements down to 0 because no active Paid payments exist
        opp = [SELECT Total_Paid__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(0, opp.Total_Paid__c, 'Total Paid should drop to 0 after cancellation.');

        // 6. Test Delete Rule: Attempt to delete a Paid payment (Set p1 back to Paid first)
        p1.Status__c = 'Paid';
        update p1;

        try {
            delete p1;
            System.assert(false, 'An exception should have been thrown because a paid payment cannot be deleted.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('A paid payment cannot be deleted'), 'The delete block exception should be caught.');
        }
        Test.stopTest();
    }

    @isTest
    static void testOpportunityLookupChange() {
        // Setup: Create two opportunities
        Opportunity opp1 = new Opportunity(Name = 'Opp 1', StageName = 'Prospecting', CloseDate = Date.today(), Amount = 5000, Identifier__c = 'SSS');
        Opportunity opp2 = new Opportunity(Name = 'Opp 2', StageName = 'Prospecting', CloseDate = Date.today(), Amount = 5000, Identifier__c = 'GGG');
        insert new List<Opportunity>{opp1, opp2};

        // Create a Paid payment assigned to Opp 1
        Payment__c p = new Payment__c(Opportunity__c = opp1.Id, Amount__c = 2000, Status__c = 'Paid', Payment_Date__c = Date.today());
        insert p;

        // Reparent the payment to Opp 2
        p.Opportunity__c = opp2.Id;
        
        Test.startTest();
            update p;
        Test.stopTest();

        // Verify Opp 1 was recalculated down to 0 and Opp 2 was updated to 2000
        opp1 = [SELECT Total_Paid__c FROM Opportunity WHERE Id = :opp1.Id];
        opp2 = [SELECT Total_Paid__c FROM Opportunity WHERE Id = :opp2.Id];

        System.assertEquals(0, opp1.Total_Paid__c, 'Opp 1 Total Paid should be cleared out.');
        System.assertEquals(2000, opp2.Total_Paid__c, 'Opp 2 Total Paid should accumulate the moved payment.');
    }

    @isTest
    static void testBulkPayments() {
        // Setup: Create an Opportunity with a large amount
        Opportunity opp = new Opportunity(Name = 'Bulk Opp', StageName = 'Prospecting', CloseDate = Date.today(), Amount = 500000, Identifier__c = 'ASD');
        insert opp;


        // Build a bulk list of 200 Paid payment records
        List<Payment__c> bulkPayments = new List<Payment__c>();
        for (Integer i = 0; i < 200; i++) {
            bulkPayments.add(new Payment__c(
                Opportunity__c = opp.Id,
                Amount__c = 1000, // 200 * 1000 = 200,000 total paid
                Status__c = 'Paid',
                Payment_Date__c = Date.today()
            ));
        }

        Test.startTest();
            insert bulkPayments;
        Test.stopTest();

        // Verify your subquery handle calculations managed the loop without hitting limits
        opp = [SELECT Total_Paid__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(200000, opp.Total_Paid__c, 'Bulk insertion should process totals accurately.');
    }
}