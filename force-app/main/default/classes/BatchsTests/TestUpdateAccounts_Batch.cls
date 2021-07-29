/**
 * this test verify that the batch UpdateAccounts works well
 */
@isTest
public with sharing class TestUpdateAccounts_Batch {
	@testSetup
    static void setup() {
        //Test data setup
        TestDataFactory.accountGen(2,1000, 7);
    }
    @isTest static void test() {
        //Perform test
        Test.startTest();
        UpdateAccounts ua = new UpdateAccounts();
        Id batchJobId = Database.executeBatch(ua);
        Test.stopTest();
        
        List<Account> assAccountList = [Select Id, Chiffre_d_affaire__c from Account];
        // Verify 
        // In this case verify that the chiffre d'affaire is well updated     
        System.AssertEquals( 7000 , assAccountList[0].Chiffre_d_affaire__c);
        System.AssertEquals( 7000 , assAccountList[1].Chiffre_d_affaire__c);
    }   
}
