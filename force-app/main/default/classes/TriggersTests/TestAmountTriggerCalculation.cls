/**
 * This class tests the trigger named AmountTriggerCalculation 
 */
@isTest
public with sharing class TestAmountTriggerCalculation {
    @isTest static void OrderTest(){
        //Test data setup
		TestDataFactory.accountGen(2,4000,7);

        //Perform test
        Test.startTest();
        List<Order> cmd = [select id, TotalAmount, NetAmount__c, ShipmentCost__c from Order];
        for(Order o:cmd){
            o.ShipmentCost__c = 20.00;
        }
        update cmd;
        Test.stopTest();

        // Verify 
        // In this case verify that the NetAmount__c is well updated     
        
        List<Order> AssertOrder = [Select TotalAmount, ShipmentCost__c, NetAmount__c from Order];
        System.AssertEquals(AssertOrder[0].TotalAmount - AssertOrder[0].ShipmentCost__c , AssertOrder[0].NetAmount__c);
		System.AssertEquals(AssertOrder[1].TotalAmount - AssertOrder[1].ShipmentCost__c , AssertOrder[1].NetAmount__c);
    }
}